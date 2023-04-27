class Types::Name < ActiveRecord::Type::String
    def cast(value)
        super(value.titleize)
    end
end