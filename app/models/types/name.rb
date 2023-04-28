class Types::Name < ActiveRecord::Type::String
    def cast(value)
        return super unless value
        
        super(value.titleize)
    end
end