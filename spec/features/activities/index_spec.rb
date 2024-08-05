require 'rails_helper'

describe 'List Activities' do
  let(:text) { 'Einfach etwas' }
  let(:employee) { create :employee }
  let(:customer) { create :customer, name: 'Max' }
  let!(:activities) do
    create_list :activity, 2, employee:,
                              customer:,
                              date: Date.current,
                              text:,
                              hours: 2,
                              hourly_rate: 150
  end

  before do
    sign_in employee
  end

  it 'List Activities' do
    visit activities_path

    expect(page).to have_text(text)
    expect(page).to have_text('600.00') # total amount
    expect(page).to have_text('4') # total hours
  end

  it 'Export CSV' do
    visit activities_path

    click_link 'Als CSV'

    header = page.response_headers['Content-Disposition']
    expect(header).to include 'attachment; filename="Leistungen_Export.csv"'
    expect(page).to have_text('Kunde')
    expect(page).to have_text('300.00', count: 2)
    expect(page).to have_text(text)
    expect(page).to have_text(customer.name)
    expect(page).to have_text(employee.name)
  end

  it 'Export PDF' do
    visit activities_path

    click_link 'Exportieren'

    header = page.response_headers['Content-Disposition']
    expect(header).to include 'attachment; filename="Leistungen_Export.pdf"'
  end
end
