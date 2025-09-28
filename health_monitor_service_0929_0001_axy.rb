# 代码生成时间: 2025-09-29 00:01:48
# 引入Grape框架
require 'grape'
require 'grape-entity'

# 定义HealthMonitor API
class HealthMonitor < Grape::API
  # 版本信息
  version 'v1', using: :path

  # 定义实体
  module Entities
    class HealthRecord
      include Grape::Entity
      expose :id, documentation: { type: 'Integer' }
      expose :temperature, documentation: { type: 'Float', desc: 'Temperature in Celsius' }
      expose :heart_rate, documentation: { type: 'Integer', desc: 'Heart rate in beats per minute' }
      expose :blood_pressure, documentation: { type: 'String', desc: 'Blood pressure in the format 'systolic/diastolic'' }
      expose :timestamp, documentation: { type: 'DateTime', desc: 'Timestamp of the health record' }
    end
  end

  # 定义路由
  namespace :monitors do
    # 获取健康记录列表
    get ':id/records' do
      # 模拟数据库查询
      records = [
        { id: 1, temperature: 36.5, heart_rate: 72, blood_pressure: '120/80', timestamp: Time.now - 3600 },
        { id: 2, temperature: 37.2, heart_rate: 78, blood_pressure: '125/85', timestamp: Time.now - 2 * 3600 }
      ]

      # 错误处理
      error!('No records found', 404) if records.empty?

      # 返回健康记录实体
      present records, with: Entities::HealthRecord
    end
  end
end
