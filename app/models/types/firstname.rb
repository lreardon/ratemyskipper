class Types::Firstname < ActiveRecord::Type::String
    def cast(value)
        return super unless value.is_a?(String)

        CapitalizeNames.capitalize(value, format: :firstname)
    end
end