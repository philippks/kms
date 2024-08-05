require 'rails_helper'

RSpec.describe ExpensesController do
  let(:employee) { create :employee, name: 'Der Dude' }
  let(:expense) { create :expense, employee: }

  before do
    sign_in employee
  end

  it_behaves_like 'entities_filterable'

  describe 'GET #index' do
    it 'lists all expense' do
      expense.touch
      get :index
      expect(assigns(:expenses)).to eq [expense]
    end
  end

  describe 'GET #new' do
    it 'assigns a new expense' do
      get :new
      expect(assigns(:expense)).to be_a_new Expense
    end
  end

  describe 'POST #create' do
    let(:attributes) do
      {
        employee_id: employee.id,
        customer_id: (create :customer).id,
        date: '2015-02-20',
        amount: 250,
        text: 'Spesen',
      }
    end

    it 'creates a new expense' do
      expect do
        post :create, params: { expense: attributes }
      end.to change(Expense, :count).by(1)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested expense' do
      get :edit, params: { id: expense.to_param }
      expect(assigns(:expense)).to eq expense
    end
  end

  describe 'PATCH #update' do
    it 'updates the expense' do
      expect do
        patch :update, params: { id: expense.to_param, expense: { text: 'Spesen der Anreise' } }
      end.to change { expense.reload.text }.to('Spesen der Anreise')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys a expense' do
      expense.touch
      expect do
        delete :destroy, params: { id: expense.to_param }
      end.to change(Expense, :count).by(-1)
    end
  end
end
