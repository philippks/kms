require 'rails_helper'

describe 'Managing Text Templates' do
  let(:activity_category) { create :activity_category }
  let(:text_template) do
    create :text_template, activity_category:, text: 'Irgendeine Vorlage'
  end

  before do
    sign_in create :employee
  end

  it 'List Text Templates' do
    text_template.touch

    visit activity_category_text_templates_path(activity_category)
    expect(page).to have_text('Irgendeine Vorlage')
  end

  it 'Create new Text Template' do
    visit new_activity_category_text_template_path(activity_category)

    fill_in 'Text', with: 'Eine Vorlage'
    click_button 'Vorlage erfassen'

    expect(page).to have_text 'Eine Vorlage'
  end

  it 'Update a Text Template' do
    visit edit_activity_category_text_template_path(activity_category, text_template)

    fill_in 'Text', with: 'Aktualisierte Vorlage'
    click_button 'Vorlage aktualisieren'

    expect(page).to have_text 'Vorlage wurde gespeichert'
  end

  it 'Destroy a Text Template' do
    visit edit_activity_category_text_template_path(activity_category, text_template)

    click_link 'Löschen'

    expect(page).to have_text 'Vorlage wurde gelöscht.'
  end
end
