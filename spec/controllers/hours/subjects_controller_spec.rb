require 'rails_helper'

RSpec.describe Hours::SubjectsController do
  render_views

  let(:employee) { create :employee }

  before do
    sign_in employee
  end

  let(:parsed_response) { JSON.parse response.body }

  describe 'GET #index' do
    let!(:customer) { create :customer, id: 777, name: 'Fritzli' }

    it 'returns categories' do
      get :index, format: :json, params: { query: 'F' }

      expect(parsed_response.first['text']).to eq 'Abwesenheitsgrund'
      expect(parsed_response.second['text']).to eq 'Kunde'
    end

    context 'with empty query' do
      before do
        create :activity, employee: employee, customer: customer
      end

      it 'returns only last customers' do
        get :index, format: :json, params: { query: '' }

        expect(parsed_response.first['text']).to eq 'Letzte Kunden'
      end
    end
  end
end
