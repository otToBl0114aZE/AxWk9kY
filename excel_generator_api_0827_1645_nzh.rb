# 代码生成时间: 2025-08-27 16:45:09
# Grape API 配置
class ExcelGeneratorAPI < Grape::API
  version 'v1', using: :path
  format :json
  
  # 定义根路径
  get '/' do
    { message: 'Welcome to the Excel Generator API.' }
  end
# 优化算法效率
  
  # 生成 Excel 的路由
  desc 'Generate an Excel file'
  params do
    requires :data, type: String, desc: 'JSON string representing the Excel data'
  end
  post 'generate' do
    # 解析参数中的数据
    data = JSON.parse(params[:data])
    
    # 错误处理
    if data.blank?
      error!('Data is required', 400)
    end
    
    # 创建 Excel 文件
    excel = Roo::Spreadsheet.open(:data, data.to_json)
    
    # 检查数据是否符合预期格式
    if excel.sheet_names.empty?
      error!('Invalid data format', 400)
    end
    
    # 保存 Excel 文件
    file_name = 'generated_excel.xlsx'
    excel.write(file_name)
    
    # 返回文件路径
    { file_path: file_name }
  end
end
# 添加错误处理

# 运行 Grape API
run! ExcelGeneratorAPI