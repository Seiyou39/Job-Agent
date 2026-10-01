class ProfilesController < ApplicationController
  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    if @user.update(profile_params)
      redirect_to root_path, notice: "履歴書を保存しました"
    else
      render :edit, status: :unprocessable_entity
    end  
  end

  private

  def profile_params
    params.require(:user).permit(:resume_text)
  end
end
