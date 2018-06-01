require 'rails_helper'

RSpec.describe TextTemplatesController do
  let(:text_template) { create :text_template, activity_category: activity_category }
  let(:activity_category) { create :activity_category }

  before do
    sign_in create :employee
  end

  describe 'GET #index' do
    it 'lists all text templates' do
      get :index, params: { activity_category_id: activity_category.id }
      expect(assigns(:text_templates)).to eq [text_template]
    end
  end

  describe 'GET #new' do
    it 'assigns a new text_template' do
      get :new, params: { activity_category_id: activity_category.id }
      expect(assigns(:text_template)).to be_a_new TextTemplate
    end
  end

  describe 'POST #create' do
    it 'creates a new text_template' do
      expect do
        post :create, params: {
          activity_category_id: activity_category.id,
          text_template: { text: 'Ein Text der oft vorkommt' }
        }
      end.to change(TextTemplate, :count).by(1)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested text_template' do
      get :edit, params: { id: text_template.to_param, activity_category_id: text_template.activity_category.id }
      expect(assigns(:text_template)).to eq text_template
    end
  end

  describe 'PATCH #update' do
    let(:text) { 'Ein anderer Text der oft vorkommt' }

    it 'updates the text_template' do
      expect do
        patch :update, params: {
          activity_category_id: text_template.activity_category.id,
          id: text_template.to_param, text_template: { text: text }
        }
      end.to change { text_template.reload.text }.to(text)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys a text_template' do
      text_template.touch
      expect do
        delete :destroy, params: { activity_category_id: activity_category.id, id: text_template.to_param }
      end.to change(TextTemplate, :count).by(-1)
    end
  end
end
