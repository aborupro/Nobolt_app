CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:].\-+]/
if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Amazon S3用の設定
      provider: 'AWS',
      region: Rails.application.credentials.s3[:region],     # 例: 'ap-northeast-1'
      aws_access_key_id: Rails.application.credentials.s3[:access_key],
      aws_secret_access_key: Rails.application.credentials.s3[:secret_key]

    }
    config.fog_directory = Rails.application.credentials.s3[:bucket]
    config.asset_host = Rails.application.credentials.s3[:host]
  end
end
