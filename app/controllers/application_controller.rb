require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  before_action :authenticate_employee!
  before_action :set_paper_trail_whodunnit
  before_action :set_sentry_context

  alias current_user current_employee

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception, prepend: true

  rescue_from CanCan::AccessDenied do |exception|
    Sentry.capture_exception exception
    redirect_url = request.env['HTTP_REFERER'].present? :back, root_url
    redirect_to redirect_url, flash: { warning: I18n.t('application.access_denied') }
  end

  private

  def set_sentry_context
    return if current_user.blank?

    Sentry.set_user(id: current_user.id, username: current_user.name, email: current_user.email)
  end
end
