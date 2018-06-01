require 'rails_helper'

describe Invoices::Expenses::Generate do
  let(:invoice) do
    create :invoice, :default_associations, id: 1337
  end

  let(:default_expense_text) { I18n.t('invoice.default_expense_text') }

  describe '#generate!' do
    let(:generate_default_expense) { false }

    subject(:generate!) do
      described_class.new(invoice, generate_default_expense: generate_default_expense).generate!
    end

    context 'with generate_default_expense set to true' do
      let(:generate_default_expense) { true }

      it 'creates a default expense' do
        generate!

        expect(Invoices::Expense.pluck(:text)).to match_array [default_expense_text]
      end
    end

    context 'with expenses' do
      let!(:some_expense) do
        create :expense, :default_associations, date: (1.month.ago.beginning_of_month + 3.days),
                                                text: first_text
      end

      let!(:another_expense) do
        create :expense, :default_associations, date: (1.month.ago.beginning_of_month + 4.days),
                                                text: second_text
      end

      context 'with different expense texts' do
        let(:first_text) { 'Some work' }
        let(:second_text) { 'Some other work' }

        it 'generates an invoice expense for each expense' do
          expect { generate! }.to change { Invoices::Expense.count }.from(0).to(2)
        end

        it 'assigns expenses to generated expenses' do
          generate!

          expect(Invoices::Expense.all.map(&:efforts)).to match_array(
            [
              [some_expense],
              [another_expense],
            ]
          )
        end

        it 'sets correct text' do
          generate!

          expect(Invoices::Expense.pluck(:text)).to match_array [first_text, second_text]
        end

        context 'with default expense' do
          let(:generate_default_expense) { true }

          it 'generates default expense as last expense' do
            generate!

            expect(Invoices::Expense.last.text).to eq default_expense_text
          end
        end
      end

      context 'with overlapping expense texts' do
        overlapping_texts = [['Some work', 'Some work'],
                             ['Some work', 'somework']]

        overlapping_texts.each do |first_text, second_text|
          let(:first_text) { first_text }
          let(:second_text) { second_text }

          it 'generates only one invoice expense' do
            expect { generate! }.to change { Invoices::Expense.count }.from(0).to(1)
          end

          it 'assigns both expenses to generated expense' do
            generate!

            expect(Invoices::Expense.first.efforts).to match_array [some_expense, another_expense]
          end
        end
      end
    end
  end
end
