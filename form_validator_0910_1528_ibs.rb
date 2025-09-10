# 代码生成时间: 2025-09-10 15:28:10
# 表单数据验证器类
class FormValidator < Grape::Validations::Validator
  # 验证表单数据是否符合要求
  def validate_param(param, value, _options)
    # 检查是否为空
    unless value.present?
      @result.add_error(:base, '%s cannot be blank' % param, value: value)
      return
    end
  end
end

# 使用 GRAPE 框架创建 API
class Api < Grape::API
  # 使用表单验证器
  params do
    requires :name, type: String, desc: 'User name', validate: { with: FormValidator }
    requires :age, type: Integer, desc: 'User age', validate: { with: FormValidator }
  end
  get :validate do
    { status: 'success' }
  end
rescue ActiveRecord::RecordInvalid => e
  error!(e.message, 400)
end

# 启动服务器
run Api