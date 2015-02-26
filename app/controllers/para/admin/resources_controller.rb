require_dependency "para/application_controller"

module Para
  module Admin
    class ResourcesController < Para::Admin::BaseController
      include Para::ModelHelper

      class_attribute :resource_name, :resource_class

      load_and_authorize_component

      helper_method :resource

      def new
        render 'para/admin/resources/new'
      end

      def create
        # Assign component the resource belongs to it
        resource.component = @component if resource.respond_to?(:component=)

        if resource.save
          flash_message(:success, resource)
          redirect_to after_form_submit_path
        else
          flash_message(:error, resource)
          render 'new'
        end
      end

      def edit
        render 'para/admin/resources/edit'
      end

      def update
        if resource.update_attributes(resource_params)
          flash_message(:success, resource)
          redirect_to after_form_submit_path
        else
          flash_message(:error, resource)
          render 'edit'
        end
      end

      def destroy
        resource.destroy
        flash_message(:success, resource)
        redirect_to @component.path
      end

      def order
        resources_params = params[:resources].values

        ids = resources_params.map { |resource| resource[:id] }

        resources = resource_model.where(id: ids)
        resources_hash = resources.each_with_object({}) do |resource, hash|
          hash[resource.id.to_s] = resource
        end

        ActiveRecord::Base.transaction do
          resources_params.each do |resource_params|
            resource = resources_hash[resource_params[:id]]
            resource.position = resource_params[:position].to_i
            resource.save(validate: false)
          end
        end

        head 200
      end

      def tree
        resources_params = params[:resources].values

        ids = resources_params.map { |resource| resource[:id] }
        resources = resource_model.where(id: ids)
        resources_hash = resources.each_with_object({}) do |resource, hash|
          hash[resource.id.to_s] = resource
        end
        ActiveRecord::Base.transaction do
          resources_params.each do |data|
            resources_hash[data[:id]].update position: data[:position], parent_id: data[:parent_id]
          end
        end
        head 200
      end

      private

      def after_form_submit_path
        if params[:_save_and_edit]
          { action: 'edit', id: resource.to_param }
        elsif params[:_save_and_add_another]
          { action: 'new' }
        else
          params.delete(:return_to).presence || @component.path
        end
      end

      def resource_model
        self.class.resource_model
      end

      def resource
        @resource ||= begin
          self.class.ensure_resource_name_defined!
          instance_variable_get(:"@#{ self.class.resource_name }")
        end
      end

      def resource_params
        @resource_params ||= parse_resource_params(
          params.require(:resource).permit!
        )
      end

      def parse_resource_params(hash)
        model_field_mappings(self.class.resource_model).fields.each do |field|
          field.parse_input(hash) if hash.key?(field.name)
        end

        hash
      end

      def self.resource(name, options = {})
        default_options = {
          class: name.to_s.camelize,
          through: :component,
          parent: false
        }

        default_options.each do |key, value|
          options[key] = value unless options.key?(key)
        end

        self.resource_name = name
        self.resource_class = options[:class]

        load_and_authorize_resource(name, options)
      end

      def self.resource_model
        @resource_model ||= begin
          ensure_resource_name_defined!
          Para.const_get(resource_class)
        end
      end

      def self.ensure_resource_name_defined!
        unless resource_name.presence
          raise "Resource not defined in your controller. " \
                "You can define the resource of your controller with the " \
                "`resource :resource_name` macro when subclassing " \
                "Para::Admin::ResourcesController"
        end
      end
    end
  end
end
