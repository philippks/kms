module Invoices
  module Activities
    class SuggestionsController < ApplicationController
      respond_to :json, only: :index

      def index
        respond_to do |format|
          format.json do
            render json: suggestions
          end
        end
      end

      private

      def suggestions
        SuggestionsBuilder.new(
          query: params[:query],
          invoice_activity_id: params[:invoice_activity_id]
        ).build
      end
    end
  end
end
