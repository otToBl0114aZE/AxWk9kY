# 代码生成时间: 2025-09-07 01:07:57
# 使用GRAPE框架创建API
class ImageResizerAPI < Grape::API
  # 批量调整图片尺寸的端点
  params do
    requires :images, type: Array[Hash], desc: 'Array of image paths with desired dimensions'
  end
  post 'resize' do
    # 从请求中获取图片路径和尺寸信息
    images = params[:image]
    resizer = ImageResizer.new(images)
    resizer.resize
  end
end

# 图片尺寸批量调整器类
class ImageResizer
  # 初始化方法，接收图片路径和尺寸信息
  def initialize(images)
    @images = images
  end

  # 调整图片尺寸的方法
  def resize
    # 将调整后的图片路径存储在数组中
    resized_images = []
    @images.each do |image|
      begin
        # 使用MiniMagick库调整图片尺寸
        resized_image = MiniMagick::Image.open(image[:path]) do |img|
          img.resize image[:dimensions]
        end
        # 保存调整后的图片
        resized_image_path = image[:path] + '_resized'
        resized_image.write resized_image_path
        # 将调整后的图片路径添加到数组中
        resized_images << resized_image_path
      rescue MiniMagick::Error => e
        # 处理图片处理错误
        puts "Error resizing image: #{e.message}"
      end
    end
    resized_images
  end
end