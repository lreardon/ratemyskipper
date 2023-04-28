Rails.application.config.to_prepare do
    ActiveRecord::Type.register(:name, Types::Name)
    ActiveRecord::Type.register(:boatname, Types::Boatname)
    ActiveRecord::Type.register(:firstname, Types::Firstname)
    ActiveRecord::Type.register(:lastname, Types::Lastname)
end