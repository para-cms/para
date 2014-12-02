require_dependency "para/application_controller"

module Para
  module Admin
    class ComponentsController < Para::Admin::BaseController
      include Para::Admin::BaseHelper

      load_and_authorize_resource :component_section, class: 'Para::ComponentSection'
      load_and_authorize_resource class: 'Para::Component::Base', except: [:create]

      def new
        @component = Para::Component::Crud.new
      end

      def create
        type = params[:component].delete(:type)
        model = Para::Component.registered_components[type.to_sym]
        @component = model.new(component_params_for(model))
        @component.component_section = @component_section

        authorize! :create, @component

        if @component.save
          flash_message(:success, @component)
          redirect_to component_path(@component)
        else
          flash_message(:error, @component)
          render 'new'
        end
      end

      private

      def component_params_for(model)
        permitted_attributes = [:name]
        permitted_attributes += model.configurable_attributes.keys

        params.require(:component).permit(permitted_attributes)
      end
    end
  end
end
