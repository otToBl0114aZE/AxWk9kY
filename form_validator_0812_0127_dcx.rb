# 代码生成时间: 2025-08-12 01:27:26
# 定义一个使用Grape框架的API
class FormValidatorAPI < Grape::API
  # 使用Grape的验证功能来验证表单数据
  params do
    # 定义需要验证的参数
    requires :name, type: String, desc: 'Your name'
    requires :email, type: String, regexp: /.+@.+\..+/, desc: 'Your email address'
    requires :age, type: Integer, desc: 'Your age'
  end

  # 验证规则
  validate do
    # 验证名字是否包含非法字符
    if params[:name].match /[^a-zA-Z\s]/
      errors.add :name, 'should only contain letters and spaces'
    end
    # 验证年龄是否在合理的范围内
    if params[:age] < 0 || params[:age] > 120
      errors.add :age, 'should be between 0 and 120'
    end
  end

  # 定义路由和响应
  get 'validate' do
    # 如果没有错误，返回验证成功的信息
    if errors.empty?
      { message: 'Validation Successful' }
    else
      # 如果有错误，返回错误信息
      { errors: errors.messages }
    end
  end
end

# 运行API
run! if __FILE__ == $0