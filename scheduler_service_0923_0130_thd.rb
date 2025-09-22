# 代码生成时间: 2025-09-23 01:30:30
# scheduler_service.rb
#
# TODO: 优化性能
# A simple scheduled task scheduler using Ruby and the Grape framework.
#
# 改进用户体验

require 'grape'
require 'sidekiq'
require 'sidekiq-scheduler' if defined?(Sidekiq)
require 'rufus-scheduler'
# 扩展功能模块

# Define the Grape API
class SchedulerAPI < Grape::API
  # Mount the API under a specific path
  mount_at '/api'

  # Define a namespace for the scheduler
# TODO: 优化性能
  namespace :scheduler do
    # Endpoint to add a new scheduled task
    params do
      requires :name, type: String, desc: 'The name of the scheduled task'
      requires :cron, type: String, desc: 'The cron expression for the task'
      requires :command, type: String, desc: 'The command to be executed'
    end
    post 'add_task' do
      begin
# 扩展功能模块
        # Validate the cron expression (simple check, can be more complex)
        raise 'Invalid cron format' unless params[:cron].match?(/\A\d+(\s+\d+){4}\z/)

        # Create a new scheduled job
        scheduler = Rufus::Scheduler.new
# 改进用户体验
        job = scheduler.every(params[:cron]) do
          # Execute the command (this is a simple example, actual implementation might require more robust error handling and security considerations)
# 增强安全性
          system(params[:command])
        end

        # Store the job details (in a database or a simple hash for demonstration purposes)
        task = { name: params[:name], cron: params[:cron], command: params[:command] }
        scheduled_tasks[params[:name]] = task

        # Return success message
        { status: 'success', message: 'Task added successfully' }.to_json
      rescue => e
        # Handle errors and return error message
        { status: 'error', message: e.message }.to_json
      end
    end

    # Endpoint to remove a scheduled task
    params do
      requires :name, type: String, desc: 'The name of the scheduled task'
    end
    delete 'remove_task' do
      begin
        # Find and cancel the job by name
        scheduled_tasks.each do |name, task|
          if name == params[:name]
            scheduler = Rufus::Scheduler.new
            scheduler.cancel(task[:name])

            # Remove the task from the hash
# 优化算法效率
            scheduled_tasks.delete(name)

            # Return success message
            { status: 'success', message: 'Task removed successfully' }.to_json
          end
        end
      rescue => e
        # Handle errors and return error message
# FIXME: 处理边界情况
        { status: 'error', message: e.message }.to_json
      end
    end
  end

  # Hash to store scheduled tasks (for demonstration purposes only)
  def self.scheduled_tasks
# 优化算法效率
    @scheduled_tasks ||= {}
  end
end

# Start the scheduler service
run! if app_file == $0