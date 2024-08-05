require 'rails_helper'

describe 'Select Hours Subject' do
  let(:employee) { create :employee }
  let!(:customer) { create :customer, name: 'Fritzli' }

  before do
    sign_in employee
  end

  it 'Select Activity', js: true do
    # subject select is available on every view
    visit absences_path

    xpath = '//*[@id="hours_subject_select"]//..//*[contains(@class, "select2-container")]'
    select2('Fritzli', xpath:, search: true)

    # redirected to new activity page and select customer
    expect(page).to have_current_path new_activity_path, ignore_query: true
    expect(page).to have_text 'Fritzli'
  end
end
