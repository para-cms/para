class <%= exporter_class_name %> < Para::Exporter::Csv
  def name
    '<%= file_name %>'
  end

  protected

  # Defining the fields that you want to export will export all those fields
  # directly to the CSV file
  #
  def fields
    [:id]
  end

  # If you need special behavior in the row generation (rendering associated
  # models or other specific logic), you can return an array here that will
  # be written to the CSV
  #
  # For safe CSV writing, use the #encode method on every string in the
  # returned array.
  #
  # Example :
  #
  #   fields = [...]
  #   fields.map!(&:encode)
  #
  # def row_for(resource)
  # end

  # Whitelist params to be fetched from the controller and passed down to the
  # exporter.
  #
  # For example, if you want to export posts for a given category, you
  # can add the `:category_id` param to your export link, and whitelist
  # this param here with :
  #
  #   def self.params_whitelist
  #     [:category_id]
  #   end
  #
  # It will be passed from the controller to the importer so it can be used
  # to scope resources before exporting.
  #
  # Note that you'll manually need to scope the resources by overriding the
  # #resources method.
  #
  # If you need automatic scoping, please use the `:q` param that accepts
  # ransack search params and applies it to the resources.
  #
  # def self.params_whitelist
  #   []
  # end

  # If you need complete control over you CSV generation, use the following
  # method instead of the #fields or #row_for methods, and return a valid CSV
  # string
  #
  # You can use the `csv` extension from the ruby stdlib, for example with the
  # CSV.generate method (more information )
  #
  # def generate
  # end
end
