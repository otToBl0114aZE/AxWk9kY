# 代码生成时间: 2025-08-29 18:34:09
# FolderOrganizer is a class responsible for organizing a directory structure.
class FolderOrganizer < Grape::API
  # Initialize the API with a base path
  version 'v1', using: :header, vendor: 'folder_organizer'
  format :json

  # Define the root path for the folder structure
  helpers do
    def folder_path
      'path/to/your/folder' # Replace with your actual folder path
    end
  end

  # GET request to list files in the root directory
  get '/' do
    folders = Dir.entries(folder_path).select { |entry| File.directory?(File.join(folder_path, entry)) }
    files = Dir.entries(folder_path).select { |entry| File.file?(File.join(folder_path, entry)) }
    { folders: folders, files: files }
  end

  # POST request to create a new directory
  post '/mkdir' do
    params do
      requires :dir_name, type: String, desc: 'Directory name'
    end
    begin
      new_folder = File.join(folder_path, params[:dir_name])
      FileUtils.mkdir_p(new_folder)
      { message: "Directory '#{params[:dir_name]}' created successfully." }
    rescue StandardError => e
      error!('Error creating directory', 400)
    end
  end

  # DELETE request to delete a directory or file
  delete '/delete' do
    params do
      requires :path, type: String, desc: 'Path to directory or file'
    end
    begin
      path = File.join(folder_path, params[:path])
      if File.directory?(path)
        FileUtils.rm_rf(path)
        { message: "Directory '#{params[:path]}' deleted successfully." }
      elsif File.file?(path)
        File.delete(path)
        { message: "File '#{params[:path]}' deleted successfully." }
      else
        error!('Error deleting resource', 404)
      end
    rescue StandardError => e
      error!('Error deleting resource', 500)
    end
  end

  # PUT request to rename a directory or file
  put '/rename' do
    params do
      requires :old_name, type: String, desc: 'Old name of directory or file'
      requires :new_name, type: String, desc: 'New name of directory or file'
    end
    begin
      old_path = File.join(folder_path, params[:old_name])
      new_path = File.join(folder_path, params[:new_name])
      FileUtils.mv(old_path, new_path)
      { message: "Renamed '#{params[:old_name]}' to '#{params[:new_name]}' successfully." }
    rescue StandardError => e
      error!('Error renaming resource', 500)
    end
  end
end

# Run the FolderOrganizer API
# Uncomment the following line to run the API
# run!(:port => 8080)