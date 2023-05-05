module ApplicationHelper
  def show_svg(path)
    File.open(asset_path(path), "rb") do |file|
      raw file.read
    end
  end

  def readable_datetime_month_year(datetime)
    datetime.localtime.strftime("%B %Y")
  end

  def display_omniauth_provider(provider)
    case provider
    when :facebook
        'Facebook'
    when :google_oauth2
        'Google'
    else
        raise UnsupportedValueError
    end
  end
end
