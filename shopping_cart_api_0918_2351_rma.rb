# 代码生成时间: 2025-09-18 23:51:14
# 使用Grape框架创建的购物车API
require 'grape'
require 'grape-entity'
require 'json'

# 定义购物车实体
class ShoppingCartEntity < Grape::Entity
  expose :id, documentation: { type: 'integer', desc: '购物车ID' }
  expose :items, documentation: { type: 'array', desc: '购物车中的商品列表' }
  expose :total_price, documentation: { type: 'float', desc: '购物车的总价格' }
end

# 定义商品实体
class ProductEntity < Grape::Entity
  expose :id, documentation: { type: 'integer', desc: '商品ID' }
  expose :name, documentation: { type: 'string', desc: '商品名称' }
  expose :price, documentation: { type: 'float', desc: '商品价格' }
end

# 定义购物车API
class ShoppingCartAPI < Grape::API
  # 添加商品到购物车
  params do
    requires :cart_id, type: Integer, desc: '购物车ID'
    requires :product_id, type: Integer, desc: '商品ID'
  end
  post 'add_item' do
    cart = ShoppingCart.find(params[:cart_id])
    product = Product.find(params[:product_id])
    # 错误处理
    error!('Shopping cart not found', 404) unless cart
    error!('Product not found', 404) unless product
    cart.add_item(product)
    # 返回购物车信息
    present cart, with: ShoppingCartEntity
  end

  # 获取购物车详情
  params do
    requires :cart_id, type: Integer, desc: '购物车ID'
  end
  get 'show' do
    cart = ShoppingCart.find(params[:cart_id])
    # 错误处理
    error!('Shopping cart not found', 404) unless cart
    present cart, with: ShoppingCartEntity
  end
end

# 购物车类
class ShoppingCart
  attr_accessor :id, :items
  def initialize(id)
    @id = id
    @items = []
  end
  
  def add_item(product)
    # 添加商品到购物车
    @items << product
  end
  
  def total_price
    # 计算购物车总价格
    @items.sum(&:price)
  end
end

# 商品类
class Product
  attr_accessor :id, :name, :price
end
