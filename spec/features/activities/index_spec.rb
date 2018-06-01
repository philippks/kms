require 'rails_helper'

feature 'List Activities' do
  let(:text) { 'Einfach etwas' }
  let(:employee) { create :employee }
  let(:customer) { create :customer, name: 'Max' }
  let!(:activities) do
    create_list :activity, 2, employee: employee,
                              customer: customer,
                              date: Date.current,
                              text: text,
                              hours: 2,
                              hourly_rate: 150
  end

  before do
    sign_in employee
  end

  scenario 'List Activities' do
    visit activities_path

    expect(page).to have_text(text)
    expect(page).to have_text("600.00") # total amount
    expect(page).to have_text('4') # total hours
  end

  scenario 'Export XLS' do
    visit activities_path

    click_link 'Als XLS'

    header = page.response_headers['Content-Disposition']
    expect(header).to eq 'attachment; filename=Leistungen_Export.xls'
    expect(page).to have_text('Kunde')
    expect(page).to have_text('300.00', count: 2)
    expect(page).to have_text(text)
    expect(page).to have_text(customer.name)
    expect(page).to have_text(employee.name)
  end

  scenario 'Export PDF' do
    visit activities_path

    click_link 'Leistungen exportieren'

    header = page.response_headers['Content-Disposition']
    expect(header).to eq 'attachment; filename="Leistungen_Export.pdf"'
  end
end
