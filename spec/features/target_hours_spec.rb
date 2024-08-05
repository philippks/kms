require 'rails_helper'

describe 'Manage Target Hours' do
  let(:employee) { create :employee }

  before do
    sign_in employee
  end

  around do |example|
    Timecop.freeze '2017-01-01' do
      example.call
    end
  end

  it 'View Target Hours', :js do
    create :target_hours, date: '2017-01-02', hours: 4
    create :target_hours, date: '2017-01-03', hours: 0

    visit target_hours_path

    expect(page).to have_text('4 Stunden')
    expect(page).to have_text('0 Stunden')
    expect(page).to have_text('8 Stunden', count: 20)
  end
end
