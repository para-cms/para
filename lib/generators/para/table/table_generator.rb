module Para
  class TableGenerator < Para::Generators::NamedBase
    include Para::Admin::BaseHelper
    include Para::Generators::FieldHelpers

    source_root File.expand_path('../templates', __FILE__)

    desc 'Para resources table generator'

    def generate_table
      template(
        "_table.html.haml",
        "app/views/admin/#{ plural_namespaced_path }/_table.haml"
      )
    end
  end
end
