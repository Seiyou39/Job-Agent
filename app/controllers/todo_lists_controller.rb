class TodoListsController < ApplicationController
  before_action :set_todo_list, only: [:show, :edit, :update, :destroy]

  # GET /todo_lists
  def index
    @todo_lists = Current.user.todo_lists
  end

  # GET /todo_lists/new
  def new
    @todo_list = TodoList.new
  end

  # POST /todo_lists
  def create
    @todo_list = Current.user.todo_lists.build(todo_list_params)
    @todo_list.source = :manual

    if @todo_list.save
      redirect_to @todo_list, notice: "Checklist created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /todo_lists/
  def show
    @todo = @todo_list.todos.build
  end

  # GET /todo_lists/:id/edit 
  def edit
  end

  # PATCH/PUT /todo_lists/:id
  def update
    if @todo_list.update(todo_list_params)
      redirect_to @todo_list, notice: "List updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /todo_lists/:id
  def destroy
    @todo_list.destroy
    redirect_to todo_lists_path, notice: "List deleted successfully"
  end
  private

  def set_todo_list
    @todo_list = Current.user.todo_lists.find(params[:id])
  end

  def todo_list_params
    params.require(:todo_list).permit(:title)
  end
end
