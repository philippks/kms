class Hours
  class SubjectsController < ApplicationController
    respond_to :json

    def index
      @customers = customers
      @absence_reasons = absence_reasons
      @last_customers = last_customers
    end

    private

    def customers
      return [] if params['query'].blank?

      Subjects.customers_for(params['query'])
    end

    def absence_reasons
      return [] if params['query'].blank?

      Subjects.absence_reasons_for(params['query'])
    end

    def last_customers
      return [] unless params['query'].blank?

      Subjects.last_customers_for(current_employee)
    end
  end
end
