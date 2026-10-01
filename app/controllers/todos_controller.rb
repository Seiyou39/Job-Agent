class TodosController < ApplicationController
  before_action :set_todo_list
  before_action :set_todo, only: [:update, :destroy, :edit]

  # POST /todo_lists/:todo_list_id/todos
  def create
    @todo = @todo_list.todos.build(todo_params)

    if @todo.save
      redirect_to @todo_list, notice: "Checklist created successfully"
    else
      redirect_to @todo_list, alert: "Checklist creation failed"
    end
  end

  # PATCH/PUT /todo_lists/:todo_list_id/todos/:id
  def update
    if @todo.update(todo_params)
      redirect_to @todo_list, notice: "Checklist updated successfully"
    else
      redirect_to @todo_list, alert: "Checklist update failed"
    end
  end

  # DELETE /todo_lists/:todo_list_id/todos/:id
  def destroy
    @todo.destroy
    redirect_to todo_list_path(@todo_list), notice: "Checklist deleted"
  end
  
  def edit
  end

  private

  def set_todo_list
    @todo_list = Current.user.todo_lists.find(params[:todo_list_id])
  end

  def set_todo
    @todo = @todo_list.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:task, :priority, :done)
  end
  
end
