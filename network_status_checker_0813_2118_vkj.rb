# 代码生成时间: 2025-08-13 21:18:04
# NetworkStatusChecker class
class NetworkStatusChecker < Grape::API
  # Mounts the API at the root path
  format :json

  # GET / status check
  get '/' do
    # Returns network status as JSON
    network_status
  end

  private

  # Check network connectivity
  def network_status
    # Attempt to connect to Google's DNS server
    begin
      TCPSocket.new('8.8.8.8', 53).close
      { status: 'connected' }
    rescue SocketError
      { status: 'disconnected' }
    end
  end
end