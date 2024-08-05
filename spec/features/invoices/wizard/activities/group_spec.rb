require 'rails_helper'

describe 'Group Invoice Activities' do
  let(:invoice) { create :invoice, :default_associations }

  let!(:invoice_activity) do
    create :invoice_activity, invoice:,
                              text: 'Something done',
                              position: 1
  end

  let!(:another_invoice_activity) do
    create :invoice_activity, invoice:,
                              text: 'Something else done',
                              position: 2
  end

  let!(:activity) do
    create :activity, :default_associations,
           hours: 1,
           hourly_rate: 100,
           date: 1.day.ago,
           invoice_effort_id: invoice_activity.id
  end

  let!(:another_activity) do
    create :activity, :default_associations,
           hours: 1,
           hourly_rate: 100,
           date: 10.day.ago,
           invoice_effort_id: another_invoice_activity.id
  end

  before do
    create :invoice_activity, invoice:, position: 3

    sign_in invoice.employee
  end

  it 'Group Invoice Activities', js: true do
    visit invoice_wizard_activities_path(invoice)

    find(:css, "#effort_ids_[value='#{invoice_activity.id}']").set(true)
    find(:css, "#effort_ids_[value='#{another_invoice_activity.id}']").set(true)

    click_button 'Leistungen zusammenführen'

    aggregate_failures 'new invoice activity' do
      within 'td.amount' do
        expect(page).to have_text('200.00')
      end
      expect(Invoices::Activity.count).to eq 2
      expect(Invoices::Activity.first.text).to eq 'Something done'
      expect(Invoices::Activity.first.efforts).to match_array [another_activity, activity]
      expect(Invoices::Activity.first.position).to eq 1
    end
  end
end
