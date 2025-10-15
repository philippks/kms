require 'rails_helper'

RSpec.describe ActivitiesController do
  let(:employee) { create :employee }
  let(:customer) { create :customer, name: 'Max Hässig' }
  let(:activity) { create :activity, date: Date.current, employee:, customer: }

  before do
    sign_in employee
  end

  it_behaves_like 'entities_filterable'

  describe 'GET #index' do
    let(:other_employee) { create :employee, name: 'Der Andere' }
    let!(:other_activity) { create :activity, employee: other_employee, customer:, date: Date.current }

    it 'assigns activities in descending order' do
      old_activity = create :activity, employee:, customer:, date: 99.days.ago

      get :index, params: { filter: { from: 100.days.ago, employee: } }
      expect(assigns(:activities)).to eq [activity, old_activity]
    end

    context 'without filter' do
      it 'lists only current employees activities' do
        get :index
        expect(assigns(:activities)).to eq [activity]
      end

      it 'lists only todays activities' do
        create(:activity, date: 1.day.ago, employee:, customer:)

        get :index

        expect(assigns(:activities)).to eq [activity]
      end
    end

    context 'with employee filter' do
      it 'lists others employees activities' do
        get :index, params: { filter: { employee: other_employee.id } }
        expect(assigns(:activities)).to eq [other_activity]
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new activity' do
      get :new, params: { customer: customer.to_param }
      expect(assigns(:activity)).to be_a_new Activity
    end

    it 'assigns default values' do
      get :new, params: { customer: customer.to_param }

      aggregate_failures do
        expect(assigns(:activity).employee).to eq employee
        expect(assigns(:activity).customer).to eq customer
        expect(assigns(:activity).date).to eq Time.zone.today
        expect(assigns(:activity).hourly_rate).to eq employee.hourly_rate
      end
    end

    context 'hourly rate for customer exists' do
      before do
        create :hourly_rate, customer:, employee:, hourly_rate: 999
      end

      it 'assigns existing hourly rate as hourly rate' do
        get :new, params: { customer: customer.to_param }

        expect(assigns(:activity).hourly_rate).to eq Money.from_amount(999)
      end
    end

    context 'if customer_group is not_chargeable' do
      before do
        create :customer_group, not_chargeable: true, customer: [customer]
      end

      it 'assigns 0 as hourly_rate' do
        get :new, params: { customer: customer.to_param }

        expect(assigns(:activity).hourly_rate).to eq 0
      end
    end
  end

  describe 'POST #create' do
    let(:attributes) do
      {
        text: 'Steuererklärung ausgefüllt',
        employee_id: employee.id,
        customer_id: customer.id,
        hours: '2.5',
        hourly_rate: 150,
        date: '2015-02-18',
      }
    end

    it 'creates a new activity' do
      expect do
        post :create, params: { activity: attributes }
      end.to change(Activity, :count).by(1)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested activity' do
      get :edit, params: { id: activity.to_param }
      expect(assigns(:activity)).to eq activity
    end
  end

  describe 'PATCH #update' do
    it 'updates the activity' do
      expect do
        patch :update, params: { id: activity.to_param, activity: { text: 'Chillen' } }
      end.to change { activity.reload.text }.to('Chillen')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys a activity' do
      activity = create(:activity, employee:, customer:)
      expect do
        delete :destroy, params: { id: activity.to_param }
      end.to change(Activity, :count).by(-1)
    end
  end
end
