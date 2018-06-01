module Invoices
  class ActivitiesController < EffortsController
    load_and_authorize_resource :invoice
    load_and_authorize_resource through: :invoice

    respond_to :html
    respond_to :json, only: [:update]

    def create
      @activity.save
      redirect_to invoice_wizard_activities_path(@invoice)
    end

    def update
      respond_to do |format|
        if @activity.update activity_params
          format.html { redirect_to invoice_wizard_activities_path(@invoice) }
          format.json { head :no_content }
        else
          format.html { render action: 'index' }
          format.json { render json: @activity.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @activity.destroy
      redirect_to invoice_wizard_activities_path(@invoice)
    end

    def toggle_pagebreak
      @activity.update pagebreak: !@activity.pagebreak
      redirect_to invoice_wizard_activities_path(@invoice)
    end

    def templates
      @activity_categories = ActivityCategory.joins(:text_templates)
                                             .distinct
                                             .includes(:text_templates)
                                             .order(created_at: :asc)
    end

    def generate
      Invoices::Activities::Generate.new(@invoice).generate!
      redirect_to invoice_wizard_activities_path(@invoice)
    end

    def effort
      @activity
    end

    def effort_params
      activity_params
    end

    def invoice_wizard_path
      invoice_wizard_activities_path(@invoice)
    end

    private

    def activity_params
      params.require(:activity).permit :invoice_id,
                                       :text,
                                       :visible,
                                       :confidential,
                                       :hourly_rate_manually,
                                       :hours_manually,
                                       :position,
                                       effort_ids: []
    end
  end
end
