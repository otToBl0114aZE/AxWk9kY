# 代码生成时间: 2025-08-12 14:12:56
# 使用Grape框架创建一个简单的表单数据验证器
class FormValidatorAPI < Grape::API
  # 定义验证器模块
  module Validators
    # 用户信息验证器
    class UserInfo < Grape::Validations::Base
      def validate_param(user_info, value, _options)
        # 验证用户名长度
        unless value[:username].present? && value[:username].length >= 3
          raise ::Grape::Exceptions::Validation, params: ['username must be at least 3 characters'], message: 'Invalid username'
        end

        # 验证用户年龄是否在有效范围内
        unless value[:age].present? && (18..100).include?(value[:age].to_i)
          raise ::Grape::Exceptions::Validation, params: ['age must be between 18 and 100'], message: 'Invalid age'
        end
      end
    end
  end

  # 定义路由
  namespace :form do
    # POST /form/validate_user
    post '/validate_user' do
      # 使用Grape的参数验证器
      params do
        requires :user_info, type: Hash do
          requires :username, type: String
          requires :age, type: Integer
        end
      end

      # 调用验证器
      user_info = declared(params)[:user_info]
      Validators::UserInfo.new.validate!(user_info)

      # 如果验证通过，返回成功消息
      { success: 'User info is valid' }
    rescue ::Grape::Exceptions::Validation => e
      # 错误处理，返回错误消息
      { error: e.message }
    end
  end
end
