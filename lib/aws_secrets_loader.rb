require "aws-sdk-secretsmanager"
require "json"

class AwsSecretsLoader
  def self.load
    return unless ENV["RAILS_ENV"] == "production"

    client = Aws::SecretsManager::Client.new(region: "ap-south-1")

    begin
      # 1. Load Database Secrets
      db_secret_name = "production/rails-app/db-creds"
      db_resp = client.get_secret_value(secret_id: db_secret_name)
      db_secrets = JSON.parse(db_resp.secret_string)

      ENV["DATABASE_HOST"] = db_secrets["host"]
      ENV["DATABASE_USERNAME"] = db_secrets["username"]
      ENV["HELLO_WORLD_DATABASE_PASSWORD"] = db_secrets["password"]
      # Note: "dbname" might be in the secret too if created via RDS wizard
      ENV["DATABASE_NAME"] = db_secrets["dbname"] if db_secrets["dbname"]

      # 2. Load App Secrets
      app_secret_name = "production/rails-app/app-secrets"
      app_resp = client.get_secret_value(secret_id: app_secret_name)
      app_secrets = JSON.parse(app_resp.secret_string)

      ENV["SECRET_KEY_BASE"] = app_secrets["SECRET_KEY_BASE"]

      puts "Successfully loaded secrets from AWS Secrets Manager"
    rescue StandardError => e
      puts "Error loading secrets from AWS Secrets Manager: #{e.message}"
      # In production, you might want to raise this to prevent the app from starting with broken config
      # raise e
    end
  end
end
