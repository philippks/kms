require 'rails_helper'

feature 'Deliver Invoice' do
  let(:employee) { create :employee }
  let(:customer) { create :customer, confidential_title: 'Hansi', email_address: 'hans@muster.ch' }
  let!(:invoice) { create :invoice, employee: employee, customer: customer, state: :open }

  before do
    sign_in employee
  end

  scenario 'Chose via Post' do
    visit new_invoice_delivery_path(invoice)

    select 'Post', from: 'Rechnungsversand'

    expect do
      click_button 'Weiter'
    end.to change { invoice.reload.state.to_sym }.from(:open).to(:sent)
  end

  scenario 'Chose via Mail' do
    visit new_invoice_delivery_path(invoice)

    select 'E-Mail', from: 'Rechnungsversand'
    fill_in 'Vertrauliche Anrede', with: 'Öperd'
    fill_in 'E-Mail Adresse', with: 'some@one.ch'

    expect do
      click_button 'Weiter'
    end.to change { page.current_path }.to new_invoice_mail_path(invoice)
  end

  scenario 'Send Mail' do
    FileUtils.touch Invoices::PDF.new(invoice).persisted_pdf_path

    visit new_invoice_mail_path(invoice)

    expect(page).to have_text 'Guten Tag Hansi'

    expect do
      click_button 'Rechnung per E-Mail verschicken'
    end.to change { invoice.reload.state.to_sym }.from(:open).to(:sent)

    expect(ActionMailer::Base.deliveries.last.to[0]).to eq 'hans@muster.ch'
  end
end
