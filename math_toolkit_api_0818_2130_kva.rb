# 代码生成时间: 2025-08-18 21:30:04
# 创建一个基于Grape的API
class MathToolkitAPI < Grape::API
  # 定义根路径
  get '/' do
    { message: 'Welcome to the Math Toolkit API' }
  end

  # 定义数学计算资源
  namespace :math do
    # 加法计算
    params do
      requires :a, type: Integer, desc: 'First number'
      requires :b, type: Integer, desc: 'Second number'
    end
    get :add do
      { result: params[:a] + params[:b] }
    end

    # 减法计算
    params do
      requires :a, type: Integer, desc: 'First number'
      requires :b, type: Integer, desc: 'Second number'
    end
    get :subtract do
      { result: params[:a] - params[:b] }
    end

    # 乘法计算
    params do
      requires :a, type: Integer, desc: 'First number'
      requires :b, type: Integer, desc: 'Second number'
    end
    get :multiply do
      { result: params[:a] * params[:b] }
    end

    # 除法计算
    params do
      requires :a, type: Integer, desc: 'First number'
      requires :b, type: Integer, desc: 'Second number', allow_blank: false
    end
    get :divide do
      error!('Division by zero is not allowed', 400) if params[:b].zero?
      { result: params[:a] / params[:b] }
    end

    # 平方根计算
    params do
      requires :a, type: Integer, desc: 'Number to square root'
    end
    get :square_root do
      error!('Negative number square root is not allowed', 400) if params[:a].negative?
      { result: Math.sqrt(params[:a].to_f) }
    end
  end

  # 错误处理
  error_format :json, each_with_object({}) do |error, doc|
    doc['error'] = error.message
  end
end

# 运行API
run MathToolkitAPI