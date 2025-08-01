# 代码生成时间: 2025-08-01 19:07:20
# TestDataGenerator 模块，用于生成测试数据
module TestDataGenerator
  # Grape API 定义
  class API < Grape::API
    # 生成单个用户数据
    get '/users/:id' do
      user = generate_user
      if user
        { user: user }
      else
        status 404
        { error: 'User not found' }
      end
    end

    # 生成用户列表数据
    get '/users' do
      users = generate_users
      { users: users }
    end

    private

    # 使用 Faker 库生成单个用户数据
    def generate_user
      Faker::Internet.user
    end

    # 使用 Faker 库生成用户列表数据
    def generate_users
      (1..10).map { generate_user }
    end
  end
end

# 运行 Grape API
run TestDataGenerator::API