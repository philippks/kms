require 'rails_helper'

describe 'List Expenses' do
  let(:text) { 'Eine kleine Ausgabe' }
  let(:employee) { create :employee }
  let(:customer) { create :customer }
  let!(:expense) do
    create :expense, customer:,
                     employee:,
                     text:,
                     amount: 20
  end

  before do
    sign_in employee
  end

  it 'List Expenses' do
    visit expenses_path
    expect(page).to have_text(text)
  end

  it 'shows total amount' do
    create :expense, customer:,
                     employee:,
                     amount: 270.50

    visit expenses_path
    expect(page).to have_text('290.50')
  end
end
