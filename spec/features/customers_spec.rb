require 'rails_helper'

describe 'Managing Customers' do
  let!(:customer) { create :customer, name: 'Hans Meier', address: 'Hansstrasse 10\n4312 Meiershausen' }

  before do
    sign_in create :employee
  end

  it 'List Customers' do
    visit customers_path
    expect(page).to have_text('Hans Meier')
  end

  it 'Export Customers' do
    visit customers_path

    click_link 'Exportieren'

    expected = <<~EXPECTED.chomp
      "name","confidential_title","address","email_address","customer_group_name","invoice_hint" "Hans Meier","Hansi","Hansstrasse 10\\n4312 Meiershausen","hans@hausen.ch","",""
    EXPECTED

    expect(page.text).to eq expected
  end

  it 'Create new Customer' do
    visit new_customer_path

    fill_in 'Name', with: 'Friedrich Schiller'
    fill_in 'Adresse', with: 'Irgendwo'
    fill_in 'E-Mail Adresse', with: 'friedrich@schiller.ch'
    click_button 'Kunde erfassen'

    expect(page).to have_text('Kunde wurde erfasst')
  end

  it 'Update a Customer' do
    visit edit_customer_path(customer)

    fill_in 'Name', with: 'Friedrich Schiller'
    fill_in 'Adresse', with: 'Neue Adresse'
    click_button 'Kunde aktualisieren'

    expect(page).to have_text('Kunde wurde gespeichert')
  end

  it 'Destroy a Customer' do
    visit edit_customer_path(customer)

    click_link 'Löschen'

    expect(page).to have_text 'Kunde wurde gelöscht.'
  end
end
