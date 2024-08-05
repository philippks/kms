require 'rails_helper'

describe Invoice do
  let(:invoice_params) { {} }
  let(:invoice) { build :invoice, :with_associations, invoice_params }

  it { is_expected.to validate_presence_of :employee }
  it { is_expected.to accept_nested_attributes_for :customer }

  describe '#activities_amount_manually' do
    before do
      create_list :invoice_activity, 2, hours_manually: 1, hourly_rate_manually: 150, invoice:
    end

    it 'returns calculated activities amount' do
      expect(invoice.activities_amount).to eq Money.from_amount 300
    end

    context 'manually set activities amount' do
      let(:invoice) do
        create :invoice, :with_associations, activities_amount_manually: 500
      end

      it 'returns manually set amount' do
        expect(invoice.activities_amount).to eq Money.from_amount 500
      end
    end
  end

  describe '#efforts_amount' do
    let(:invoice) { create :invoice, :with_associations }

    before do
      create_list(:invoice_activity, 2, hours_manually: 1, hourly_rate_manually: 150, invoice:)
      create :invoice_expense, amount_manually: 150, invoice:
    end

    it 'returns calculated efforts_amount' do
      expect(invoice.efforts_amount).to eq Money.from_amount 450
    end
  end

  describe '#vat_amount' do
    let(:invoice) do
      create :invoice, :with_associations, activities_amount_manually: activities_amount,
                                           vat_rate: 0.08
    end

    let(:activities_amount) { 500 }

    it 'returns correct vat amount' do
      expect(invoice.vat_amount).to eq Money.from_amount 40
    end

    context 'with floating amounts' do
      let(:activities_amount) { 123.60 }

      it 'rounds correctly' do
        expect(invoice.vat_amount).to eq Money.from_amount 9.90
      end
    end
  end

  describe '#total_amount' do
    subject { invoice.total_amount }

    let(:invoice) do
      create :invoice, :with_associations, activities_amount_manually: 200
    end

    it { is_expected.to eq Money.from_amount 203 }
  end

  describe '#open_amount' do
    let(:invoice) do
      create :invoice, :with_associations, activities_amount_manually: 200
    end

    context 'with payments' do
      let!(:payment) { create :payment, invoice:, amount: 100 }

      it 'returns remaining amount' do
        expect(invoice.reload.open_amount).to eq(invoice.total_amount - Money.from_amount(100))
      end

      it 'is possible to ignore payment' do
        expect(invoice.reload.open_amount(ignore: payment)).to eq invoice.total_amount
      end
    end
  end

  describe '#expenses_amount' do
    subject(:expenses_amount) { invoice.expenses_amount }

    let(:invoice) { create :invoice, :with_associations }

    context 'with expenses' do
      before do
        create :invoice_expense, invoice:, amount_manually: 300
      end

      it 'returns expenses amount' do
        expect(expenses_amount).to eq Money.from_amount 300
      end
    end
  end

  describe '#deliver' do
    let(:invoice) do
      create :invoice, :with_associations, activities_amount_manually: 100,
                                           vat_rate: 0.01,
                                           state: :open
    end

    before do
      FileUtils.rm(Dir.glob("#{Global.invoices.persisted_pdfs_directory}/*.pdf"))
    end

    it 'persists amount' do
      expect do
        invoice.deliver
      end.to change { invoice.persisted_total_amount }.from(nil).to Money.from_amount 101
    end

    it 'persists pdf' do
      expect do
        invoice.deliver
      end.to change { Invoices::PDF.new(invoice).persisted? }.from(false).to(true)
    end

    it 'set sent_at' do
      invoice.deliver

      expect(invoice.reload.sent_at).to be_within(5.seconds).of DateTime.current
    end
  end

  describe '#reopen' do
    let(:invoice) do
      create :invoice, :with_associations, persisted_total_amount: 200,
                                           state: :sent
    end

    before do
      FileUtils.touch Invoices::PDF.new(invoice).persisted_pdf_path
    end

    it 'clears persisted amount' do
      expect do
        invoice.reopen
      end.to change { invoice.persisted_total_amount }.from(Money.from_amount(200)).to nil
    end

    it 'removes persisted pdf' do
      expect do
        invoice.reopen
      end.to change { Invoices::PDF.new(invoice).persisted? }.from(true).to(false)
    end
  end
end
