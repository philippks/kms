module Invoices
  class EffortsController < ApplicationController
    def reorder
      unless effort_params[:position].blank?
        effort.insert_at effort_params[:position].to_i
      end
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
      fail 'override method'
    end

    def effort_params
      fail 'override method'
    end

    def invoice_wizard_path
      fail 'override method'
    end

    private

    def effort_ids
      (params[:effort_ids] || []).map(&:to_i)
    end
  end
end
