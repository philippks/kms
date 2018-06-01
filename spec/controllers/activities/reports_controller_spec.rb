require 'rails_helper'

RSpec.describe Activities::ReportsController do
  before do
    sign_in create :employee
  end

  describe 'GET #new' do
    it 'assigns report with correct dates' do
      get :new

      expect(assigns(:report).from_date).to eq Date.current.beginning_of_month
      expect(assigns(:report).to_date).to eq Date.current.end_of_month
    end

    context 'with params' do
      let(:from_date) { 1.year.ago.beginning_of_month.to_date }
      let(:to_date) { 1.year.ago.end_of_month.to_date }

      it 'assigns report with given dates' do
        get :new, format: :pdf, params: { activities_report: { from_date: from_date, to_date: to_date } }

        expect(assigns(:report).from_date).to eq from_date
        expect(assigns(:report).to_date).to eq to_date
      end
    end
  end
end
