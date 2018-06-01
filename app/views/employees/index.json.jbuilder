json.array!(@employees) do |employee|
  json.call(employee, :id, :name)
end
