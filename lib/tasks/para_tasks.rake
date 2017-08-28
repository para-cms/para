namespace :para do
  namespace :components do
    desc <<-DESC
      Remove all components that are no longer referenced in the components.rb
      configuration file
    DESC

    task clean: :environment do
      require 'para/components_cleaner'
      Para::ComponentsCleaner.run
    end
  end
end
