# 代码生成时间: 2025-08-20 20:50:18
# Excel表格自动生成器API
class ExcelGeneratorAPI < Grape::API
  # 定义API版本
  version 'v1', using: :path
  # 定义根路径
  format :json

  # 获取Excel表格数据
  get ':filename' do
    # 检查文件名是否合法
    error!('Invalid filename', 400) unless params[:filename].match(/\w+/)

    # 初始化Excel文件
    file = Roo::Spreadsheet.open(params[:filename])
    # 获取工作表
    sheet = file.sheet(0)
    # 读取数据
    rows = sheet.parse
    # 关闭文件
    file.close

    # 返回数据
    { rows: rows }
  end

  # 创建Excel表格
  post ':filename' do
    # 检查文件名是否合法
    error!('Invalid filename', 400) unless params[:filename].match(/\w+/)

    # 检查数据类型是否正确
    error!('Invalid data type', 400) unless params[:data].is_a?(Array)

    # 初始化Excel文件
    file = Roo::Spreadsheet.open(params[:filename], nil, 'excel2007')
    # 创建工作表
    sheet = file.add_sheet('Sheet 1')
    # 写入数据
    params[:data].each_with_index do |row, index|
      sheet.add_row(row, index)
    end
    # 保存文件
    file.save
    # 关闭文件
    file.close

    # 返回成功消息
    { message: 'Excel file created successfully' }
  end
end

# 错误处理示例
# ExcelGeneratorAPI.add_route do |routes|
#   routes.on 'error' do
#     env['api.error'] rescue nil
#   end
# end

# 运行API服务器
run! if __FILE__ == $0