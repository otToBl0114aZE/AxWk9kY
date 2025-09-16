# 代码生成时间: 2025-09-16 13:40:39
# ProcessManager is a Grape API that allows users to manage processes.
class ProcessManager < Grape::API
  # Namespace for Process Management
  namespace :processes do
    # List all processes
    get do
      # Call the system command 'ps' to get a list of processes
      output, _status = Open3.capture2('ps')
      # Return the list of processes as JSON
      { processes: output.lines.map(&:chomp) }.to_json
    end

    # Start a new process
    params do
      requires :command, type: String, desc: 'The command to run'
    end
    post '/start' do
      begin
        # Execute the provided command in a new process
        pid = spawn(params[:command])
        process = Process.detach(pid)
        # Return the PID of the new process
        { pid: pid }.to_json
      rescue StandardError => e
        # Handle errors and return a JSON error message
        error!("Failed to start process: #{e.message}", 400)
      end
    end

    # Stop a process by PID
    params do
      requires :pid, type: Integer, desc: 'The Process ID'
    end
    post '/stop' do
      begin
        # Find the process by PID and terminate it
        pid = params[:pid]
        Process.kill('TERM', pid)
        # Return a success message
        { message: "Process with PID #{pid} has been terminated" }.to_json
      rescue StandardError => e
        # Handle errors and return a JSON error message
        error!("Failed to stop process: #{e.message}", 400)
      end
    end
  end
end

# Run the Grape API server
run! if __FILE__ == $0