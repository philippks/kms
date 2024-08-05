require 'rails_helper'

describe 'Managing Activity Categories' do
  let(:activity_category) { create :activity_category, name: 'Steuern' }

  before do
    sign_in create :employee
  end

  it 'List Activity Categories' do
    activity_category.touch
    create(:text_template, activity_category:)

    visit activity_categories_path
    expect(page).to have_text('Steuern')
    expect(page).to have_link('1 Vorlage', href: activity_category_text_templates_path(activity_category))
  end

  it 'Create new Activity Category' do
    visit new_activity_category_path

    fill_in 'Name', with: 'Buchhaltung'
    click_button 'Leistungskategorie erfassen'

    expect(page).to have_text('Buchhaltung')
  end

  it 'Update a Activity Category' do
    visit edit_activity_category_path(activity_category)

    fill_in 'Name', with: 'Aktualisierte Leistungskategorie'
    click_button 'Leistungskategorie aktualisieren'

    expect(page).to have_text('Leistungskategorie wurde gespeichert')
  end

  it 'Destroy a Activity Category' do
    visit edit_activity_category_path(activity_category)

    click_link 'Löschen'

    expect(page).to have_text 'Leistungskategorie wurde gelöscht.'
  end
end
