require 'rails_helper'

describe Activities::SuggestionsBuilder do
  describe 'build' do
    subject(:suggestions) { described_class.new(query: query, customer_id: customer.id).build }

    let(:employee) { create :employee }
    let(:other_employee) { create :employee, name: 'Other Employee' }
    let(:customer) { create :customer }
    let(:other_customer) { create :customer, name: 'Another Customer' }
    let(:query) { '' }

    context 'without customer' do
      subject(:suggestions) { described_class.new(query: '', customer_id: nil).build }

      before do
        create :activity, employee: employee, customer: other_customer,
                          text: 'Activity for some Customer'
      end

      it 'returns no suggestions' do
        expect(suggestions[:for_customer]).to eq([])
      end
    end

    context 'with customer' do
      before do
        create :activity, employee: employee, customer: customer,
                          text: 'Some Activity from me', date: 5.days.ago
        create :activity, employee: other_employee, customer: customer,
                          text: 'Some Activity from someone else',
                          date: 1.days.ago

        create :activity, employee: employee, customer: other_customer,
                          text: 'Activity for other Customer', date: 9.days.ago
      end

      it 'returns suggestions for customer ordered by date' do
        expect(suggestions[:for_customer]).to eq([
                                               'Some Activity from someone else',
                                               'Some Activity from me'
                                             ])
      end
    end

    context 'with a lot of activities' do
      before do
        11.times do |i|
          create :activity, employee: employee, customer: customer, text: "#{i} of alot"
        end
      end

      it 'returns only 10 suggestions' do
        expect(suggestions[:for_customer].size).to eq 10
      end
    end

    context 'with duplicate texts' do
      before do
        2.times do
          create :activity, employee: employee, customer: customer, text: 'Duplicate Text'
        end
      end

      it 'returns only uniq suggestions' do
        expect(suggestions[:for_customer].count('Duplicate Text')).to eq 1
      end
    end

    context 'with an activity category' do
      let(:category) { create :activity_category }

      subject(:suggestions) do
        described_class.new(query: '',
                            customer_id: customer.id,
                            activity_category_id: category.id).build
      end

      before do
        create :text_template, activity_category: category, text: 'Some template'
      end

      it 'returns suggestions for activity category' do
        expect(suggestions[:for_activity_category]).to match_array ['Some template']
      end

      it 'returns suggestion keys in the correct order' do
        expect(suggestions.keys).to eq([
                                     :for_activity_category,
                                     :for_customer
                                   ])
      end
    end

    context 'with query' do
      let(:query) { 'second' }

      before do
        create :activity, employee: employee, customer: customer, text: 'First'
        create :activity, employee: employee, customer: customer, text: 'Second'
      end

      it 'returns suggestions by query' do
        expect(suggestions[:for_customer]).to eq ['Second']
      end
    end
  end
end
