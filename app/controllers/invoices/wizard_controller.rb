module Invoices
  class WizardController < ApplicationController
    load_and_authorize_resource :invoice

    def customer; end

    def activities
      @activities = @invoice.activities.eager_load(:efforts)
      @open_amount = ::Activity.open_amount_for(@invoice.customer)
    end

    def expenses
      @expenses = @invoice.expenses.eager_load(:efforts)
      @open_amount = ::Expense.open_amount_for(@invoice.customer)
    end

    def complete
      # combine vat rates from settings with vat rate of the invoice
      # uniq did not work on floats, why I map them to strings and back (yes, it's hacky).
      @vat_rates = (Settings.vat_rates + [@invoice.vat_rate]).map(&:to_s).uniq.map(&:to_f).sort.reverse
    end

    def summary; end

    def update
      if params[:invoice].blank? || @invoice.update(invoice_params)
        redirect_to redirect_path
      else
        render current_wizard_action
      end
    end

    private

    def current_wizard_action
      raise 'invalid action' if wizard_actions.keys.exclude? params[:current_wizard_action]&.to_sym

      params[:current_wizard_action].to_sym
    end

    def redirect_path
      provided_redirect_from_navigation || provided_redirect_from_params || invoice_path(@invoice)
    end

    # a redirection is provided with the name of the submit button
    # e.g. <input name="activites" value="Leistungen gruppieren"/>
    # with which the params-hash contains { activities: 'Leistungen gruppieren' }
    def provided_redirect_from_navigation
      action = wizard_actions.keys.find do |state|
        params.key? state.to_sym
      end
      wizard_actions[action][:path] if action
    end

    def provided_redirect_from_params
      params['referrer']
    end

    def wizard_actions
      @wizard_actions ||= {
        customer: {
          path: invoice_wizard_customer_path(@invoice),
        },
        activities: {
          path: invoice_wizard_activities_path(@invoice),
        },
        expenses: {
          path: invoice_wizard_expenses_path(@invoice),
        },
        complete: {
          path: invoice_wizard_complete_path(@invoice),
        },
        summary: {
          path: invoice_wizard_summary_path(@invoice),
        },
      }
    end

    def invoice_params
      params.require(:invoice).permit :employee_id,
                                      :customer_id,
                                      :date,
                                      :confidential,
                                      :title,
                                      :activities_amount_manually,
                                      :possible_wir_amount,
                                      :display_swift,
                                      :format,
                                      :vat_rate,
                                      :vat_amount,
                                      :total_amount,
                                      :created_by_initials,
                                      customer_attributes: %i[id address confidential_title invoice_hint]
    end

    def xeditable?(*)
      true
    end
    helper_method :xeditable?

    def default_invoice_title
      Invoices::Title.new(@invoice).to_s
    end
    helper_method :default_invoice_title

    def recent_invoices
      @recent_invoices ||= Invoice.where(customer: @invoice.customer)
                                  .order(date: :desc)
                                  .limit(10)
                                  .without(@invoice)
    end
    helper_method :recent_invoices
  end
end
