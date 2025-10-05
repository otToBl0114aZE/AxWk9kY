# 代码生成时间: 2025-10-05 17:33:45
# 定义Key类
class Key
  attr_accessor :id, :key, :created_at

  # 构造器
  def initialize(id: nil, key: nil)
    @id = id
    @key = key
    @created_at = Time.now
  end
end

# 定义KeyEntity类
class KeyEntity < Grape::Entity
  expose :id
  expose :key, documentation: { type: 'string', desc: 'The key' }
  expose :created_at, documentation: { type: 'datetime', desc: 'The creation time of the key' }
end

# 密钥管理API
class KeyManagementAPI < Grape::API
  format :json
  prefix :api
  helpers do
    # 密钥存储
    def key_storage
      @key_storage ||= []
    end
  end

  # 获取所有密钥
  get 'keys' do
    key_storage.map { |key| KeyEntity.represent(key) }
  end

  # 创建一个新的密钥
  post 'keys' do
    key = Key.new(id: SecureRandom.hex(8), key: SecureRandom.hex(16))
    key_storage << key
    KeyEntity.represent(key)
  end

  # 根据ID获取密钥
  get 'keys/:id' do
    key = key_storage.find { |k| k.id == params[:id] }
    error!('Key not found', 404) unless key
    KeyEntity.represent(key)
  end

  # 错误处理
  error_format :json
  on :all do |e|
    if e.is_a?(Grape::Exceptions::Validation)
      error!(e.message, 400)
    else
      error!('Internal Server Error', 500)
    end
  end
end

# 运行密钥管理服务
run! if __FILE__ == $0
