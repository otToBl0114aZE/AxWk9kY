# 代码生成时间: 2025-10-06 01:34:26
# Matrix Operations API using Grape framework
class MatrixOperationsAPI < Grape::API
  helpers do
    # Helper method to parse matrix from param
    def parse_matrix(params)
      unless params.is_a?(Array) && params.all? { |item| item.is_a?(Array) && item.all? { |i| i.is_a?(Numeric) } }
        raise Grape::Exceptions::InvalidParameter, 'Invalid matrix format'
      end
      return Matrix[*params]
    end
  end

  namespace :matrix do
    # Get the sum of two matrices
    get :add do
      params do
        requires :matrix_a, type: Array, desc: 'First matrix'
        requires :matrix_b, type: Array, desc: 'Second matrix'
      end
      error_format = ->(message) { { error: message }.to_json }
      matrix_a = parse_matrix(params[:matrix_a])
      matrix_b = parse_matrix(params[:matrix_b])
      if matrix_a.row_count == matrix_b.row_count && matrix_a.column_count == matrix_b.column_count
        present Matrix[matrix_a, matrix_b].sum, with: Grape::Presenters::ROAR::Representable::Decorator
      else
        error!('Matrices dimensions do not match', 400).and_return(error_format.call('Matrices dimensions do not match'))
      end
    end

    # Get the product of two matrices
    get :multiply do
      params do
        requires :matrix_a, type: Array, desc: 'First matrix'
        requires :matrix_b, type: Array, desc: 'Second matrix'
      end
      error_format = ->(message) { { error: message }.to_json }
      matrix_a = parse_matrix(params[:matrix_a])
      matrix_b = parse_matrix(params[:matrix_b])
      if matrix_a.column_count == matrix_b.row_count
        present matrix_a * matrix_b, with: Grape::Presenters::ROAR::Representable::Decorator
      else
        error!('Matrices dimensions do not match for multiplication', 400).and_return(error_format.call('Matrices dimensions do not match for multiplication'))
      end
    end
  end
end

# Grape::Presenters::ROAR::Representable::Decorator is used to represent the matrices as JSON objects
module Grape::Presenters::ROAR::Representable::Decorator
  # Override represent method to convert the Matrix object to a JSON-friendly form
  def represent(collection, options)
    if collection.is_a?(Matrix)
      {
        rows: collection.row_count,
        columns: collection.column_count,
        elements: collection.to_a
      }
    else
      super
    end
  end
end

# Define the error formatter as a middleware to format errors
class MatrixOperationsErrorFormatter
  def initialize(app, format: :json)
    @app = app
    @format = format
  end

  def call(env)
    status, headers, body = @app.call(env)
    if status >= 400
      body = body.map { |b| b.is_a?(String) ? JSON.parse(b) : b } if @format == :json
      new_body = { error: body.first['error'] }.to_json
      headers['Content-Type'] = 'application/json'
      body = [new_body]
    end
    [status, headers, body]
  end
end

# Mount the MatrixOperationsAPI at the root path
options = { format: :json }
Rack::Handler::WEBrick.run(MatrixOperationsAPI, :Port => 9292) do |server|
  use MatrixOperationsErrorFormatter, options
end