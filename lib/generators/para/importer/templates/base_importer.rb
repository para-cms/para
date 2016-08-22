class <%= model_importer_name %> < Para::Importer::Base
  # Let the importer rescue ActiveRecord::RecordInvalid errors and display them
  # as flash messages after importing valid records
  #
  # Remove or comment this line to disable this behavior
  #
  allow_import_errors!

  def import_from_row(row)
    # Add your import logic here
  end
end
