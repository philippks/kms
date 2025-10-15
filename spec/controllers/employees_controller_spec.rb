require 'rails_helper'

RSpec.describe EmployeesController do
  let(:employee) { create :employee, name: 'Der Dude' }

  before do
    sign_in employee
  end

  describe 'GET #index' do
    let!(:deactivated_employee) { create :employee, deactivated: true }

    it 'returns active employees' do
      get :index

      expect(assigns(:employees)).to eq [employee]
    end

    context 'with param deactivated' do
      it 'returns deactivated too' do
        get :index, params: { deactivated: true }

        expect(assigns(:employees)).to eq [employee, deactivated_employee]
      end
    end

    context 'with param query' do
      before do
        create :employee
      end

      it 'searches for employees' do
        get :index, params: { query: 'Dude' }

        expect(assigns(:employees)).to eq [employee]
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new employee' do
      get :new
      expect(assigns(:employee)).to be_a_new Employee
    end
  end

  describe 'POST #create' do
    let(:parameters) do
      {
        name: 'Hans Meier',
        email: 'hans@meier.ch',
        initials: 'HM',
        hourly_rate: 150,
        password: 'my secure password',
        password_confirmation: 'my secure password',
      }
    end

    it 'creates a new employee' do
      expect do
        post :create, params: { employee: parameters }
      end.to change(Employee, :count).by(1)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested employee' do
      get :edit, params: { id: employee.to_param }
      expect(assigns(:employee)).to eq employee
    end
  end

  describe 'PATCH #update' do
    it 'updates the employee' do
      expect do
        patch :update, params: { id: employee.to_param, employee: { name: 'Max Meier' } }
      end.to change { employee.reload.name }.to('Max Meier')
    end

    describe 'change password' do
      it 'works' do
        expect do
          patch :update, params: {
            id: employee.to_param, employee: {
              password: 'another secure password',
              password_confirmation: 'another secure password',
            },
          }
        end.to change { employee.reload.valid_password? 'another secure password' }.from(false).to(true)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys a employee' do
      employee.touch
      expect do
        delete :destroy, params: { id: employee.to_param }
      end.to change(Employee, :count).by(-1)
    end
  end
end
