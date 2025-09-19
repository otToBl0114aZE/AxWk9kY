# 代码生成时间: 2025-09-19 21:03:21
# SchedulerService is a Sinatra application that uses Rufus-scheduler
# to schedule tasks. It provides a RESTful API to manage the tasks.
class SchedulerService < Sinatra::Base
  # Logger setup
  config = YAML.load_file('config/database.yml')
  ActiveRecord::Base.establish_connection(config['development'])
  set :database_file, 'config/database.yml'
  enable :logging
  logger = Logger.new(STDOUT)

  # Rufus scheduler setup
  scheduler = Rufus::Scheduler.new

  # Routes
  get '/' do
    "Welcome to the Scheduler Service!"
  end

  post '/tasks' do
    content_type :json
    # Parse JSON request body
    task = JSON.parse(request.body.read)
    # Schedule the task
    begin
      job = scheduler.every(task['interval'], name: task['name']) {
        Task.run_task(task['name'])
      }
      logger.info("Scheduled task: #{task['name']}")
      status 201
      { id: job.job_id }.to_json
    rescue Rufus::Scheduler::InvalidIntervalError => e
      logger.error("Invalid interval: #{e.message}")
      status 400
      { error: "Invalid interval: #{e.message}" }.to_json
    rescue Exception => e
      logger.error("Error scheduling task: #{e.message}")
      status 500
      { error: "Error scheduling task: #{e.message}" }.to_json
    end
  end

  get '/tasks/:id' do
    content_type :json
    # Find and return the task by ID
    job_id = params['id']
    job = scheduler.job(job_id)
    if job
      { id: job.job_id, name: job.name, interval: job.interval }.to_json
    else
      status 404
      { error: 'Task not found' }.to_json
    end
  end

  delete '/tasks/:id' do
    # Cancel the task by ID
    job_id = params['id']
    job = scheduler.job(job_id)
    if job
      scheduler.unschedule(job.job_id)
      logger.info("Canceled task: #{job.name}")
      status 200
      { message: 'Task canceled' }.to_json
    else
      status 404
      { error: 'Task not found' }.to_json
    end
  end

  run! if app_file == $0
end

# Models
module Models
  class Task < ActiveRecord::Base
    # This method should be implemented to perform the actual task
    def self.run_task(name)
      # TODO: Implement task logic here
      puts "Running task: #{name}"
    end
  end
end
