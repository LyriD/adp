# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to override the default site name.
  # config.site_name = "Spree Demo Site"
  config.default_country_id = 168

end

Spree.user_class = "Spree::User"

Spree::Config.set(:allow_ssl_in_production => false)
Spree::Auth::Config[:registration_step] = false
Spree::Config[:address_requires_state] = false
Spree::Config[:alternative_billing_phone] = false

Spree::Config.set(:products_per_page => 9)

Spree::AppConfiguration.class_eval do
  preference :phone, :string
  preference :remote_ip, :string
  preference :email, :string
end
