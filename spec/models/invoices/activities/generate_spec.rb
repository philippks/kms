require 'rails_helper'

describe Invoices::Activities::Generate do
  let(:invoice) do
    create :invoice, :default_associations, id: 1337
  end

  describe '#call' do
    let!(:some_activity) do
      create :activity, :default_associations, date: (1.month.ago.beginning_of_month + 3.days),
                                               text: first_text
    end

    let!(:another_activity) do
      create :activity, :default_associations, date: (1.month.ago.beginning_of_month + 4.days),
                                               text: second_text
    end

    let(:first_text) { 'something' }
    let(:second_text) { 'something else' }

    subject do
      described_class.new(invoice).generate!
    end

    context 'without any activities' do
      let(:customer_without_activities) { create :customer }
      let(:employee) { create :employee }
      let(:invoice) { create :invoice, customer: customer_without_activities, employee: employee }

      it 'works' do
        subject

        expect(invoice.reload.activities).to be_empty
      end
    end

    context 'with different activity texts' do
      let(:first_text) { 'Some work' }
      let(:second_text) { 'Some other work' }

      it 'generates an invoice activity for each activity' do
        expect { subject }.to change { Invoices::Activity.count }.from(0).to(2)
      end

      it 'assigns activities to generated activities' do
        subject

        expect(Invoices::Activity.all.map(&:efforts)).to eq [[some_activity], [another_activity]]
      end

      it 'sets correct text' do
        subject

        expect(Invoices::Activity.pluck(:text)).to match_array [first_text, second_text]
      end
    end

    context 'with overlapping activity texts' do
      overlapping_texts = [['Some work', 'Some work'],
                           ['Some work', 'somework']]

      overlapping_texts.each do |first_text, second_text|
        let(:first_text) { first_text }
        let(:second_text) { second_text }

        it 'generates only one invoice activity' do
          expect { subject }.to change { Invoices::Activity.count }.from(0).to(1)
        end

        it 'assigns both activities to generatea activity' do
          subject

          expect(Invoices::Activity.first.efforts).to match_array [some_activity, another_activity]
        end
      end
    end
  end
end
