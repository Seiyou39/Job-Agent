class DashboardController < ApplicationController
  def show
    @user = Current.user
    @analyses = Current.user.analyses.order(created_at: :desc)
    @todo_lists = Current.user.todo_lists.order(created_at: :desc)
  end
end
