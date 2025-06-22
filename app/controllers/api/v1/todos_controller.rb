class Api::V1::TodosController < ApplicationController
  before_action :set_todo, only: [ :show, :update, :destroy ]

  # GET /api/v1/todos
  def index
    @todos = Todo.all
    render json: @todos
  end

  # GET /api/v1/todos/1
  def show
    render json: @todo
  end

  # POST /api/v1/todos
  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      render json: @todo, status: :created
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/todos/1
  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/todos/1
  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :completed)
  end
end
