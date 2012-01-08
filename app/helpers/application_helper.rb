module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def markdown(text)
    raw Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true).render(text)
  end
end
