require 'rails_helper'

describe Invoices::Activities::SuggestionsBuilder do
  let(:suggestion_builder) do
    described_class.new query:, invoice_activity_id: invoice_activity.id
  end
  let!(:invoice_activity) { create :invoice_activity, :default_associations, text: 'just something' }

  describe '.build' do
    subject(:suggestions) { suggestion_builder.build }

    let(:query) { '' }

    context 'with invoice activity' do
      context 'which has assigned activities' do
        before do
          create :activity, :default_associations, invoice_effort: invoice_activity,
                                                   text: 'gugusäli'

          create :activity, :default_associations, invoice_effort: invoice_activity,
                                                   text: 'da simmer'
        end

        it 'returns suggestions for assigned activities' do
          expect(suggestions[:assigned_to_invoice_activity]).to match_array ['gugusäli', 'da simmer']
        end
      end
    end

    context 'if customer has previous invoices' do
      let(:previous_invoice) { create :invoice, :default_associations, date: 1.year.ago }

      before do
        create :invoice_activity, invoice: previous_invoice, text: 'Other invoice text'
      end

      it 'returns activity texts of previous invoices' do
        expect(suggestions[:previous_invoice_activites]).to eq ['Other invoice text']
      end

      it 'orders these texts by the invoice date' do
        newer_invoice = create :invoice, :default_associations, date: 1.day.ago
        create :invoice_activity, invoice: newer_invoice, text: 'New invoice text'

        expect(suggestions[:previous_invoice_activites]).to eq(
          ['New invoice text', 'Other invoice text']
        )
      end

      it 'does not return duplicate entries' do
        create :invoice_activity, invoice: previous_invoice, text: 'Other invoice text'

        expect(suggestions[:previous_invoice_activites].size).to eq 1
      end

      it 'does not return empty entries' do
        create :invoice_activity, invoice: previous_invoice, text: ''

        expect(suggestions[:previous_invoice_activites].size).to eq 1
      end

      it 'does not return activities from other customers' do
        different_invoice = create :invoice, :with_associations
        create :invoice_activity, invoice: different_invoice

        expect(suggestions[:previous_invoice_activites].size).to eq 1
      end

      context 'with query' do
        let(:query) { 'search' }

        before do
          create :invoice_activity, invoice: previous_invoice, text: 'Search me'
        end

        it 'returns invoice activities by query' do
          expect(suggestions[:previous_invoice_activites]).to eq ['Search me']
        end
      end
    end
  end
end
