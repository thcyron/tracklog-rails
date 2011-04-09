module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def add_js(*locations)
    @javascripts ||= []

    locations.each do |location|
      if location =~ /^https*:\/\//
        @javascripts << location
      else
        @javascripts << "/javascripts/#{location}"
      end
    end
  end
end
