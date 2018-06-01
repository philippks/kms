class Hours
  class Subjects
    def self.customers_for(query)
      Customer.for_query(query).active
    end

    def self.absence_reasons_for(query)
      Absence.reason.values.select do |absence_reason|
        absence_reason.text.downcase.include? query.downcase
      end
    end

    def self.last_customers_for(employee)
      Effort.for_employee(employee)
            .order(created_at: :desc)
            .limit(20)
            .includes(:customer)
            .map(&:customer)
            .uniq
            .take(5)
    end
  end
end
