if @absence_reasons.any?
  json.child! do
    json.text Absence.human_attribute_name(:reason)
    json.children do
      json.array!(@absence_reasons) do |absence_reason|
        json.name absence_reason.text
        json.id absence_reason.value
        json.url new_absence_path(reason: absence_reason.value)
      end
    end
  end
end

if @customers.any?
  json.child! do
    json.text Customer.model_name.human
    json.children do
      json.array!(@customers) do |customer|
        json.call(customer, :id, :name)
        json.url new_activity_path(customer: customer)
      end
    end
  end
end

if @last_customers.any?
  json.child! do
    json.text t '.last_customers'
    json.children do
      json.array!(@last_customers) do |customer|
        json.call(customer, :id, :name)
        json.url new_activity_path(customer: customer)
      end
    end
  end
end
