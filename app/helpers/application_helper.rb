module ApplicationHelper
  def button_to_new(resource)
    model_name = resource.is_a?(Class) ? resource.model_name.human : resource.last.model_name.human
    link_to(t('resources.new', resource: model_name),
            polymorphic_url(resource, action: :new),
            class: 'btn btn-primary')
  end

  def button_to_back(path)
    link_to t('shared.back'), path, class: 'btn btn-default'
  end

  def link_to_edit(resource)
    link_to polymorphic_url(resource, action: :edit) do
      [fa_icon('pencil'), t('shared.edit')].join(' ').html_safe
    end
  end

  def link_to_destroy(resource, body: t('shared.destroy'))
    link_to body, resource,
            'data-confirm' => t('shared.are_you_sure'),
            method: :delete, class: 'destroy_link'
  end

  def index_title(resource)
    t('resources.index', resource: resource.model_name.human(count: 2))
  end

  def present(model, presenter_class = nil)
    klass = presenter_class || "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield(presenter) if block_given?
  end
end
