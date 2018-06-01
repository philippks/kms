require 'spec_helper'

shared_examples_for 'entities_filterable' do
  let(:model) { described_class }

  describe 'initialize_filter' do
    before do
      expect(controller).to receive(:filter_params).and_return employee: 1337
    end

    it 'stored filter in session' do
      get :index

      expect(session["#{controller.controller_name}_stored_filter"]).to eq employee: 1337
    end
  end

  describe 'filter_params' do
    subject(:filter_params) { controller.filter_params }

    it 'returns default filers' do
      get :index

      expect(filter_params).to eq controller.send(:default_filter) || {}
    end

    context 'with stored filters' do
      before do
        session["#{controller.controller_name}_stored_filter"] = { employee: 1337 }
      end

      context 'from today' do
        before do
          session[:stored_date] = Date.current.iso8601
        end

        it 'returns stored filters' do
          get :index

          expect(filter_params).to eq employee: 1337
        end
      end

      context 'from another day' do
        before do
          session[:stored_date] = 1.day.ago.iso8601
        end

        it 'returns default filters' do
          get :index

          expect(filter_params).to eq controller.send(:default_filter) || {}
        end
      end
    end

    context 'with provied filters' do
      it 'returns provided filters' do
        get :index, params: { filter: { employee: 1337 } }

        expect(filter_params).to eq 'employee' => '1337'
      end
    end
  end
end
