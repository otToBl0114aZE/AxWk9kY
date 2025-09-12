# 代码生成时间: 2025-09-12 13:36:14
# ExcelGeneratorService 类定义了一个服务，用于生成 Excel 文件。
class ExcelGeneratorService
  # 初始化方法，接受参数用于创建 Excel 文件
  def initialize(filename, data)
    @filename = filename
    @data = data
  end

  # 生成 Excel 文件的方法
  def generate_excel
    begin
      # 使用 Roo 库创建 Excel 文件
      excel = Roo::Spreadsheet.open(@filename, create: true)
      excel.add_label('A1', 'Header 1')
      excel.add_label('B1', 'Header 2')

      # 填充数据到 Excel 文件
      @data.each_with_index do |row, index|
        excel.add_label(index + 2, 0, row[0]) # Column A
        excel.add_label(index + 2, 1, row[1]) # Column B
      end

      # 保存文件
      excel.save
      puts "Excel file generated successfully at #{@filename}"
    rescue => e
      puts "An error occurred: #{e.message}"
    end
  end
end

# 使用示例
# 假设有一个数据数组，需要写入 Excel 文件
data = [["name1", "value1"], ["name2", "value2"]]
# 创建 Excel 生成器服务实例
excel_service = ExcelGeneratorService.new('example.xlsx', data)
# 生成 Excel 文件
excel_service.generate_excel