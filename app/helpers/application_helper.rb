module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def current_user
    controller.current_user
  end

  def logged_in?
    controller.logged_in?
  end
end
