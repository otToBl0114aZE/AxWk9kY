# 代码生成时间: 2025-09-04 13:50:23
# RandomNumberAPI class
class RandomNumberAPI < Grape::API
  # Endpoint to generate a random number between two given numbers
  get '/generate' do
    # Parse input parameters from the query string
    lower_bound = params[:lower].to_i
    upper_bound = params[:upper].to_i

    # Error handling for missing or invalid parameters
    error!('Missing lower bound', 400) if lower_bound.nil?
    error!('Missing upper bound', 400) if upper_bound.nil?
    error!('Lower bound must be less than upper bound', 400) if lower_bound >= upper_bound

    # Generate a random number within the specified range
    random_number = SecureRandom.random_number(upper_bound - lower_bound + 1) + lower_bound

    # Return the generated random number
    {
      status: 'success',
      random_number: random_number
    }
  end
end

# Usage documentation
# To use the API, send a GET request to /generate with query parameters lower and upper,
# representing the lower and upper bounds of the range, respectively.
# Example: GET /generate?lower=1&upper=100
