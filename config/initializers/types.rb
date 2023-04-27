Rails.application.config.to_prepare do
    ActiveRecord::Type.register(:name, Types::Name)
    ActiveRecord::Type.register(:boatname, Types::Boatname)
end