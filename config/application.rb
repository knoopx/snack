require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module Snack
  class Application < Rails::Application
  end
end
