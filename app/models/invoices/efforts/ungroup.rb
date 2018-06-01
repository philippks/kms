module Invoices
  module Efforts
    class Ungroup
      attr_reader :effort

      def initialize(effort)
        @effort = effort
      end

      def ungroup_efforts!
        return unless effort.efforts.count >= 2

        new_efforts.reverse_each do |new_effort|
          new_effort.save!
          new_effort.insert_at(effort.position)
        end

        effort.destroy!
      end

      private

      def new_efforts
        assigned_efforts.map do |assigned_effort|
          effort.class.new invoice: effort.invoice,
                           text: assigned_effort.text,
                           efforts: [assigned_effort]
        end
      end

      def assigned_efforts
        effort.efforts.includes(:employee).order(date: :asc)
      end
    end
  end
end
