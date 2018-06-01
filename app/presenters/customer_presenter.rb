class CustomerPresenter < BasePresenter
  def display_name
    [
      name,
      ("(#{Customer.human_attribute_name(:deactivated)})" if deactivated?),
    ].join(' ')
  end
end
