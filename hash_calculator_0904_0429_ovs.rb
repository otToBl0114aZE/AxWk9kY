# 代码生成时间: 2025-09-04 04:29:59
# HashCalculator API v1
class HashCalculatorAPI < Grape::API
  # Root path for the API
  get '/' do
    'Welcome to the Hash Calculator API!'
  end

  # Endpoint to calculate hash
  params do
    requires :input, type: String, desc: 'String to calculate hash'
    optional :algorithm, type: String, values: ['md5', 'sha1', 'sha256', 'sha512'], default: 'md5', desc: 'Hash algorithm to use'
  end
  get ':algorithm/:string' do
    # Extract parameters
    input = params[:string]
    algorithm = params[:algorithm]

    # Error handling for invalid input
    error!('Invalid input', 400) unless input.is_a?(String)

    # Error handling for unsupported algorithm
    unless ['md5', 'sha1', 'sha256', 'sha512'].include?(algorithm)
      error!('Unsupported algorithm', 400)
    end

    # Calculate hash
    hash_value = Digest.const_get(algorithm.upcase).hexdigest(input)

    # Return hash value
    { hash: hash_value }
  end
end

# Run the API on port 9292
HashCalculatorAPI::instance.run!