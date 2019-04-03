module Invoices
  class Title
    attr_accessor :invoice

    def initialize(invoice)
      @invoice = invoice
    end

    def to_s
      if no_date?
        I18n.t 'invoices.pdfs.new.sub_title.no_date',
               date: I18n.l(invoice.date, format: '%B %Y')
      elsif one_date?
        I18n.t 'invoices.pdfs.new.sub_title.one_date',
               date: I18n.l(oldest_activity_date, format: :long)
      elsif multiple_years?
        I18n.t 'invoices.pdfs.new.sub_title.multiple_dates',
               first_date: I18n.l(oldest_activity_date, format: :long),
               second_date: I18n.l(@invoice.date, format: :long)
      elsif multiple_months?
        I18n.t 'invoices.pdfs.new.sub_title.multiple_dates',
               first_date: I18n.l(oldest_activity_date, format: '%e. %B'),
               second_date: I18n.l(@invoice.date, format: :long)
      else
        I18n.t 'invoices.pdfs.new.sub_title.multiple_dates',
               first_date: I18n.l(oldest_activity_date, format: '%e.'),
               second_date: I18n.l(@invoice.date, format: :long)
      end
    end

    private

    def no_date?
      sorted_activity_dates.empty?
    end

    def one_date?
      (sorted_activity_dates + [@invoice.date]).uniq.count == 1
    end

    def multiple_years?
      oldest_activity_date.year != @invoice.date.year
    end

    def multiple_months?
      oldest_activity_date.month != @invoice.date.month
    end

    def oldest_activity_date
      sorted_activity_dates.first
    end

    def sorted_activity_dates
      @sorted_activity_dates ||= invoice.activities.includes(:efforts).map do |activity|
        activity.efforts.map(&:date)
      end.flatten.sort
    end
  end
end
