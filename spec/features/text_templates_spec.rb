require 'rails_helper'

feature 'Managing Text Templates' do
  let(:activity_category) { create :activity_category }
  let(:text_template) do
    create :text_template, activity_category: activity_category, text: 'Irgendeine Vorlage'
  end

  before do
    sign_in create :employee
  end

  scenario 'List Text Templates' do
    text_template.touch

    visit activity_category_text_templates_path(activity_category)
    expect(page).to have_text('Irgendeine Vorlage')
  end

  scenario 'Create new Text Template' do
    visit new_activity_category_text_template_path(activity_category)

    fill_in 'Text', with: 'Eine Vorlage'
    click_button 'Vorlage erfassen'

    expect(page).to have_text 'Eine Vorlage'
  end

  scenario 'Update a Text Template' do
    visit edit_activity_category_text_template_path(activity_category, text_template)

    fill_in 'Text', with: 'Aktualisierte Vorlage'
    click_button 'Vorlage aktualisieren'

    expect(page).to have_text 'Vorlage wurde gespeichert'
  end

  scenario 'Destroy a Text Template' do
    visit edit_activity_category_text_template_path(activity_category, text_template)

    click_link 'Löschen'

    expect(page).to have_text 'Vorlage wurde gelöscht.'
  end
end
