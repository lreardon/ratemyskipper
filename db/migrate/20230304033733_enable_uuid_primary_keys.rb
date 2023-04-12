class EnableUuidPrimaryKeys < ActiveRecord::Migration[7.0]
  # This extension was enabled by a system administrator on heliohost, the current production hosting platform
    enable_extension 'pgcrypto' unless (ENV['RAILS_ENV'] == 'production' or extension_enabled?('pgcrypto'))
  end
end
