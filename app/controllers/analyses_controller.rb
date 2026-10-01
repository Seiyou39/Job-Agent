class AnalysesController < ApplicationController
  before_action :set_analysis, only: [:show, :destroy]

  def new
    @user = Current.user
  end

  def create
    jd = params[:jd_text]
    resume = Current.user.resume_text

    result = ClaudeMatcherService.new(jd: jd, resume: resume).call
    score = result["match_score"].to_i.clamp(0, 100)

    ActiveRecord::Base.transaction do
      todo_list = Current.user.todo_lists.create!(
        title: "#{result['company_name']} の対策",
        source: :llm_generated
      )

      @analysis = Current.user.analyses.create!(
        todo_list: todo_list,
        company_name: result["company_name"],
        job_title: result["job_title"],
        location: result["location"],
        match_score: score,
        advice: result["advice"],
        strengths: Array(result["strengths"]),
        skill_gaps: Array(result["skill_gaps"]),
        interview_questions: Array(result["interview_questions"])
      )

      Array(result["todolist"]).each do |item|
        todo_list.todos.create!(
          task: item["task"],
          priority: item["priority"],
          done: false
        )
      end
    end

    redirect_to analysis_path(@analysis), notice: "分析が完了しました"
  rescue => e
    Rails.logger.error("Analysis failed: #{e.class} #{e.message}")
    redirect_to new_analysis_path, alert: "分析に失敗しました。しばらくしてからもう一度お試しください。"
  end

  def show
    @analysis = Current.user.analyses.find(params[:id])
    @predicted_rent = RentPredictorService.predict(@analysis.location) if @analysis.location_valid?
  end

  def destroy
    @analysis.destroy
    redirect_to root_path, notice: "分析を削除しました"
  end

  private

  def set_analysis
    @analysis = Current.user.analyses.find(params[:id])
  end
end
