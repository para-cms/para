Para.components.draw do
  # Create a components section in the menu with a :menu identifier
  # You can translate the section title at: components.section.menu
  #
  section :shop do
   # Creating crud components can be done the following way
   #
   component :components, :crud, model_type: 'Para::Component::Base'
  end
end
