# 代码生成时间: 2025-08-02 07:42:13
# Define a simple entity for our API response
class LayoutEntity < Grape::Entity
  expose :id, documentation: { type: 'integer', desc: 'Unique identifier for the layout' }
  expose :name, documentation: { type: 'string', desc: 'Name of the layout' }
  expose :width, documentation: { type: 'integer', desc: 'Width of the layout' }
  expose :height, documentation: { type: 'integer', desc: 'Height of the layout' }
end

# Define the API version
module API
  module V1
    # Define the Layout API
    class Layouts < Grape::API
      format :json
      prefix 'api'
      
      # Get all layouts
      get 'layouts' do
        # Fetch all layouts from the database (mocked as an array for simplicity)
        layouts = [
          { id: 1, name: 'Small Layout', width: 320, height: 480 },
          { id: 2, name: 'Medium Layout', width: 768, height: 1024 },
          { id: 3, name: 'Large Layout', width: 1920, height: 1080 }
        ]
        
        # Return the layouts with proper error handling
        begin
          layouts.map { |layout| LayoutEntity.represent(layout) }
        rescue => e
          error!(error: e.message, status: 500)
        end
      end
      
      # Get a single layout by ID
      get 'layouts/:id' do
        # Fetch the layout by ID from the database (mocked as an array for simplicity)
        layouts = [
          { id: 1, name: 'Small Layout', width: 320, height: 480 },
          { id: 2, name: 'Medium Layout', width: 768, height: 1024 },
          { id: 3, name: 'Large Layout', width: 1920, height: 1080 }
        ]
        
        # Find the layout by ID and return it with proper error handling
        layout = layouts.find { |l| l[:id] == params[:id].to_i }
        if layout
          LayoutEntity.represent(layout)
        else
          error!(error: 'Layout not found', status: 404)
        end
      end
    end
  end
end

# Mount the API under the /api path
map '/api' do
  run API::V1::Layouts
end

# Start the server if this file is executed directly
run! if app_file == $0