# 代码生成时间: 2025-10-08 16:18:48
#!/usr/bin/env ruby
# encoding: UTF-8

# DocumentCollaborationPlatform.rb
# A simple document collaboration platform using the Grape framework.

require 'grape'
require 'grape-entity'
require 'json'

# Define the API version
module API
  module V1
    # Define the Grape API
    class DocumentCollaborationPlatform < Grape::API
      format :json
      content_type :json, 'application/json'
      
      desc 'Returns a list of all documents'
      get '/documents' do
        present Document.all, with: DocumentEntity
      end
      
      desc 'Creates a new document'
      params do
        requires :title, type: String, desc: 'The title of the document'
        requires :content, type: String, desc: 'The content of the document'
      end
      post '/documents' do
        document = Document.new(title: params[:title], content: params[:content])
        if document.save
          present document, with: DocumentEntity
        else
          error!('Failed to create document', 400)
        end
      end
      
      desc 'Updates an existing document'
      params do
        requires :id, type: Integer, desc: 'The ID of the document'
        requires :title, type: String, desc: 'The title of the document'
        requires :content, type: String, desc: 'The content of the document'
      end
      put '/documents/:id' do
        document = Document.find(params[:id])
        halt 404 unless document
        document.update(title: params[:title], content: params[:content])
        present document, with: DocumentEntity
      end
      
      desc 'Deletes an existing document'
      params do
        requires :id, type: Integer, desc: 'The ID of the document'
      end
      delete '/documents/:id' do
        document = Document.find(params[:id])
        halt 404 unless document
        document.destroy
        { success: true }
      end
    end
  end
end

# Define the Document model
class Document
  include Grape::Entity
  def self.all
    [Document.new(id: 1, title: 'Document 1', content: 'Content 1'), Document.new(id: 2, title: 'Document 2', content: 'Content 2')]
  end
  
  def self.find(id)
    self.all.detect { |doc| doc.id == id } || nil
  end
  
  attr_accessor :id, :title, :content
  expose :id, :title, :content
  
  def save
    # Save logic here
    true
  end
  
  def destroy
    # Destroy logic here
    true
  end
end

# Define the DocumentEntity to represent document data
class DocumentEntity < Grape::Entity
  expose :id, :title, :content
end

# Run the Grape API server
run! API::V1::DocumentCollaborationPlatform