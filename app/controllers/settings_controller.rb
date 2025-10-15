class SettingsController < ApplicationController
  responders :flash

  def index
    @settings = Settings.get
    render :edit, format: :html
  end

  def update
    @settings = Settings.get
    @settings.update settings_params
    respond_with @settings, location: settings_path
  end

  private

  def settings_params
    params.require(:settings).permit :vat_rates
  end
end
