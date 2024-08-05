require 'rails_helper'

RSpec.describe Invoices::Activities::SuggestionsController do
  describe 'GET #index' do
    let(:builder) { double }

    before do
      sign_in create :employee
      expect(Invoices::Activities::SuggestionsBuilder).to receive(:new).with(
        query: 'asdf',
        invoice_activity_id: '2'
      ).and_return builder

      expect(builder).to receive(:build).and_return 'some json'
    end

    it 'returns suggestions' do
      get :index, params: {
        query: 'asdf',
        invoice_activity_id: 2,
        format: :json,
      }

      expect(response.body).to eq 'some json'
    end
  end
end
