require 'rails_helper'

RSpec.describe ActivityCategoriesController do
  let(:activity_category) { create :activity_category }

  before do
    sign_in create :employee
  end

  describe 'GET #index' do
    it 'lists all activity categories' do
      activity_category = create :activity_category
      get :index
      expect(assigns(:activity_categories)).to eq [activity_category]
    end
  end

  describe 'GET #new' do
    it 'assigns a new activity_category' do
      get :new
      expect(assigns(:activity_category)).to be_a_new ActivityCategory
    end
  end

  describe 'POST #create' do
    it 'creates a new activity_category' do
      expect do
        post :create, params: { activity_category: { name: 'Steuern' } }
      end.to change(ActivityCategory, :count).by(1)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested activity_category' do
      get :edit, params: { id: activity_category.to_param }
      expect(assigns(:activity_category)).to eq activity_category
    end
  end

  describe 'PATCH #update' do
    it 'updates the activity_category' do
      expect do
        patch :update, params: { id: activity_category.to_param, activity_category: { name: 'Administration' } }
      end.to change { activity_category.reload.name }.to('Administration')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys a activity_category' do
      activity_category = create :activity_category
      expect do
        delete :destroy, params: { id: activity_category.to_param }
      end.to change(ActivityCategory, :count).by(-1)
    end
  end
end
