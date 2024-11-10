module Api
    module V1
      class TodosController < ApplicationController
        def index
          todos = Todo.order(created_at: :desc)
          render json: todos
        end
  
        def show
          todo = Todo.find(params[:id])
          render json: todo
        end
  
        def create
          todo = Todo.new(todo_params)
          if todo.save
            render json: todo, status: :created
          else
            render json: { errors: todo.errors }, status: :unprocessable_entity
          end
        end
  
        def update
          todo = Todo.find(params[:id])
          if todo.update(todo_params)
            render json: todo
          else
            render json: { errors: todo.errors }, status: :unprocessable_entity
          end
        end
  
        def destroy
          todo = Todo.find(params[:id])
          todo.destroy
          head :no_content
        end
  
        private
  
        def todo_params
          params.require(:todo).permit(:title, :description, :completed)
        end
      end
    end
  end