require 'rails_helper'

feature 'Manage Mails' do
  let(:employee) { create :employee }
  let(:customer) { create :customer }
  let(:invoice) { create :invoice, employee: employee, customer: customer, state: :sent, sent_at: '2017-01-01 12:00' }
  let!(:mail) do
    create :invoice_mail, invoice: invoice,
                          employee: employee,
                          body: 'Some text',
                          from: Global.mailer.from,
                          to: 'customers@mail.ch'
  end

  before do
    sign_in employee
  end

  scenario 'Show Mail' do
    visit invoice_mail_path(invoice)

    expect(page).to have_text '01.01.2017 12:00'
    expect(page).to have_field 'Text der E-Mail', with: mail.body
    expect(page).to have_field 'Absenderadresse', with: Global.mailer.from
    expect(page).to have_field 'Empfängeradresse', with: 'customers@mail.ch'
  end
end
