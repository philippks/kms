module EntitiesFilterable
  extend ActiveSupport::Concern

  included do
    before_action :initialize_filter, only: :index
  end

  def default_filter; end

  def initialize_filter
    @filter = EntitiesFilter.new filter_params

    store_filter_in_session
  end

  def filter_params
    return stored_filter || default_filter unless filter_provided?
    return {} unless params[:filter]

    params.require(:filter).permit(:customer_group,
                                   :employee,
                                   :state,
                                   :activity_category,
                                   :reason,
                                   :from,
                                   :to,
                                   customer: []).to_h
  end

  private

  def store_filter_in_session
    session[:stored_date] = Date.current.iso8601
    session["#{controller_name}_stored_filter"] = @filter.parameters
  end

  def stored_filter
    return nil if session[:stored_date] != Date.current.iso8601

    session["#{controller_name}_stored_filter"]&.symbolize_keys
  end

  def filter_provided?
    params[:utf8] || params[:filter]
  end
end
