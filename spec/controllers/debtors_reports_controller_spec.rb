require 'rails_helper'
RSpec.describe DebtorsReportsController do
  before do
    sign_in create :employee
  end

  describe 'GET #new' do
    let!(:charged_invoice) { create :invoice, :default_associations, state: :charged }
    let!(:sent_invoice) do
      create :invoice, :default_associations, date: 1.day.ago, state: :sent
    end
    let!(:long_sent_invoice) do
      create :invoice, :default_associations, state: :sent, date: 200.days.ago
    end

    it 'assigns debtors' do
      get :new

      expect(assigns(:debtors).to_a).to eq [sent_invoice, long_sent_invoice]
    end

    it 'assigns overdues' do
      get :new

      expect(assigns(:overdues)[long_sent_invoice]).to eq 200
    end

    context 'when invoice date is after until_date' do
      before do
        get :new, params: { debtors_report: { until_date: 100.days.ago } }
      end

      it 'assigns only sent invoices until this date' do
        expect(assigns(:debtors).to_a).to eq [long_sent_invoice]
      end

      it 'calculates overdues correctly until this date' do
        expect(assigns(:overdues)[long_sent_invoice]).to eq 100
      end
    end
  end

  describe 'POST #create' do
    it 'redirects to new_path with given until_date' do
      post :create, params: { debtors_report: { until_date: '20.05.2015' } }

      expect(response).to redirect_to new_debtors_report_path(
        debtors_report: { until_date: '2015-05-20' }
      )
    end
  end
end
