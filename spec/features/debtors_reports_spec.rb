require 'rails_helper'

feature 'Create a Debtors Report' do
  let!(:debtor) do
    create :invoice, :default_associations, state: :sent,
                                            date: 100.days.ago,
                                            activities_amount_manually: 200
  end
  let!(:second_debtor) do
    create :invoice, :default_associations, state: :sent,
                                            date: 10.days.ago,
                                            activities_amount_manually: 200
  end

  let(:total_amount) { debtor.open_amount + second_debtor.open_amount }
  let(:range_1_total_amount) { second_debtor.open_amount }
  let(:range_4_total_amount) { debtor.open_amount }

  before do
    sign_in create :employee

    create :payment, invoice: debtor, date: 10.days.ago, amount: 100
  end

  scenario 'Renders all infos' do
    visit new_debtors_report_path

    expect(page).to have_css 'td', text: debtor.customer.name
    expect(page).to have_css 'td', text: 100 # overdue
    expect(page).to have_css 'td', text: debtor.reload.open_amount
    expect(page).to have_css 'td', text: second_debtor.open_amount
    expect(page).to have_css 'td', text: second_debtor.open_amount
    expect(page).to have_css 'td', text: range_1_total_amount
    expect(page).to have_css 'td', text: range_4_total_amount
    expect(page).to have_link 'Zur Rechnung', href: invoice_path(debtor)
  end

  scenario 'Redirects when changing the date', js: true do
    visit new_debtors_report_path

    # chose new date
    find(:xpath, '//*[@id="debtors_report_until_date"]').set 20.days.ago

    # manually trigger event... remove when replacing debtor list
    page.execute_script("$('#debtors_report_until_date').trigger('hide')")

    # expect to be redirected
    expect(page).to have_css 'td', text: '80'

    expected_link = new_debtors_report_path(format: :pdf, debtors_report: { until_date: 20.days.ago.to_date.iso8601 })
    expect(page).to have_link 'Herunterladen', href: expected_link
  end

  scenario 'Download Report' do
    visit new_debtors_report_path

    click_link 'Herunterladen'

    expect(current_path).to eq new_debtors_report_path(format: :pdf)
    expect(page.status_code).to eq 200
  end
end
