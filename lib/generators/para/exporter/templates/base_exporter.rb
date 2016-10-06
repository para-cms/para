class <%= model_exporter_name %> < Para::Exporter::Base
  def name
    '<%= file_name %>'
  end

  protected

  def generate
    # Add your export logic here, returning the exported data that will be
    # stored with Paperclip and then directly served to the user
  end

  def extension
    '.<%= @format %>'
  end

  # If your #generate method returns binary data, uncomment the following
  # method.
  #
  # def binary?
  #   true
  # end
end
