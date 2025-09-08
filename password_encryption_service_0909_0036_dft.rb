# 代码生成时间: 2025-09-09 00:36:57
# encoding: utf-8

require 'grape'
require 'openssl'

# PasswordEncryptionService is a Grape API that allows password encryption and decryption.
class PasswordEncryptionService < Grape::API
  # Endpoint for password encryption
  params do
    requires :password, type: String, desc: 'The password to be encrypted'
  end
  post '/encrypt' do
    password = params[:password]
    # Encrypt the password
    encrypted_password = encrypt_password(password)
    error!('Invalid password', 400) if encrypted_password.nil?
    { success: true, encrypted_password: encrypted_password }
  end

  # Endpoint for password decryption
  params do
    requires :encrypted_password, type: String, desc: 'The password to be decrypted'
  end
  post '/decrypt' do
    encrypted_password = params[:encrypted_password]
    # Decrypt the password
    password = decrypt_password(encrypted_password)
    error!('Invalid encrypted password', 400) if password.nil?
    { success: true, password: password }
  end

  private

  # Encrypts a password using AES-256-CBC
  def encrypt_password(password)
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    # You should store the key and iv securely, here they are hardcoded for simplicity
    key = 'your_encryption_key'
    iv = 'your_initialization_vector'
    cipher.key = key
    cipher.iv = iv
    # Encrypt the password
    "#{cipher.update(password)}#{cipher.final}"
  end

  # Decrypts a password using AES-256-CBC
  def decrypt_password(encrypted_password)
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.decrypt
    key = 'your_encryption_key'
    iv = 'your_initialization_vector'
    cipher.key = key
    cipher.iv = iv
    # Decrypt the password
    cipher.update(encrypted_password) + cipher.final
  rescue OpenSSL::Cipher::CipherError
    nil
  end
end