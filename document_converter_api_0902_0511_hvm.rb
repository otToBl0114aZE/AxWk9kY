# 代码生成时间: 2025-09-02 05:11:05
# document_converter_api.rb
# A Grape API endpoint to convert documents between different formats.

require 'grape'
require 'mimemagic'
require 'tempfile'
require 'open-uri'

class DocumentConverterAPI < Grape::API
  # Define the version of the API
  version 'v1', using: :path

  # Define the format of the API
  format :json

  # Define the root path for the API
  get '/' do
    { message: 'Welcome to the Document Converter API!' }
  end

  # Define the endpoint for converting documents
  params do
    requires :input_url, type: String, desc: 'URL to the input document'
    requires :output_format, type: String, desc: 'Desired output format'
  end
  post ':convert' do
    # Error handling for missing parameters
    error!('Input URL is required', 400) if params[:input_url].nil?
    error!('Output format is required', 400) if params[:output_format].nil?

    # Download the document from the provided URL
    begin
      document = URI.open(params[:input_url])
    rescue OpenURI::HTTPError => e
      error!('Failed to download document', 400, e.message)
    end

    # Determine the MIME type of the document
# 优化算法效率
    mime_type = MimeMagic.by_buffer(document.read).type
    document.rewind # Reset the position of the file pointer

    # Check if the document can be converted to the desired format
    unless MimeMagic.accepts_input_to_output?(mime_type, params[:output_format])
      error!('Conversion not supported', 400)
    end

    # Create a temporary file for the document conversion
    temp_file = Tempfile.new(['document', File.extname(params[:input_url])])
    temp_file.write(document.read)
    temp_file.rewind # Reset the position of the file pointer

    # Perform the conversion
    converted_file = Tempfile.new(['converted', 