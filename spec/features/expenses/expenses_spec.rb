require 'rails_helper'

feature 'Managing Expenses' do
  let(:text) { 'Eine grössere Ausgabe' }
  let(:employee) { create :employee }
  let(:customer) { create :customer, name: 'Max' }
  let(:expense) { create :expense, employee: employee, text: text }

  before do
    customer.touch
    expense.touch

    sign_in employee
  end

  scenario 'Create new Expense', js: true do
    visit new_expense_path

    fill_in 'Betrag', with: 300
    fill_in 'Text', with: text
    select2('Max', from: 'Kunde', search: true)

    click_button 'Nebenkosten erfassen'

    expect(page).to have_text('Nebenkosten wurde erfasst')
  end

  scenario 'Update a Expense' do
    visit edit_expense_path(expense)

    fill_in 'Text', with: 'Aktualisierte Nebenkosten'
    click_button 'Nebenkosten aktualisieren'

    expect(page).to have_text('Nebenkosten wurde gespeichert')
  end

  scenario 'Destroy a Expense' do
    visit edit_expense_path(expense)

    click_link 'Löschen'

    expect(page).to have_content 'Nebenkosten wurde gelöscht.'
  end
end
