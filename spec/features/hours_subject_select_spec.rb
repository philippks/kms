require 'rails_helper'

feature 'Select Hours Subject' do
  let(:employee) { create :employee }
  let!(:customer) { create :customer, name: 'Fritzli' }

  before do
    sign_in employee
  end

  scenario 'Select Activity', js: true do
    # subject select is available on every view
    visit absences_path

    xpath = '//*[@id="hours_subject_select"]//..//*[contains(@class, "select2-container")]'
    select2('Fritzli', xpath: xpath, search: true)

    # redirected to new activity page and select customer
    expect(current_path).to eq new_activity_path
    expect(page).to have_text 'Fritzli'
  end
end
