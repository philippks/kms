require 'rails_helper'

feature 'OP List' do
  let(:employee_1) { create :employee, name: 'Jemand' }
  let(:employee_2) { create :employee, name: 'Und noch Jemand' }
  let(:customer) { create :customer, name: 'Adolf' }

  let!(:new_open_activity) do
    create :activity, customer: customer, employee: employee_1, hours: 1, hourly_rate: 150, date: '2017-01-01'
  end
  let!(:old_open_activity) do
    create :activity, customer: customer, employee: employee_2, hours: 2, hourly_rate: 100, date: '2016-01-01'
  end
  let!(:charged_activity) { create :activity, :charged, :with_associations }

  before do
    sign_in employee_1
  end

  scenario 'New OP List' do
    visit new_op_list_path

    expect(page).to have_text('Adolf')
    expect(page).to have_text('350.00')
    expect(page).to have_text('Jemand, Und noch Jemand')
    expect(page).to have_text('Januar 2016 bis Januar 2017')
  end

  scenario 'Filter OP List', js: true do
    create :employee, name: 'Jemand anders'

    visit new_op_list_path

    xpath = '//*[@id="filter_employee"]//..//*[contains(@class, "select2-container")]'
    select2('Jemand anders', xpath: xpath, search: true)

    expect(page).to have_text('Keine Offenen Posten vorhanden.')
  end

  scenario 'Create Invoice' do
    visit new_op_list_path

    expect do
      click_on 'Rechnung erstellen'
    end.to change { Invoice.count }.by 1

    expect(Invoice.last.activities.first.efforts).to match_array [new_open_activity, old_open_activity]
  end

  scenario 'Download OP List' do
    visit new_op_list_path

    click_on 'Herunterladen'

    expect(current_path).to eq new_op_list_path(format: :pdf)
    expect(page.status_code).to eq 200
  end
end
