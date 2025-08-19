# 代码生成时间: 2025-08-20 00:04:21
# sorting_service.rb
require 'grape'

# SortingService is a Grape API that provides sorting functionalities.
class SortingService < Grape::API
  # Define the route for sorting an array using Bubble Sort algorithm.
  get '/bubble_sort' do
    # Check if the input is provided
    array = params[:array]
    if array.blank?
      error!('Input array is required', 400)
    end
    
    # Validate input to ensure it's an array of numbers
    if !array.is_a?(Array) || array.any? { |item| !item.is_a?(Numeric) }
      error!('Input must be an array of numbers', 400)
    end
    
    # Perform bubble sort on the array
    bubble_sort(array)
  end

  # Define the route for sorting an array using Quick Sort algorithm.
  get '/quick_sort' do
    # Check if the input is provided
    array = params[:array]
    if array.blank?
      error!('Input array is required', 400)
    end
    
    # Validate input to ensure it's an array of numbers
    if !array.is_a?(Array) || array.any? { |item| !item.is_a?(Numeric) }
      error!('Input must be an array of numbers', 400)
    end
    
    # Perform quick sort on the array
    quick_sort(array)
  end

  private
  
  # Bubble Sort implementation.
  def bubble_sort(arr)
    arr.each_with_index do |_item, i|
      (arr.length - i - 1).times do |j|
        arr[j], arr[j + 1] = arr[j + 1], arr[j] if arr[j] > arr[j + 1]
      end
    end
    arr
  end
  
  # Quick Sort implementation.
  def quick_sort(arr)
    return arr if arr.length <= 1
    pivot = arr.first
    less = arr[1..-1].select { |v| v <= pivot }
    greater = arr[1..-1].select { |v| v > pivot }
    quick_sort(less) + [pivot] + quick_sort(greater)
  end
end
