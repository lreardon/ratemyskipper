class Types::Name < ActiveRecord::Type::String
    def cast(value)
        return super unless value.is_a?(String)

        super(value.titleize)
    end
end