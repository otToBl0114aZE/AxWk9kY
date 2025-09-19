# 代码生成时间: 2025-09-19 10:20:53
# 使用Grape框架创建API
class URLValidationAPI < Grape::API
  # 定义根路径
  get 'validate' do
    # 获取URL参数
    url = params[:url]

    # 检查URL是否存在
    if url.nil?
      error!('URL参数未提供', 400)
    end

    # 使用URI类验证URL格式
    begin
      uri = URI.parse(url)
      # 检查URI是否有效
      if uri && %w[http https].include?(uri.scheme)
        { valid: true, message: 'URL有效' }
      else
        { valid: false, message: 'URL无效或不支持的协议' }
      end
    rescue URI::InvalidURIError
      # 捕获URI解析错误
      { valid: false, message: '无效的URL格式' }
    end
  end
end

# 运行API
RunURLValidationAPI = URLValidationAPI