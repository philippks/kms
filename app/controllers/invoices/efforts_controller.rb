module Invoices
  class EffortsController < ApplicationController
    def reorder
      return if effort_params[:position].blank?

      effort.insert_at effort_params[:position].to_i
    end

    def ungroup
      Invoices::Efforts::Ungroup.new(effort).ungroup_efforts!
      redirect_to invoice_wizard_path
    end

    def group
      Invoices::Efforts::Group.new(@invoice, effort_ids).group_efforts!
      redirect_to invoice_wizard_path
    end

    def effort
      raise 'override method'
    end

    def effort_params
      raise 'override method'
    end

    def invoice_wizard_path
      raise 'override method'
    end

    private

    def effort_ids
      (params[:effort_ids] || []).map(&:to_i)
    end
  end
end
