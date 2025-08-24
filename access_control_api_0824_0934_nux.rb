# 代码生成时间: 2025-08-24 09:34:26
# 使用Grape框架创建一个API
class AccessControlAPI < Grape::API
  # 使用JWT中间件进行身份验证
  helpers do
    def current_user
      # 从请求头中获取token并验证
      token = env['HTTP_AUTHORIZATION'].split(' ').last if env['HTTP_AUTHORIZATION']
      @current_user ||= User.find_by(token: JWT.decode(token, nil, false)[0]['sub']) if token
    end
  end

  # 定义API路由
  get '/home' do
    # 无需身份验证的公开路由
    "Welcome to the public API!"
  end

  get '/profile' do
    # 需要身份验证的受保护路由
    unless current_user
      error!('Not Authorized', 401)
    end
    current_user.name
  end

  # 添加错误处理
  error_format :json
  
  # 自定义错误响应
  add_error_type :not_authorized, status: 401, message: 'Not Authorized', headers: {'WWW-Authenticate' => 'Bearer'}
  
  # 错误处理中间件
  on :not_authorized do
    error!({error: 'Not Authorized'}, 401)
  end
end

# 用户模型
class User
  include Mongoid::Document
  field :name
  field :token
end