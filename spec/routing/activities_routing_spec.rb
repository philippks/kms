require 'rails_helper'

RSpec.describe 'routes for activities' do
  describe 'suggestions' do
    describe 'url' do
      it 'routes correctly' do
        expect(get: '/activities/suggestions').to route_to(
          controller: 'activities/suggestions',
          action: 'index'
        )
      end
    end

    describe 'path helper' do
      it 'routes correctly' do
        expect(get: activities_suggestions_path).to route_to(
          controller: 'activities/suggestions',
          action: 'index'
        )
      end
    end
  end

  describe 'reports' do
    describe 'url' do
      it 'routes correctly' do
        expect(get: '/activities/reports/new').to route_to(
          controller: 'activities/reports',
          action: 'new'
        )
      end
    end

    describe 'path helper' do
      it 'routes correctly' do
        expect(get: new_activities_report_path).to route_to(
          controller: 'activities/reports',
          action: 'new'
        )
      end
    end
  end
end
