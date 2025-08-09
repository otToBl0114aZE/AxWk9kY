# 代码生成时间: 2025-08-09 13:46:29
# 定义一个实体类，用于解析请求体中的JSON数据
class RequestEntity < Grape::Entity
  expose :name, documentation: { type: 'string', desc: 'The name of the user' }
  expose :age, documentation: { type: 'integer', desc: 'The age of the user' }
end

# 创建一个Grape API实例
class HttpApi < Grape::API
  format :json

  # 添加一个路由，用于处理GET请求
  get do
    # 返回一个简单的响应
    { message: 'Hello, world!' }
  end

  # 添加一个路由，用于处理POST请求，接收JSON数据
  post '/users', entities: [RequestEntity] do
    # 解析请求体中的JSON数据
    user = params
    # 简单的错误处理
    error!('Missing required parameters', 400) unless user[:name] && user[:age]
    # 返回创建的用户信息
    { status: 'success', user: user }
  end
end

# 运行API，监听3000端口
run!