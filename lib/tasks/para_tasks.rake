namespace :para do
  namespace :components do
    desc <<-DESC
      Remove all components that are no longer referenced in the components.rb
      configuration file
    DESC

    task :clean do
      Para::Component::Base.find_each do |component|
        unless Para.components.component_for(component.identifier)
          component.destroy
        end
      end
    end
  end
end
