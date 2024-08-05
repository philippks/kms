require 'rails_helper'

describe Invoices::Efforts::Group do
  let(:invoice) do
    create :invoice, :default_associations
  end

  describe '#group_efforts!' do
    describe 'for invoice activities' do
      subject do
        described_class.new(invoice, activity_ids).group_efforts!
      end

      let!(:first_activity) { create :invoice_activity, invoice:, text: 'First' }
      let!(:second_activity) { create :invoice_activity, invoice:, text: 'Second' }

      let(:activity_ids) { [first_activity.id, second_activity.id] }

      it 'groups given invoice activities' do
        expect { subject }.to change { Invoices::Activity.count }.from(2).to 1
      end

      it 'sets first text to new invoice activity' do
        subject

        expect(Invoices::Activity.first.text).to eq 'First'
      end

      context 'with assigned activites' do
        before do
          create :activity, :default_associations, invoice_effort_id: first_activity.id
          create :activity, :default_associations, invoice_effort_id: first_activity.id
          create :activity, :default_associations, invoice_effort_id: second_activity.id
        end

        it 'assigns activities to new invoice activity' do
          subject

          expect(Invoices::Activity.first.efforts.count).to eq 3
        end
      end

      context 'with no invoice activities' do
        subject do
          described_class.new(invoice, []).group_efforts!
        end

        it 'does nothing' do
          expect { subject }.not_to(change { Invoices::Activity.count })
        end
      end

      context 'with confidential activities' do
        let!(:first_activity) { create :invoice_activity, invoice:, confidential: true }
        let!(:second_activity) { create :invoice_activity, invoice:, confidential: true }

        it 'sets created activity to confidential' do
          subject

          expect(Invoices::Activity.last.confidential).to be true
        end
      end
    end

    describe 'for invoice expenses' do
      subject do
        described_class.new(invoice, expenses_ids).group_efforts!
      end

      let!(:first_expense) { create :invoice_expense, invoice:, text: 'First' }
      let!(:second_expense) { create :invoice_expense, invoice:, text: 'Second' }

      let(:expenses_ids) { [first_expense.id, second_expense.id] }

      it 'groups given invoice expenses' do
        expect { subject }.to change { Invoices::Expense.count }.from(2).to 1
      end

      it 'sets first text to new invoice expense' do
        subject

        expect(Invoices::Expense.first.text).to eq 'First'
      end

      context 'with assigned expenses' do
        before do
          create :expense, :default_associations, invoice_effort_id: first_expense.id
          create :expense, :default_associations, invoice_effort_id: first_expense.id
          create :expense, :default_associations, invoice_effort_id: second_expense.id
        end

        it 'assigns activities to new invoice activity' do
          subject

          expect(Invoices::Expense.first.efforts.count).to eq 3
        end
      end
    end
  end
end
