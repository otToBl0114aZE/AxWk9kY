# 代码生成时间: 2025-09-05 12:47:20
# 使用 Grape 框架创建 API
class ExcelGeneratorAPI < Grape::API

  # 路由到生成 Excel 的资源
  get '/generate_excel' do
    # 检查请求参数
    # 需要用户提供的参数：title, rows
    title = params[:title]
    rows = params[:rows]

    # 错误处理
    error!('Missing required parameters', 400) if title.nil? || rows.nil?
    error!('Invalid data types', 400) unless title.is_a?(String) && rows.is_a?(Array)

    # 创建 Excel 文件
    begin
      excel = Roo::Spreadsheet.open(:title => 'Generated_Excel', :driver => 'xlsx')
      excel.instance_variable_set('@default_sheet', excel.sheets.first)
      excel.sheet(excel.sheets.first)

      # 添加标题行
      excel.row(0).value = [title]

      # 添加数据行
      rows.each_with_index do |row, index|
        excel.row(index + 1).value = row
      end

      # 保存 Excel 文件
      filename = "Generated_Excel_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
      excel.save(filename)
      present filename
    rescue => e
      # 如果出现异常，返回错误信息
      error!("Error generating Excel: #{e.message}", 500)
    end
  end

end

# 运行 API
Rack::Server.start(:app => ExcelGeneratorAPI, :Port => 9292)