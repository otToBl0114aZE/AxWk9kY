# 代码生成时间: 2025-08-03 16:55:00
# TextFileAnalyzer is a simple API that performs analysis on the content of a text file.
class TextFileAnalyzer < Grape::API
  # Version of the API
  version 'v1', using: :header, vendor: 'text_file_analyzer'
  # Prefix for the API routes
  prefix :analysis

  # Helper method to calculate the SHA256 hash of a file's content
  def self.sha256_hash(content)
    Digest::SHA256.hexdigest(content)
  end

  # Helper method to calculate the size of a file in a human-readable format
  def self.human_readable_size(size)
    Filesize.new(size).to_s
  end

  # Helper method to determine the file encoding
  def self.file_encoding(content)
    chardet = CharlockHolmes::Engine.detect(content)
    chardet ? chardet.first : 'Unknown'
  end

  # Route to analyze the content of a text file
  params do
    requires :file, type: Rack::Multipart::UploadedFile
  end
  post 'analyze' do
    # Error handling for missing file parameter
    error!('Missing file parameter', 400) unless params[:file].present?

    # Ensure the uploaded file is a text file
    unless params[:file].content_type.start_with?('text/')
      error!('File must be of type text', 400)
    end

    # Read the file content
    content = params[:file].read
    begin
      # Calculate the SHA256 hash of the file content
      file_hash = TextFileAnalyzer.sha256_hash(content)
      # Calculate the size of the file in a human-readable format
      file_size = TextFileAnalyzer.human_readable_size(content.bytesize)
      # Determine the encoding of the file
      encoding = TextFileAnalyzer.file_encoding(content)
      # Return the analysis result as JSON
      status 200
      {
        file_hash: file_hash,
        file_size: file_size,
        encoding: encoding
      }.to_json
    rescue => e
      # Handle any unexpected exceptions
      error!("An error occurred while analyzing the file: #{e.message}", 500)
    end
  end
end
