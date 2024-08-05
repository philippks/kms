require 'rails_helper'

describe 'Filter Activities' do
  let!(:open_activity) do
    create :activity, :default_associations, date: Date.current,
                                             text: 'Offene Leistung',
                                             state: :open
  end

  let!(:charged_activity) do
    create :activity, :default_associations, date: Date.current,
                                             text: 'Verrechnet Leistung',
                                             state: :open
  end

  before do
    sign_in open_activity.employee
  end

  it 'by state', js: true do
    visit activities_path

    # select state 'Offen'
    find('#filter_state').find(:xpath, 'option[1]').select_option

    expect(page).not_to have_text('Verrechnete Leistung')
    expect(page).to have_text('Offene Leistung')
  end
end
