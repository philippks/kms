class EntitiesFilter
  include ActiveModel::Model

  attr_reader :parameters

  FILTER_METHODS = {
    customer: :for_customer,
    customer_group: :for_customer_group,
    employee: :for_employee,
    state: :for_state,
    activity_category: :for_activity_category,
    reason: :for_reason,
    from: :after,
    to: :before
  }.freeze

  def initialize(parameters)
    @parameters = parameters || {}
  end

  def filter(entities)
    return entities if parameters.nil?

    parameters.each do |key, value|
      next if value.blank?
      entities = entities.send(FILTER_METHODS[key.to_sym], value)
    end
    entities
  end

  FILTER_METHODS.keys.each do |filter_method|
    define_method filter_method do
      parameters[filter_method.to_sym]
    end
  end
end
