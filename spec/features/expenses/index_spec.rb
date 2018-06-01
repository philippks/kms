require 'rails_helper'

feature 'List Expenses' do
  let(:text) { 'Eine kleine Ausgabe' }
  let(:employee) { create :employee }
  let(:customer) { create :customer }
  let!(:expense) do
    create :expense, customer: customer,
                     employee: employee,
                     text: text,
                     amount: 20
  end

  before do
    sign_in employee
  end

  scenario 'List Expenses' do
    visit expenses_path
    expect(page).to have_text(text)
  end

  it 'shows total amount' do
    create :expense, customer: customer,
                     employee: employee,
                     amount: 270.50

    visit expenses_path
    expect(page).to have_text('290.50')
  end
end
