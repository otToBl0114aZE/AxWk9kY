# 代码生成时间: 2025-08-10 14:13:20
# batch_file_renamer.rb
#
# This Ruby program uses the Grape framework to create a simple batch file renaming tool.
# It demonstrates basic Grape API setup, error handling, and usage of Ruby best practices.

require 'grape'
require 'fileutils'

# Define a new Grape API
class RenameAPI < Grape::API
  # Define the version of the API
  version 'v1', using: :header, vendor: 'file_rename_tool'

  # Define a namespace for the rename operations
  namespace :rename do
    # The route for batch file renaming
    post do
      # Check for the presence of the 'files' parameter which is expected to be an array
      if params[:files].nil? || !params[:files].is_a?(Array)
        Rack::Response.new('Missing or invalid files parameter', 400).finish
      end

      # Iterate over the files and attempt to rename them
      params[:files].each do |file_info|
        source_path = file_info['source']
        target_path = file_info['target']

        # Check if source and target paths are provided
        if source_path.nil? || target_path.nil?
          Rack::Response.new('Missing source or target path', 400).finish
        end

        # Check if the source file exists
        unless File.exist?(source_path)
          Rack::Response.new(