require 'rails_helper'

RSpec.describe CustomerGroupsController do
  let(:customer_group) { create :customer_group }

  before do
    sign_in create :employee
  end

  describe 'GET #index' do
    it 'lists all customer_groups' do
      customer_group = create :customer_group
      get :index
      expect(assigns(:customer_groups)).to eq [customer_group]
    end
  end

  describe 'GET #new' do
    it 'assigns a new customer_group' do
      get :new
      expect(assigns(:customer_group)).to be_a_new CustomerGroup
    end
  end

  describe 'POST #create' do
    it 'creates a new customer_group' do
      expect do
        post :create, params: { customer_group: { name: 'BNI', not_chargeable: false } }
      end.to change(CustomerGroup, :count).by(1)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested customer_group' do
      get :edit, params: { id: customer_group.to_param }
      expect(assigns(:customer_group)).to eq customer_group
    end
  end

  describe 'PATCH #update' do
    it 'updates the customer_group' do
      expect do
        patch :update, params: { id: customer_group.to_param, customer_group: { name: 'Administration', not_chargeable: true } }
      end.to change { customer_group.reload.name }.to('Administration')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys a customer_group' do
      customer_group = create :customer_group
      expect do
        delete :destroy, params: { id: customer_group.to_param }
      end.to change(CustomerGroup, :count).by(-1)
    end
  end
end
