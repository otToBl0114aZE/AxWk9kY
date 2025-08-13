# 代码生成时间: 2025-08-13 16:47:47
# A simple Grape API for hashing
class HashCalculatorAPI < Grape::API
  # Define a route for calculating the SHA256 hash of a string
  get '/:algorithm/:input' do
    # Extract the algorithm and input from the route parameters
    algorithm = params[:algorithm]
    input = params[:input]

    # Check if the algorithm is supported
    unless Digest::SHA2.constants.include?(algorithm.upcase)
      error!('Unsupported algorithm', 400)
    end

    # Calculate the hash using the specified algorithm
    hash = Digest.const_get(algorithm.upcase).hexdigest(input)

    # Return the hash in a JSON format
    { hash: hash }.to_json
  end
end

# Define the supported algorithms
SUPPORTED_ALGORITHMS = %w[SHA256 SHA384 SHA512]

# Create the API instance
api = HashCalculatorAPI.new

# Define error formatter for Grape
Grape::ErrorFormatters.printable_status = lambda do |e|
  # Handle errors with a custom status code and message
  case e.status
  when 400
    "Bad Request: #{e.message}"
  else
    e.message
  end
end

# Run the Grape API, this requires a Rack server like Thin, Puma, or Unicorn
# api.run!

# Note: Uncomment the 'api.run!' line and comment out the '# Run the Grape API'
# when you are ready to run the application with a server.

# Documentation for the API
# The HashCalculatorAPI provides a simple RESTful API to calculate
# hashes for a given input using one of the supported algorithms.
# To use this API, send a GET request to '/<algorithm>/<input>',
# where <algorithm> is one of the supported algorithms (SHA256, SHA384, SHA512)
# and <input> is the string to be hashed.
# The response will be a JSON object containing the calculated hash.
