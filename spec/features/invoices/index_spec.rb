require 'rails_helper'

describe 'List Invoices' do
  let(:employee) { create :employee }
  let(:customer) { create :customer, name: 'Max' }

  before do
    sign_in employee

    create :invoice, employee:,
                     customer:,
                     date: '2019-01-01',
                     state: :open,
                     persisted_total_amount_cents: 10_000

    create :invoice, employee:,
                     customer:,
                     date: '2018-12-12',
                     state: :sent,
                     persisted_total_amount_cents: 20_000
  end

  it 'List Invoices' do
    visit invoices_path

    expect(page).to have_text('100.00') # first amount
    expect(page).to have_text('01.01.2019')
    expect(page).to have_text('Offen')

    expect(page).to have_text('200.00') # second amount
    expect(page).to have_text('12.12.2018')
    expect(page).to have_text('Verschickt')

    expect(page).to have_text('Total 300') # total amount
  end

  it 'Export CSV' do
    visit invoices_path

    click_link 'Als CSV'

    header = page.response_headers['Content-Disposition']
    expect(header).to include 'attachment; filename="Rechnungen_Export.csv"'
    expect(page).to have_text('Kunde')

    expect(page).to have_text('100.00') # first amount
    expect(page).to have_text('01.01.2019')
    expect(page).to have_text('Offen')

    expect(page).to have_text('200.00') # second amount
    expect(page).to have_text('12.12.2018')
    expect(page).to have_text('Verschickt')

    expect(page).to have_text(customer.name)
    expect(page).to have_text(employee.name)
  end

  it 'Export PDF' do
    visit invoices_path

    click_link 'Exportieren'

    header = page.response_headers['Content-Disposition']
    expect(header).to include 'attachment; filename="Rechnungen_Export.pdf"'
  end
end
