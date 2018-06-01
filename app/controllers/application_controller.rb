require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  before_action :authenticate_employee!

  alias current_user current_employee

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception, prepend: true

  rescue_from CanCan::AccessDenied do |exception|
    Airbrake.notify exception
    redirect_url = request.env["HTTP_REFERER"].present? :back, root_url
    redirect_to redirect_url, flash: { warning: I18n.t('application.access_denied') }
  end
end
