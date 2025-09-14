# 代码生成时间: 2025-09-14 11:45:39
# SystemPerformanceMonitor is a Grape API for monitoring system performance
class SystemPerformanceMonitor < Grape::API
  # Endpoint for retrieving system performance metrics
  get '/system/performance' do
    # Fetch system performance data
    data = SystemPerformance.new.get_metrics
    # Return the data in JSON format
    { data: data }.to_json
  end
end

# SystemPerformance class responsible for gathering system performance metrics
class SystemPerformance
  # Fetches system performance metrics
  def get_metrics
    # CPU usage
    cpu_usage = `top -bn1 | grep load | awk '{printf "%.2f
", $(NF-4)/4}'`.strip
    # Memory usage
    memory_usage = `free -m | awk 'NR==2{printf "%s/%s MB; %.2f%% used
", $3,$2,$3*100/$2 }'`.strip
    # Disk usage
    disk_usage = `df -h | awk 'NR==2{printf "%s/%s; %s used
", $3,$2,$5}'`.strip
    # Network stats
    network_stats = get_network_stats
    # Combine all metrics into a single hash
    metrics = {
      cpu_usage: cpu_usage,
      memory_usage: memory_usage,
      disk_usage: disk_usage,
      network_stats: network_stats
    }
    metrics
  end

  private
  # Retrieves network statistics
  def get_network_stats
    # Get network interfaces
    ifaces = `ip link show`.split("
")
    # Initialize network stats hash
    network_stats = {}
ifaces.each do |iface|
      # Skip loopback interface
      next if iface.include? 'LOOPBACK'
      # Extract interface name
      iface_name = iface.match(/\w+/)[0]
      # Get interface stats
      stats = `ip -s link show #{iface_name}`.split("
").map(&:strip)
      # Extract receive and transmit stats
      receive = stats.find { |s| s.include? 'RX' }.split[1]
      transmit = stats.find { |s| s.include? 'TX' }.split[1]
      # Store stats in hash
      network_stats[iface_name] = { receive: receive, transmit: transmit }
    end
    network_stats
  end
end