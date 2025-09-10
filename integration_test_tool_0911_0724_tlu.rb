# 代码生成时间: 2025-09-11 07:24:06
# Grape API 配置
class IntegrationTestAPI < Grape::API
  format :json
  prefix :api

  # 实体定义
  module Entities
    class ExampleEntity < Grape::Entity
      expose :id, :as => :id
      expose :name, :as => :name
    end
  end

  # 路由定义
  resource :example do
    get do
      # 业务逻辑
      { id: 1, name: 'example' }
    end
  end
end

# 集成测试
describe IntegrationTestAPI do
  def app
    IntegrationTestAPI
  end

  include Rack::Test::Methods

  # 测试例
  describe 'GET /api/example' do
    it 'returns a successful response' do
      get '/api/example'
      expect(last_response).to be_ok
    end

    it 'returns the correct data' do
      get '/api/example'
      expect(JSON.parse(last_response.body)).to eq({
        "id" => 1,
        "name" => "example"
      })
    end
  end
end

# 使用 factory_bot 生成测试数据
FactoryBot.define do
  factory :example, class: Hash do
    sequence(:id, 1) { |n| n }
    sequence(:name) { |n| "example#{n}" }
  end
end
