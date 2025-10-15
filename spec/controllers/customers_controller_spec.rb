require 'rails_helper'

RSpec.describe CustomersController do
  let(:customer) { create :customer }
  let(:customer_group) { create :customer_group }

  before do
    sign_in create :employee
  end

  describe 'GET #index' do
    let!(:deactivated_customer) { create :customer, deactivated: true }

    before do
      customer.touch
    end

    it 'returns all customers' do
      get :index

      expect(assigns(:customers)).to contain_exactly(customer, deactivated_customer)
    end

    context 'format json and param active' do
      it 'returns only active customers' do
        get :index, format: :json, params: { active: true }

        expect(assigns(:customers)).to eq [customer]
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new customer' do
      get :new
      expect(assigns(:customer)).to be_a_new Customer
    end
  end

  describe 'POST #create' do
    it 'creates a new customer' do
      expect do
        post :create, params: { customer: { name: 'Hans Meier', address: 'Irgendwo' } }
      end.to change(Customer, :count).by(1)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested customer' do
      get :edit, params: { id: customer.to_param }
      expect(assigns(:customer)).to eq customer
    end
  end

  describe 'PATCH #update' do
    it 'updates the customer' do
      expect do
        patch :update, params: { id: customer.to_param, customer: { name: 'Max Meier' } }
      end.to change { customer.reload.name }.to('Max Meier')
    end

    it 'updates the customer group' do
      expect do
        patch :update, params: { id: customer.to_param, customer: { customer_group_id: customer_group.to_param } }
      end.to change { customer.reload.customer_group }.to(customer_group)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys a customer' do
      customer = create :customer
      expect do
        delete :destroy, params: { id: customer.to_param }
      end.to change(Customer, :count).by(-1)
    end
  end
end
