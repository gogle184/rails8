# spec/requests/todos_spec.rb
require 'swagger_helper'

RSpec.describe 'Todos API', type: :request do
  path '/api/v1/todos' do
    get 'List all todos' do
      tags 'Todos'
      produces 'application/json'

      response '200', 'todos found' do
        schema type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer },
                    title: { type: :string },
                    completed: { type: :boolean },
                    created_at: { type: :string, format: :datetime },
                    updated_at: { type: :string, format: :datetime }
                  },
                  required: [ 'id', 'title', 'completed', 'created_at', 'updated_at' ]
                }

        let!(:todos) { create_list(:todo, 2) }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
        end
      end
    end

    post 'Create a todo' do
      tags 'Todos'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          completed: { type: :boolean }
        },
        required: [ 'title' ]
      }

      response '201', 'todo created' do
        schema type: :object,
                properties: {
                  id: { type: :integer },
                  title: { type: :string },
                  completed: { type: :boolean },
                  created_at: { type: :string, format: :datetime },
                  updated_at: { type: :string, format: :datetime }
                },
                required: [ 'id', 'title', 'completed', 'created_at', 'updated_at' ]

        let(:todo) { { title: 'Buy groceries', completed: false } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['title']).to eq('Buy groceries')
        end
      end

      response '422', 'invalid request' do
        let(:todo) { { title: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/todos/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Todo ID'

    get 'Show a todo' do
      tags 'Todos'
      produces 'application/json'

      response '200', 'todo found' do
        schema type: :object,
                properties: {
                  id: { type: :integer },
                  title: { type: :string },
                  completed: { type: :boolean },
                  created_at: { type: :string, format: :datetime },
                  updated_at: { type: :string, format: :datetime }
                },
                required: [ 'id', 'title', 'completed', 'created_at', 'updated_at' ]

        let!(:todo) { create(:todo) }
        let(:id) { todo.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(todo.id)
        end
      end

      response '404', 'todo not found' do
        let(:id) { 999999 }
        run_test!
      end
    end

    put 'Update a todo' do
      tags 'Todos'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          completed: { type: :boolean }
        }
      }

      response '200', 'todo updated' do
        schema type: :object,
                properties: {
                  id: { type: :integer },
                  title: { type: :string },
                  completed: { type: :boolean },
                  created_at: { type: :string, format: :datetime },
                  updated_at: { type: :string, format: :datetime }
                },
                required: [ 'id', 'title', 'completed', 'created_at', 'updated_at' ]

        let!(:existing_todo) { create(:todo) }
        let(:id) { existing_todo.id }
        let(:todo) { { title: 'Updated title', completed: true } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['title']).to eq('Updated title')
        end
      end

      response '422', 'invalid request' do
        let!(:existing_todo) { create(:todo) }
        let(:id) { existing_todo.id }
        let(:todo) { { title: '' } }
        run_test!
      end

      response '404', 'todo not found' do
        let(:id) { 999999 }
        let(:todo) { { title: 'Updated title' } }
        run_test!
      end
    end

    delete 'Delete a todo' do
      tags 'Todos'

      response '204', 'todo deleted' do
        let!(:existing_todo) { create(:todo) }
        let(:id) { existing_todo.id }

        run_test! do |response|
          expect(response.body).to be_empty
        end
      end

      response '404', 'todo not found' do
        let(:id) { 999999 }
        run_test!
      end
    end
  end
end
