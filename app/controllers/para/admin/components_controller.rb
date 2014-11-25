require_dependency "para/application_controller"

module Para
  module Admin
    class ComponentsController < Para::Admin::BaseController
      include Para::Admin::BaseHelper

      load_and_authorize_resource :component_section, class: 'Para::ComponentSection'
      load_and_authorize_resource class: 'Para::Component::Base'

      # attr_reader :component

      # def show
      #   @component = Para::Component::Base.find(params[:id])

      #   component_name = @component.class.component_name.to_s

      #   controller_name = "#{ component_name.camelize }ComponentController"
      #   controller = Para::Admin.const_get(controller_name)

      #   action = controller.new.method(:show)

      #   instance_exec(&action)

      #   render "para/admin/#{ component_name }_component/show"
      # end

      def new
        @component = Para::Component::Base.new
      end

      def create
        type = params[:component].delete(:type)
        model = Para::Component.registered_components[type.to_sym]
        @component = model.new(component_params)
        @component.component_section = @component_section

        if @component.save
          flash_message(:success, @component)
          redirect_to component_path(@component)
        else
          flash_message(:error, @component)
          render 'new'
        end
      end

      private

      def component_params
        @component_params ||= params.require(:component).permit(:name)
      end
    end
  end
end
