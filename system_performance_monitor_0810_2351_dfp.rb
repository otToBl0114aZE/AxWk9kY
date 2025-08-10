# 代码生成时间: 2025-08-10 23:51:45
# SystemPerformanceMonitor is a Sinatra-based API that provides system performance metrics.
class SystemPerformanceMonitor < Sinatra::Base
  # Endpoint to retrieve CPU usage
  get '/cpu_usage' do
    # Fetch CPU usage percentage
    cpu_usage = `top -bn1 | grep load | awk '{print $2 + $3}'`.strip.split('/').map(&:to_f).last
    content_type :json
    { cpu_usage: cpu_usage }.to_json
  end

  # Endpoint to retrieve memory usage
  get '/memory_usage' do
    # Fetch memory usage information
    memory = Sys::Filesystem.stat('/')
    content_type :json
    { total_memory: memory.block_size * memory.block_count,
      used_memory: memory.block_size * (memory.block_count - memory.block_available) }.to_json
  end

  # Endpoint to retrieve disk usage
  get '/disk_usage' do
    # Fetch disk usage information
    disk_usage = Sys::Filesystem.stat('/')
    content_type :json
    { total_disk: disk_usage.block_size * disk_usage.block_count,
      used_disk: disk_usage.block_size * (disk_usage.block_count - disk_usage.block_available) }.to_json
  end

  # Endpoint to retrieve process list
  get '/processes' do
    # Fetch the list of all processes
    processes = Sys::ProcTable.ps.map do |process|
      { pid: process.pid,
        process_name: process.name,
        state: process.state,
        parent_id: process.ppid,
        start_time: process.start_time,
        cpu_usage: process.cpu_usage,
        memory_usage: process.memory_usage }
    end
    content_type :json
    processes.to_json
  end

  # Error handling for not found routes
  not_found do
    content_type :json
    { error: 'Not found' }.to_json
  end

  # Error handling for internal server errors
  error do
    content_type :json
    { error: 'Internal server error' }.to_json
  end
end

# Run the application if this file is executed directly
run! if app_file == $0