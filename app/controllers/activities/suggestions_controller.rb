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
        customer_id: params[:customer_id],
        activity_category_id: params[:activity_category_id]
      ).build
    end
  end
end
