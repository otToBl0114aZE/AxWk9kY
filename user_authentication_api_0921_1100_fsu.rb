# 代码生成时间: 2025-09-21 11:00:55
# 定义用户身份认证API
class UserAuthenticationAPI < Grape::API
  # 使用Grape-entity简化参数解析
  helpers do
    # 定义用户模型
    class User < Grape::Entity
      expose :username
      expose :password
    end

    # 检查用户凭据
    def authenticate_user(username, password)
      user = User.find_by(username: username)
      if user && BCrypt::Password.new(user.password_digest) == password
        user
      else
        nil
      end
    end
  end

  # 用户身份认证端点
  params do
    requires :username, type: String, desc: 'The user username'
    requires :password, type: String, desc: 'The user password'
  end
  post 'login' do
    # 获取请求参数
    username = params[:username]
    password = params[:password]

    # 验证凭据
    user = authenticate_user(username, password)

    # 错误处理
    if user
      # 返回成功响应
      {
        success: true,
        message: 'Authentication successful',
        user: User.new(user)
      }
    else
      # 返回失败响应
      status 401
      {
        success: false,
        message: 'Authentication failed'
      }
    end
  end
end
