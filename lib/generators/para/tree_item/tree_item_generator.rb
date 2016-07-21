module Para
  class TreeItemGenerator < Para::Generators::NamedBase
    include Para::Admin::BaseHelper
    include Para::Generators::FieldHelpers

    source_root File.expand_path('../../../../../app/views/para/admin/resources', __FILE__)

    desc 'Para resource tree item generator'

    def generate_table
      template(
        '_tree_item.html.haml',
        "app/views/admin/#{ plural_namespaced_path }/_tree_item.haml"
      )
    end
  end
end
