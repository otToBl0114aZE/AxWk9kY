# 代码生成时间: 2025-08-09 02:34:04
# RandomNumberGenerator.rb
#
# This is a simple Ruby application using the Grape framework to
# provide an API for generating random numbers within a specified range.

require 'grape'
require 'grape-entity'
require 'securerandom'

# Define the API version
module API
  module V1
    class RandomNumberGenerator < Grape::API
      # Define a namespace for the RandomNumberGenerator API
      namespace :random_number_generator do
        # Endpoint to generate a random number within the specified range
        get do
          # Parameters for the API endpoint
          params do
            requires :min, type: Integer, desc: 'Minimum value of the range'
            requires :max, type: Integer, desc: 'Maximum value of the range'
          end

          # Error handling for invalid input
          error do
            on(Grape::Exceptions::InvalidParams) do
              { error: 'Invalid parameters', status: 400 }
            end
          end

          # Generate and return the random number within the specified range
          # or return an error message if the input parameters are invalid
          if params[:max] >= params[:min]
            random_number = SecureRandom.random_number(params[:max] - params[:min] + 1) + params[:min]
            { random_number: random_number }
          else
            error!('Range error: Max must be greater than or equal to Min', 400)
          end
        end
      end
    end
  end
end

# Run the Grape API application
run!(API::V1::RandomNumberGenerator) if __FILE__ == $0
