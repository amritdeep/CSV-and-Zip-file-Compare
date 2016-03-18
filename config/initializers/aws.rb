AWS.config(
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :ses => { :region => 'us-west-2' },
  :bucket => ENV['S3_BUCKET'],
  :s3_server_side_encryption => :aes256
)