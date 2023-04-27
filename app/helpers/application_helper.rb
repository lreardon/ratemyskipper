module ApplicationHelper
    def show_svg(path)
      File.open(asset_path(path), "rb") do |file|
        raw file.read
      end
    end

    def readable_datetime_month_year(datetime)
      datetime.localtime.strftime("%B %Y")
    end
end
