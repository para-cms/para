module Para
  module Component
    class PageCategory < Para::Component::Base
      register :page_category, self

      has_many :pages, class_name: 'Para::Page', autosave: true,
                       inverse_of: :component, foreign_key: :component_id,
                       dependent: :destroy
    end
  end
end
