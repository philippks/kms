module TitleHelper
  def page_title_for(resource:, action:)
    define_page_title(title_for(resource, action: action))
  end

  def define_page_title(title)
    content_for(:page_title, title)
    content_tag(:h1, content_for(:page_title))
  end

  private

  def title_for(resource, action:)
    case action
    when :index
      t 'resources.index', resource: resource.model_name.human(count: 2)
    when :edit
      t 'resources.edit', resource: resource.model_name.human
    when :new
      t 'resources.new', resource: resource.model_name.human
    end
  end
end
