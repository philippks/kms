require 'rails_helper'

feature 'Activities Report' do
  before do
    sign_in create :employee
  end

  scenario 'create report' do
    visit new_activities_report_path

    click_button 'Auswertung erstellen'

    expect(current_path).to eq new_activities_report_path(format: :pdf)
    expect(page.status_code).to eq 200
  end
end
