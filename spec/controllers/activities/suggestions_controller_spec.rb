require 'rails_helper'

RSpec.describe Activities::SuggestionsController do
  describe 'GET #index' do
    let(:builder) { double }

    before do
      sign_in create :employee
    end

    it 'returns suggestions' do
      expect(Activities::SuggestionsBuilder).to receive(:new).with(
        query: 'asdf',
        customer_id: '2',
        activity_category_id: '3'
      ).and_return builder

      expect(builder).to receive(:build).and_return 'some json'

      get :index, params: {
        query: 'asdf',
        customer_id: 2,
        activity_category_id: 3,
        format: :json
      }
      expect(response.body).to eq 'some json'
    end
  end
end
