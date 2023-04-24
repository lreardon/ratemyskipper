module SkippersHelper
    def color_for_skipper_flag(skipper, flag, intensity)
        reviews = skipper.reviews
        flagged_reviews = reviews.filter { |r| r.send(flag) }
        flag_proportion = flagged_reviews.count / reviews.count

        green = "#00ff00"
        red = "#ff0000"

        mix = interpolate_colors(green, red, flag_proportion)

        return interpolate_colors("#ffffff", mix, intensity.fdiv(1000))
    end

    private

    def interpolate_colors(color_string_1, color_string_2, amount)
        raise BadArgumentError unless 0 <= amount && amount <= 1
        
        color_1_tuple = color_string_to_tuple(color_string_1)
        color_2_tuple = color_string_to_tuple(color_string_2)

        new_color_tuple = interpolate(color_1_tuple, color_2_tuple, amount)
        new_color_hex_tuple = new_color_tuple.map{|i| "%.2x" % i}
        new_color_hex = "##{new_color_hex_tuple.join}"

        return new_color_hex
    end

    def interpolate(iterable_1, iterable_2, amount)
        raise BadArgumentError unless 0 <= amount && amount <= 1

        diff_iterable = iterable_2.map.with_index { |entry, index| entry - iterable_1[index] }
        scaled_diff_iterable = diff_iterable.map {|e| e * amount}

        return iterable_1.map.with_index { |entry, index| entry + scaled_diff_iterable[index] }
    end

    def color_string_to_tuple(color_string)
        return color_string[1,6].chars.each_slice(2).map(&:join).map{ |s| s.to_i(16) }
    end
end
