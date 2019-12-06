MoneyRails.configure do |config|
  Money.locale_backend = :i18n

  config.default_currency = :chf

  config.include_validations = false

  config.rounding_mode = BigDecimal::ROUND_HALF_UP

  # Default ActiveRecord migration configuration values for columns:
  config.amount_column = {
    prefix: '',           # column name prefix
    postfix: '_cents',    # column name  postfix
    column_name: nil,     # full column name (overrides prefix, postfix and accessor name)
    type: :integer,       # column type
    present: true,        # column will be created
    null: false,          # other options will be treated as column options
    default: 0
  }

  config.currency_column = {
    prefix: '',
    postfix: '_currency',
    column_name: nil,
    type: :string,
    present: true,
    null: false,
    default: 'CHF'
  }

  config.register_currency = {
    priority: 1,
    iso_code: 'CHF',
    name: 'Swiss Francs',
    symbol: 'CHF ',
    symbol_first: true,
    subunit: 'Rappen',
    subunit_to_unit: 100,
    thousands_separator: "'",
    decimal_mark: '.',
    smallest_denomination: 5,
  }

  config.no_cents_if_whole = false
end
