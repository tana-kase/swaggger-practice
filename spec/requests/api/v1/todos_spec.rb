require 'swagger_helper'

RSpec.describe 'Api::V1::Todos', type: :request do
  path '/api/v1/todos' do
    post 'Creates a todo' do
      tags 'Todos'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          todo: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string, nullable: true },
              completed: { type: :boolean }
            },
            required: ['title']
          }
        }
      }

      response '201', 'todo created' do
        let(:todo) { { todo: { title: 'foo', description: 'bar' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:todo) { { todo: { title: '' } } }
        run_test!
      end
    end

    get 'Lists all todos' do
      tags 'Todos'
      produces 'application/json'

      response '200', 'todos found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              description: { type: :string, nullable: true },
              completed: { type: :boolean },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            },
            required: ['id', 'title', 'completed']
          }
        
        run_test!
      end
    end
  end

  path '/api/v1/todos/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a todo' do
      tags 'Todos'
      produces 'application/json'

      response '200', 'todo found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            title: { type: :string },
            description: { type: :string, nullable: true },
            completed: { type: :boolean },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          },
          required: ['id', 'title', 'completed']

        let(:id) { Todo.create(title: 'foo').id }
        run_test!
      end
    end

    patch 'Updates a todo' do
      tags 'Todos'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          todo: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string, nullable: true },
              completed: { type: :boolean }
            }
          }
        }
      }

      response '200', 'todo updated' do
        let(:id) { Todo.create(title: 'foo').id }
        let(:todo) { { todo: { title: 'bar' } } }
        run_test!
      end
    end

    delete 'Deletes a todo' do
      tags 'Todos'
      
      response '204', 'todo deleted' do
        let(:id) { Todo.create(title: 'foo').id }
        run_test!
      end
    end
  end
end