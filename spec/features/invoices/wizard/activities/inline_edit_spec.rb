require 'rails_helper'

feature 'Inline-Edit Activity Text' do
  let(:invoice) { create :invoice, :default_associations }
  let!(:invoice_activity) { create :invoice_activity, text: 'Lala', invoice: invoice }

  before do
    sign_in invoice.employee
  end

  scenario 'Edit Text with Inline-Edit', js: true do
    visit invoice_wizard_activities_path(invoice)

    page.find('span', text: 'Lala').click

    expect(page).to have_link('Vorlagen aus Leistungskategorien',
                              href: invoice_activity_templates_path(invoice, invoice_activity))

    within(:css, 'div.editable-input') do
      find(:css, 'textarea').set 'Juhui'
    end
    page.find('div.editable-buttons').find('button').click

    expect(page).to have_text('Juhui')
    expect(invoice_activity.reload.text).to eq 'Juhui'
  end
end
