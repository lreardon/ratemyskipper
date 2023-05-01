class Types::Boatname < ActiveRecord::Type::String
    def cast(value)
        return super unless value.is_a?(String)

        if (fv_match_data = value.match(/\s*[Ff]\/?[Vv]\s*/))
            match_string = fv_match_data[0]
            no_fv_boatname = value.gsub(match_string, "")
            
            super(no_fv_boatname.titleize)
        else
            super(value.titleize)
        end
    end
end