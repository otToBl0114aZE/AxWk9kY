# 代码生成时间: 2025-09-29 16:13:16
# cache_strategy_with_grape.rb
#
# This Ruby program utilizes the Grape framework to implement a caching strategy.
# It demonstrates how to create a simple API with caching capabilities.

require 'grape'
require 'grape-entity'
require 'active_support/cache'
require 'active_support/cache/dalli_store'
require 'redis'

# Initialize cache store
cache = ActiveSupport::Cache::DalliStore.new('localhost:11211', {
  expires_in: 3600, # Cache expiration in seconds
  compress: true
})

# Define an Entity
class UserEntity < Grape::Entity
  # Represent user data in a simplified form
  expose :id
  expose :name
  expose :email
end

# Define the API class with Grape
class MyApi < Grape::API
  # Include the Grape-entity plugin
  format :json

  # Set up the cache
  cache_control :public, max_age: 3600
  use Grape::Middleware::Cache::Simple, {
    store: cache,
    prefix: 'api_response'
  }

  # GET endpoint to fetch user data
  get '/users/:id' do
    # Fetch user data from the cache first
    user_id = params[:id]
    cached_data = cache.read(