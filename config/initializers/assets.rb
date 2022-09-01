# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( select2/select2.png )
Rails.application.config.assets.precompile += %w( editable/loading.gif )
Rails.application.config.assets.precompile += %w( editable/clear.png )
Rails.application.config.assets.precompile += %w( favicon.ico apple-touch-icon*.png logo-white.svg )
Rails.application.config.assets.precompile += %w( invoices/pdfs.css )
Rails.application.config.assets.precompile += %w( invoices/qr_bill.css )
