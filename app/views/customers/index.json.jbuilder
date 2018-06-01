json.array!(@customers) do |customer|
  present(customer) do |decorated_customer|
    json.call(decorated_customer, :id, :name, :display_name)
  end
end
