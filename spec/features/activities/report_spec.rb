require 'rails_helper'

describe 'Activities Report' do
  before do
    sign_in create :employee
  end

  it 'create report' do
    visit new_activities_report_path

    click_button 'Auswertung erstellen'

    expect(page).to have_current_path new_activities_report_path(format: :pdf), ignore_query: true
    expect(page.status_code).to eq 200
  end
end
