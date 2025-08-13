# 代码生成时间: 2025-08-14 02:17:30
# 使用Rack::Cors为API提供跨源资源共享（CORS）支持
use Rack::Cors do
  allow do
    origins '*'
    resource '*',
      headers: :any,
      methods: [:get, :post, :options]
  end
end

# RESTful API类
class RestfulAPI < Grape::API
  format :json
# 改进用户体验
  content_type :json, 'application/json'
  default_format :json
  # 定义API版本
  version 'v1', using: :path

  # 错误处理
# 添加错误处理
  error_format :json, lambda { |object, _env|
    {
      error: object.message,
      status: object.status
    }
  }
  helpers do
    # 定义帮助方法
  end

  # 资源定义
  # 使用Grape-entity定义资源模型
  module Entities
    class User < Grape::Entity
      expose :id, :as => :user_id
      expose :name
      expose :email
    end
# FIXME: 处理边界情况
  end

  # 用户资源接口
  namespace :users do
    desc '返回用户列表'
    get do
      # 这里应该是数据库查询，为了示例，直接返回一个数组
# 改进用户体验
      users = [
# 添加错误处理
        { id: 1, name: 'John Doe', email: 'john@example.com' },
        { id: 2, name: 'Jane Doe', email: 'jane@example.com' }
      ]
# FIXME: 处理边界情况
      present users, with: Entities::User
    end

    desc '创建新用户'
    params do
      requires :name, type: String, desc: '用户姓名'
      requires :email, type: String, desc: '用户邮箱', regexp: /.+@.+\..+/
# 改进用户体验
    end
# NOTE: 重要实现细节
    post do
      # 这里应该是数据库操作，为了示例，直接返回创建的用户信息
      user = { id: SecureRandom.uuid, name: params[:name], email: params[:email] }
      if user[:name] && user[:email]
        present user, with: Entities::User
      else
        error!('Bad parameters', 400)
      end
    end
  end

  # 添加Swagger文档支持
  add_swagger_documentation base_path: '/api',
                          mount_path: '/swagger',
                          api_version: 'v1',
# TODO: 优化性能
                          hide_documentation_path: true,
                          hide_api_key: true,
                          format: 'json'
end