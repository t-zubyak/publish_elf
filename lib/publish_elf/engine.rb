module PublishElf
  class Engine < ::Rails::Engine
    isolate_namespace PublishElf
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w{ publish_elf.css }
      Rails.application.config.assets.precompile += %w{ publish_elf.js }
    end
  end
end
