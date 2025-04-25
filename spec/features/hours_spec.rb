require 'rails_helper'

describe 'View Hours' do
  let(:employee) { create :employee }

  before do
    sign_in employee
  end

  around do |example|
    Timecop.freeze '2017-04-25' do
      example.call
    end
  end

  it 'View Total Hours' do
    create :activity, :default_associations, date: Date.current, hours: 1.3
    create :activity, :default_associations, date: 1.day.ago, hours: 2.3

    create :target_hours, date: '2017-04-17', hours: 4
    create :absence, :default_associations, from_date: '2017-04-17',
                                            to_date: '2017-04-21',
                                            hours: 36
    create :absence, :default_associations, from_date: '2017-04-6',
                                            to_date: '2017-04-6',
                                            hours: 4

    # elements not in this month
    create :target_hours, date: '2017-03-17', hours: 4
    create :activity, :default_associations, date: 1.month.ago, hours: 10
    create :absence, :default_associations, from_date: '2017-03-27',
                                            to_date: '2017-03-28',
                                            hours: 16
    create :absence, :default_associations, from_date: '2017-03-29',
                                            to_date: '2017-03-29',
                                            hours: 8

    visit hours_path

    expect(page).to have_text('3.6') # activity hours
    expect(page).to have_text('40') # absence hours
    expect(page).to have_text('43.6') # total hours
    expect(page).to have_text('156') # target hours
  end
end
