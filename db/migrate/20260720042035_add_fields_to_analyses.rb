class AddFieldsToAnalyses < ActiveRecord::Migration[8.1]
  def change
    add_column :analyses, :location, :string
    add_column :analyses, :strengths, :text
    add_column :analyses, :skill_gaps, :text
    add_column :analyses, :interview_questions, :text
  end
end
