require_dependency "para/application_controller"

module Para
  module Admin
    class ComponentsController < Para::Admin::BaseController
      include Para::Admin::BaseHelper

      load_and_authorize_resource :component_section, class: 'Para::ComponentSection'
      load_and_authorize_resource class: 'Para::Component::Base', except: [:create]

      def new
        model = extract_model_from(params)
        @component = model.new
      end

      def create
        model = extract_model_from(params[:component])

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

      def extract_model_from(hash)
        type = hash.delete(:type)

        if (model = Para::Component.registered_components[type.to_sym])
          model
        elsif Para::Component.registered_component?(type)
          type.constantize
        else
          raise Para::ComponentNotFound.new(type)
        end
      end
    end
  end
end
