module ApplicationHelper
    def show_svg(path)
        File.open(asset_path(path), "rb") do |file|
          raw file.read
        end
      end
end
