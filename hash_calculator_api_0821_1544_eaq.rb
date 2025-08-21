# 代码生成时间: 2025-08-21 15:44:14
# hash_calculator_api.rb
require 'digest'
require 'grape'

# Define the HashCalculator API
# FIXME: 处理边界情况
class HashCalculatorAPI < Grape::API
  # Endpoint for calculating SHA256 hash of a given string
  get '/hash/sha256' do
    # Extract the input string from the params
    input_string = params[:input]

    # Check if the input string is provided
# 增强安全性
    if input_string.nil? || input_string.empty?
      error!('BadRequest', 400, 'Input string is required.')
    end

    # Calculate the SHA256 hash
    hash = Digest::SHA256.hexdigest(input_string)

    # Return the hash as a JSON response
    { hash: hash }
  end
end

# Error handling for bad requests
HashCalculatorAPI rescue_from Grape::Exceptions::ValidationErrors do |e|
  error!('BadRequest', 400, e.message)
end

# Run the API on localhost:9292
HashCalculatorAPI.instance_variable_set('@endpoint', HashCalculatorAPI)
HashCalculatorAPI.endpoint = '0.0.0.0:9292'
