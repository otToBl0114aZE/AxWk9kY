# 代码生成时间: 2025-09-24 00:56:37
# 使用GRAPE框架创建随机数生成器API
#
# @author @your_username

require 'grape'
require 'securerandom'

# 定义随机数生成器API
class RandomNumberAPI < Grape::API
  # 定义根路径
  get '/' do
    'Welcome to the Random Number Generator API!'
  end

  # 定义生成随机数的路径
  get '/generate_random_number' do
    # 捕获请求参数
    range = params[:range]

    # 检查范围参数是否有效
    if range.blank? || (range !~ /\A\d+(\.\d+)?\z/)
      error!('Range parameter is missing or invalid', 400)
    end

    # 生成随机数
    random_number = SecureRandom.random_number(range.to_f)

    # 返回随机数
    { random_number: random_number }
  end
end