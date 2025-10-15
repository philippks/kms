class Settings < ApplicationRecord
  # comma separated list of vat_rates, e.g. 8.1,7.7,0.0
  validates :vat_rates, presence: true,
                        format: {
                          with: /\A\d+(\.\d+)?(,\s*\d+(\.\d+)?)*\z/,
                          message: 'Muss eine kommaseparierte Liste sein',
                        }

  def self.default_vat_rate
    get.vat_rates.split(',').first.to_f / 100
  end

  def self.vat_rates
    get.vat_rates.split(',').map(&:to_f).map { |vat_rate| vat_rate / 100 }
  end

  def self.get
    Settings.create!(vat_rates: '7.7,8.0,0.0') unless Settings.last

    Settings.last
  end
end
