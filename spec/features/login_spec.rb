require 'rails_helper'

describe 'Login / Logout' do
  let!(:employee) do
    create :employee, name: 'Max',
                      email: 'someone@kms.ch',
                      password: 'password',
                      password_confirmation: 'password'
  end

  it 'login' do
    visit new_employee_session_path

    fill_in 'E-Mail-Adresse', with: 'someone@kms.ch'
    fill_in 'Passwort', with: 'password'

    click_button 'Anmelden'

    expect(page).to have_current_path activities_path, ignore_query: true
  end

  it 'invalid login' do
    visit new_employee_session_path

    fill_in 'E-Mail-Adresse', with: 'someone@kms.ch'
    fill_in 'Passwort', with: 'wrong pw'

    click_button 'Anmelden'

    expect(page).to have_text 'Ungültige Anmeldedaten'
    expect(page).to have_current_path new_employee_session_path, ignore_query: true
  end

  it 'logout' do
    sign_in employee

    visit root_path

    expect(page).to have_current_path activities_path, ignore_query: true

    click_link 'Max abmelden'

    expect(page).to have_current_path new_employee_session_path, ignore_query: true
  end
end
