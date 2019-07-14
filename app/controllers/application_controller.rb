require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  before_action :authenticate_employee!
  before_action :set_paper_trail_whodunnit
  before_action :set_raven_context

  alias current_user current_employee

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception, prepend: true

  rescue_from CanCan::AccessDenied do |exception|
    Raven.capture_exception exception
    redirect_url = request.env["HTTP_REFERER"].present? :back, root_url
    redirect_to redirect_url, flash: { warning: I18n.t('application.access_denied') }
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
