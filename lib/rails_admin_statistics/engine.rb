module RailsAdminStatistics
  class Engine < ::Rails::Engine
    initializer 'RailsAdminStatistics precompile hook', group: :all do |app|
      app.config.assets.precompile += %w(
        jquery.flot.js
        jquery.flot.resize.js
        jquery.flot.time.js
        tools.js
        rails_admin_statistics.js
        rails_admin_statistics.css
      )
    end
  end
end
