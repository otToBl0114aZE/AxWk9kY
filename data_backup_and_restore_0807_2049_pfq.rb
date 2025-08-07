# 代码生成时间: 2025-08-07 20:49:47
# DataBackupAndRestore API allows users to backup and restore data.
class DataBackupAndRestoreAPI < Grape::API
  # Define the version of the API
  version 'v1', using: :header, vendor: 'mycompany'

  # Namespace for backup operations
  namespace :backup do
    # Endpoint for creating a backup
    post do
      # Extract backup file name from params
      file_name = params[:file_name]

      # Check if file name is provided
      if file_name.nil?
        error!('Missing file_name parameter', 400)
      end

      # Create a backup file
      begin
        backup_file_path = "backups/\#{file_name}.tar"
        system("tar -cvf "#{backup_file_path}" data/")
        if $?.exitstatus != 0
          error!('Failed to create backup', 500)
        end

        # Return success message with backup file path
        { status: 'Success', backup_file: backup_file_path }
      rescue => e
        # Handle any unexpected errors
        error!(e.message, 500)
      end
    end
  end

  # Namespace for restore operations
  namespace :restore do
    # Endpoint for restoring from a backup file
    post do
      # Extract backup file name from params
      file_name = params[:file_name]

      # Check if file name is provided
      if file_name.nil?
        error!('Missing file_name parameter', 400)
      end

      # Restore data from backup file
      begin
        backup_file_path = "backups/\#{file_name}.tar"
        system("tar -xvf "#{backup_file_path}" -C data/")
        if $?.exitstatus != 0
          error!('Failed to restore data', 500)
        end

        # Return success message with backup file path
        { status: 'Success', backup_file: backup_file_path }
      rescue => e
        # Handle any unexpected errors
        error!(e.message, 500)
      end
    end
  end
end
