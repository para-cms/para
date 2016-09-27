namespace :para do
  namespace :upgrade do
    desc <<-DESC
      Update database from SingletonResource to Form component without losing data
    DESC

    task singleton_to_form: :environment do
      class Para::Component::SingletonResource < Para::Component::Base
      end

      Para::Component::Base.where(type: 'Para::Component::SingletonResource').pluck(:identifier, :id).each do |identifier, id|
        Para::ComponentResource.where(component_id: id).update_all(
          component_id: Para::Component::Form.find_by_identifier(identifier: identifier).id
        )

        Para::Component::Base.where(id: id).destroy_all
      end
    end
  end

  namespace :components do
    desc <<-DESC
      Remove all components that are no longer referenced in the components.rb
      configuration file
    DESC

    task clean: :environment do
      Para::Component::Base.find_each do |component|
        unless Para.components.component_for(component.identifier)
          component.destroy
        end
      end

      Para::ComponentSection.find_each do |section|
        unless Para.components.section_for(section.identifier)
          section.destroy
        end
      end
    end
  end
end
