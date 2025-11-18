module ApplicationHelper

  def localized_date(date)
    return date.strftime("%d.%m.%Y, %H:%M UTC") if I18n.locale == :ru

    date.strftime("%Y-%m-%d %I:%M %P UTC")
  end

end
