# 代码生成时间: 2025-08-27 04:10:12
# 使用Grape框架创建一个API
class DocumentConverterAPI < Grape::API
  # 使用Grape-entity来定义请求和响应实体
  helpers do
    params :file_params do
      requires :file, type: Rack::Multipart::UploadedFile, desc: '文件'
    end
  end
  
  # 定义错误处理
  error_format :json, lambda { |e|
    {
      error: {
        message: e.message,
        code: e.status
      }
    }
  }
  
  # 添加一个POST请求路由，用于文档格式转换
  post 'convert' do
    # 验证请求中的文件参数
    error!('No file provided', 400) unless params[:file]
    
    # 读取文件并尝试转换
    begin
      file = params[:file][:tempfile]
      extension = File.extname(params[:file][:filename])
      
      # 根据文件扩展名选择转换策略
      case extension.downcase
      when '.xls', '.xlsx'
        workbook = Roo::Spreadsheet.open(file)
        new_file = Tempfile.new(['converted', extension])
        workbook.write(new_file.path)
        new_file.rewind
        present new_file, with: Grape::Entity
      else
        error!('Unsupported file format', 415)
      end
    rescue => e
      # 捕获并返回错误信息
      error!(e.message, 500)
    end
  end
end

# 定义Grape实体
module Entities
  class FileEntity < Grape::Entity
    expose :path, documentation: { type: 'string', desc: '文件路径' }
    expose :content_type, documentation: { type: 'string', desc: '文件内容类型' }
    expose :size, documentation: { type: 'integer', desc: '文件大小' }
    expose :filename, documentation: { type: 'string', desc: '文件名称' }
  end
end