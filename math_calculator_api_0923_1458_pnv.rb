# 代码生成时间: 2025-09-23 14:58:11
# 使用Grape框架创建一个数学计算工具集的API

require 'grape'
require 'bigdecimal'

# 定义数学计算工具集API
class MathCalculatorApi < Grape::API
  # 设置版本号
  version 'v1', using: :header, vendor: 'math-calculator'

  # 根路径
  get '/' do
    { message: 'Welcome to the Math Calculator API!' }
  end

  # 数学计算工具集资源
  namespace :calculator do
    # 加法运算
    params do
      requires :a, type: BigDecimal, desc: 'First number'
      requires :b, type: BigDecimal, desc: 'Second number'
    end
    get :add do
      { result: BigDecimal(params[:a]) + BigDecimal(params[:b]) }
    end

    # 减法运算
    params do
      requires :a, type: BigDecimal, desc: 'First number'
      requires :b, type: BigDecimal, desc: 'Second number'
    end
    get :subtract do
      { result: BigDecimal(params[:a]) - BigDecimal(params[:b]) }
    end

    # 乘法运算
    params do
      requires :a, type: BigDecimal, desc: 'First number'
      requires :b, type: BigDecimal, desc: 'Second number'
    end
    get :multiply do
      { result: BigDecimal(params[:a]) * BigDecimal(params[:b]) }
    end

    # 除法运算
    params do
      requires :a, type: BigDecimal, desc: 'First number'
      requires :b, type: BigDecimal, desc: 'Second number'
      requires :precision, type: Integer, desc: 'Precision of the result', default: 2
    end
    get :divide do
      begin
        result = BigDecimal(params[:a]) / BigDecimal(params[:b])
        { result: result.round(params[:precision]) }
      rescue BigDecimal::DivisionByZero
        { error: 'Cannot divide by zero' }
      end
    end

    # 幂运算
    params do
      requires :base, type: BigDecimal, desc: 'Base number'
      requires :exponent, type: BigDecimal, desc: 'Exponent'
    end
    get :power do
      { result: BigDecimal(params[:base]) ** BigDecimal(params[:exponent]) }
    end

    # 平方根运算
    params do
      requires :number, type: BigDecimal, desc: 'Number to find the square root of'
    end
    get :sqrt do
      begin
        result = BigDecimal(params[:number]).sqrt
        { result: result }
      rescue Math::DomainError
        { error: 'Cannot find the square root of negative number' }
      end
    end
  end
end

# 运行API
run MathCalculatorApi