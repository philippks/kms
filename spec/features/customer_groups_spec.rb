require 'rails_helper'

feature 'Managing Customer Groups' do
  let(:customer_group) { create :customer_group, name: 'BNI' }

  before do
    sign_in create :employee
  end

  scenario 'List Customer Groups' do
    customer_group.touch

    visit customer_groups_path
    expect(page).to have_text('BNI')
  end

  scenario 'Create new Customer Group' do
    visit new_customer_group_path

    fill_in 'Name', with: 'Administration'
    check 'Nicht verrechenbar'
    click_button 'Kundengruppe erfassen'

    expect(page).to have_text('Administration')
  end

  scenario 'Update a Customer Group' do
    visit edit_customer_group_path(customer_group)

    fill_in 'Name', with: 'Aktualisierte Kundengruppe'
    click_button 'Kundengruppe aktualisieren'

    expect(page).to have_text('Kundengruppe wurde gespeichert')
  end

  scenario 'Destroy a Customer Group' do
    visit edit_customer_group_path(customer_group)

    click_link 'Löschen'

    expect(page).to have_text 'Kundengruppe wurde gelöscht.'
  end
end
