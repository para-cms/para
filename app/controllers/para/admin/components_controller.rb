require_dependency "para/application_controller"

module Para
  module Admin
    class ComponentsController < Para::Admin::BaseController
      include Para::Admin::BaseHelper

      attr_reader :component

      def show
        @component = Para::Component::Base.find(params[:id])

        component_name = @component.class.component_name.to_s

        controller_name = "#{ component_name.camelize }ComponentController"
        controller = Para::Admin.const_get(controller_name)

        action = controller.new.method(:show)

        instance_exec(&action)

        render "para/admin/#{ component_name }_component/show"
      end

      def create
        type = params[:component].delete(:type)
        model = Para::Component.registered_components[type.to_sym]
        @component = model.new(component_params)

        if @component.save
          flash_message(:success, @component)
          redirect_to component_path(@component)
        else
          flash_message(:error, @component)
          redirect_to :back
        end
      end

      private

      def component_params
        @component_params ||= params.require(:component).permit(:name, :component_section_id)
      end
    end
  end
end
