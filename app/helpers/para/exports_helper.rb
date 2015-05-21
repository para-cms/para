module Para
  module ExportsHelper
    def export_name_for(model, export)
      model_name = (
        export[:model] && export[:model].constantize.model_name.human
      ) || model.model_name.human

      t('para.export.name', name: model_name)
    end
  end
end
