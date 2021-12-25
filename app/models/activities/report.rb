module Activities
  class Report
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::Conversion

    attr_accessor :from_date, :to_date

    delegate :value_for, to: :efforts_cube, prefix: 'effort'
    delegate :value_for, to: :absences_cube, prefix: 'absence'
    delegate :value_for, to: :invoices_cube, prefix: 'invoice'

    def initialize(from_date:, to_date:)
      @from_date = from_date
      @to_date = to_date
    end

    def employees
      @employees ||= (efforts.map(&:employee) + absences.map(&:employee)).uniq.sort_by(&:initials)
    end

    def customers_by_customer_group
      @customers_by_customer_group ||= customers.group_by(&:customer_group)
    end

    def absence_reasons
      @absence_reasons ||= absences.map(&:reason).uniq
    end

    def total_hours_for(employee)
      effort_value_for(employee, :hours) + absence_value_for(employee, :hours)
    end

    def target_hours_for(employee)
      TargetHours.hours_between_for_employee(from: @from_date, to: @to_date, employee: employee)
    end

    def saldo_for(employee)
      total_hours_for(employee) - target_hours_for(employee)
    end

    def persisted?
      false
    end

    private

    def efforts_cube
      @efforts_cube ||= EffortsCube.new efforts + build_default_expenses
    end

    def efforts
      @efforts ||= Effort.between(from: @from_date, to: @to_date)
                         .includes(:employee, customer: :customer_group)
    end

    # since the default expenses do not exists yet, generate pseudo expenses
    # for each customer, which obviously never get persisted
    def build_default_expenses
      activities_amount_by_customer = efforts.where(type: 'Activity')
                                             .group(:customer)
                                             .sum(:amount_cents)

      customers.map do |customer|
        activities_amount = Money.new(activities_amount_by_customer[customer])
        default_amount = Invoices::Expense.default_amount_for(activities_amount: activities_amount)
        Expense.new(customer: customer, amount: default_amount)
      end
    end

    def customers
      @customers ||= efforts.map(&:customer).uniq.sort_by do |customer|
        "#{customer.customer_group&.name || '000'}#{customer.name}".downcase
      end
    end

    def absences_cube
      @absences_cube ||= AbsencesCube.new absences, from: @from_date, to: @to_date
    end

    def absences
      @absences ||= Absence.between(from: @from_date, to: @to_date)
                           .includes(:employee)
    end

    def invoices_cube
      @invoices_cube ||= InvoicesCube.new(Invoice.between(from: @from_date, to: @to_date)
                                                 .includes(:employee, customer: :customer_group)
                                                 .where.not(state: :open)
                                                 .where(customer: customers))
    end
  end
end
