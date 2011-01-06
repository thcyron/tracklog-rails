module DashboardHelper
  def dashboard_duration(duration_in_seconds)
    duration_in_seconds ||= 0

    years   = duration_in_seconds / 1.year
    months  = duration_in_seconds % 1.year / 1.month
    weeks   = duration_in_seconds % 1.year % 1.month / 1.week
    days    = duration_in_seconds % 1.year % 1.month % 1.week / 1.day
    hours   = duration_in_seconds % 1.year % 1.month % 1.week % 1.day / 1.hour

    parts = []

    parts << pluralize(years.floor,   "year")   if years >= 1
    parts << pluralize(months.floor,  "month")  if months >= 1
    parts << pluralize(weeks.floor,   "week")   if weeks >= 1
    parts << pluralize(days.floor,    "day")    if days >= 1
    parts << pluralize(hours.ceil,    "hour")   if hours >= 1 or parts.size == 0

    parts.to_sentence
  end
end
