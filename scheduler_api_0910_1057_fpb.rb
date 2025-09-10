# 代码生成时间: 2025-09-10 10:57:46
# Scheduler API 使用 Grape 框架
class SchedulerAPI < Grape::API
  format :json
  
  # 定时任务的 Sidekiq 队列名称
  SIDEKIQ_QUEUE = :scheduled_jobs
  
  # 定时任务的 Sidekiq 客户端
# 优化算法效率
  Sidekiq.configure_client do |config|
# 改进用户体验
    config.redis = {
      url: 'redis://localhost:6379/0'
    }
  end
# 改进用户体验
  
  # 定时任务调度器
  get '/tasks/schedule' do
    # 错误处理
    error!('Invalid request', 400) unless params[:task] && params[:cron]
    
    task = params[:task]
    cron = params[:cron]
    
    # 将定时任务添加到 Sidekiq 队列
    worker = Sidekiq::Client.push(
      'queue' => SIDEKIQ_QUEUE,
      'class' => task,
      'args'  => [],
      'at'    => Sidekiq::Cron.parse(cron).next_time_from(Time.now)
    )
    
    # 返回定时任务的 ID 和下一次执行时间
    { job_id: worker, next_run_at: Sidekiq::Cron.parse(cron).next_time_from(Time.now) }
  end
# 添加错误处理
  
  # 定时任务执行示例
  class TaskExample
    def self.perform
      # 这里放置任务执行的代码
      puts 'Task executed!'
    end
  end
end
