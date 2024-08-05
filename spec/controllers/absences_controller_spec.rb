require 'rails_helper'

RSpec.describe AbsencesController do
  let(:employee) { create :employee }
  let(:absence) { create :absence, employee: }

  before do
    sign_in employee
  end

  it_behaves_like 'entities_filterable'

  describe 'GET #index' do
    it 'lists all absences' do
      get :index
      expect(assigns(:absences)).to eq [absence]
    end
  end

  describe 'GET #new' do
    it 'assigns a new absence' do
      get :new
      expect(assigns(:absence)).to be_a_new Absence
    end
  end

  describe 'POST #create' do
    let(:attributes) do
      {
        employee_id: employee.id,
        from_date: '2015-02-20',
        to_date: '2015-02-20',
        hours: 1.5,
        reason: :doctor,
        text: 'Bein gebrochen',
      }
    end

    it 'creates a new absence' do
      expect do
        post :create, params: { absence: attributes }
      end.to change(Absence, :count).by(1)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested absence' do
      get :edit, params: { id: absence.to_param }
      expect(assigns(:absence)).to eq absence
    end
  end

  describe 'PATCH #update' do
    it 'updates the absence' do
      expect do
        patch :update, params: { id: absence.to_param, absence: { text: 'Bin krank' } }
      end.to change { absence.reload.text }.to('Bin krank')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys a absence' do
      absence.touch
      expect do
        delete :destroy, params: { id: absence.to_param }
      end.to change(Absence, :count).by(-1)
    end
  end
end
