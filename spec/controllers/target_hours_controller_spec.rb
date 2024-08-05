require 'rails_helper'

RSpec.describe TargetHoursController do
  render_views

  let(:date) { '2015-01-19' }

  before do
    sign_in create :employee
  end

  describe 'GET #index' do
    it 'lists all target hours' do
      create :target_hours, date:, hours: 0
      get :index, params: { format: :json, start: '2015-01-01', end: '2015-01-31' }
      expect(JSON.parse(response.body).first['title']).to eq '0 Stunden'
    end
  end

  describe 'PATCH #update' do
    it 'creates a target hours instance for the first update' do
      expect do
        patch :update, params: { format: :json, date: }
      end.to change { TargetHours.count }.by(1)
    end

    it 'deletes the target hours instance if updated to 8 hours' do
      create :target_hours, date:, hours: 8
      expect do
        patch :update, params: { format: :json, date: }
      end.to change { TargetHours.count }.to(0)
    end
  end
end
