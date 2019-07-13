require 'rails_helper'

describe EntitiesFilter do
  let(:filter) { described_class.new parameters }

  let(:parameters) do
    {
      customer: 'Fritzli',
      employee: 'Hansli',
    }
  end

  describe '#initialize' do
    context 'with known parameters' do
      it 'defines getter to parameters' do
        expect(filter.customer).to eq 'Fritzli'
        expect(filter.employee).to eq 'Hansli'
      end
    end

    context 'with unknown parameters' do
      let(:parameters) do
        {
          huhu: 'Fritzli',
        }
      end

      it 'does not define getters for unknown keys' do
        expect(filter.respond_to?(:huhu)).to be_falsy
      end
    end

    context 'with string keys' do
      let(:parameters) do
        {
          'customer': 'Fritzli',
        }
      end

      it 'still works' do
        expect(filter.customer).to eq 'Fritzli'
      end
    end

    context 'with arrays' do
      let(:parameters) do
        {
          customer: %w[Fritzli Franz],
        }
      end

      it 'works' do
        expect(filter.customer).to eq %w[Fritzli Franz]
      end
    end
  end

  describe '#filter' do
    let(:entities) { double 'entities' }

    before do
      allow(entities).to receive(:for_customer).and_return entities
      allow(entities).to receive(:for_employee).and_return entities
    end

    it 'calls each filter method on entities' do
      expect(entities).to receive(:for_customer).with('Fritzli').and_return entities
      expect(entities).to receive(:for_employee).with('Hansli').and_return entities

      filter.filter(entities)
    end

    it 'returns entities' do
      expect(filter.filter(entities)).to eq entities
    end

    context 'without' do
      let(:parameters) { nil }

      it 'does nothing' do
        expect(entities).not_to receive(:for_customer)
        expect(entities).not_to receive(:for_employee)

        expect(filter.filter(entities)).to eq entities
      end
    end

    context 'with blank parametes' do
      let(:parameters) do
        {
          customer: [''],
          employee: '',
        }
      end

      it 'does not call filter methods' do
        expect(entities).not_to receive(:for_customer)
        expect(entities).not_to receive(:for_employee)

        filter.filter(entities)
      end
    end
  end
end
