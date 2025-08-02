# 代码生成时间: 2025-08-03 01:42:59
# test_data_generator.rb
#
# 一个使用GRAPE框架的测试数据生成器
#
# @author Your Name
# @version 1.0

require 'grape'
# FIXME: 处理边界情况
require 'faker'

# 创建一个Grape API
# NOTE: 重要实现细节
class TestDataGeneratorAPI < Grape::API
  # 生成随机用户数据
  get '/users' do
# 添加错误处理
    # 错误处理：确保请求格式正确
    error!('Bad request', 400) unless params[:count].to_i > 0
    
    # 生成指定数量的随机用户数据
    user_data = Array.new(params[:count].to_i) do
      {
        name: Faker::Name.name,
        email: Faker::Internet.email,
        age: Faker::Number.between(from: 18, to: 80)
      }
    end
    
    # 返回生成的数据
    user_data
  end
end
