# 代码生成时间: 2025-09-05 03:07:57
# password_encryption_service.rb
require 'grape'
require 'openssl'

# PasswordEncryptionService provides encryption and decryption functionalities.
class PasswordEncryptionService
  # Encrypts a password using AES-256-GCM
  def self.encrypt(password)
    # Generate a new random key for AES-256-GCM encryption
    key = OpenSSL::Cipher.new('aes-256-gcm').random_key
    # Create a cipher instance
    cipher = OpenSSL::Cipher.new('aes-256-gcm')
    # Initialize the cipher for encryption
    cipher.encrypt
    # Set the key and the IV (iv is generated automatically)
    cipher.key = key
    # Encrypt the password
    encrypted_password = cipher.update(password) + cipher.final
    # Return the encrypted password along with the key and iv
    return {
      :encrypted_password => encrypted_password,
      :key => key,
      :iv => cipher.random_iv
    }
  end

  # Decrypts a password using AES-256-GCM
  def self.decrypt(encrypted_password, key, iv)
    # Create a cipher instance
    cipher = OpenSSL::Cipher.new('aes-256-gcm')
    # Initialize the cipher for decryption
    cipher.decrypt
    # Set the key and the IV
    cipher.key = key
    cipher.iv = iv
    # Decrypt the password
    decrypted_password = cipher.update(encrypted_password) + cipher.final
    # Return the decrypted password
    return decrypted_password
  rescue OpenSSL::Cipher::CipherError => e
    # Handle decryption errors
    puts "Decryption error: #{e.message}"
    nil
  end
end

# Grape API for password encryption and decryption
class PasswordEncryptionAPI < Grape::API
  # POST /encrypt
  post '/encrypt' do
    # Get the password from the request body
    password = params[:password]
    # Encrypt the password
    encryption_result = PasswordEncryptionService.encrypt(password)
    # Return the encryption result
    status 200
    {
      :encrypted_password => encryption_result[:encrypted_password],
      :key => encryption_result[:key],
      :iv => encryption_result[:iv]
    }
  end

  # POST /decrypt
  post '/decrypt' do
    # Get the encrypted password, key, and iv from the request body
    encrypted_password = params[:encrypted_password]
    key = params[:key]
    iv = params[:iv]
    # Decrypt the password
    decrypted_password = PasswordEncryptionService.decrypt(encrypted_password, key, iv)
    # Return the decrypted password or an error message if decryption fails
    if decrypted_password
      status 200
      decrypted_password
    else
      status 400
      'Decryption failed'
    end
  end
end