require 'rails_helper'

describe 'Manage Invoice Activities' do
  let(:invoice) { create :invoice, :default_associations }

  let(:invoice_activity) do
    create :invoice_activity, invoice:, pagebreak: false
  end

  before do
    invoice_activity.touch

    sign_in invoice.employee
  end

  it 'Toggle Pagebreak' do
    visit invoice_wizard_activities_path(invoice)

    find('.fa-cut').find(:xpath, './/..').click

    expect(invoice_activity.reload.pagebreak).to be true
  end
end
