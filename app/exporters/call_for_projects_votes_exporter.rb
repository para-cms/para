class CallForProjectsVotesExporter < Para::Exporter::Xls
  attr_reader :call_for_projects

  def name
    'votes-appel-projets'
  end

  protected

  def self.params_whitelist
    [:call_for_projects_id]
  end

  def resources
    resources = ActsAsVotable::Vote.joins(
      "LEFT JOIN call_for_projects_applications " +
        "ON call_for_projects_applications.id = votes.votable_id " +
        "AND votes.votable_type = 'CallForProjectsApplication'"
    ).includes(:voter, votable: :call_for_projects)

    # Filter if available
    resources = resources.where(
      call_for_projects_applications: {
        call_for_projects_id: params[:call_for_projects_id]
      }
    ) if params[:call_for_projects_id]

    resources
  end

  # Defining the fields that you want to export will export all those fields
  # directly to the XLS file
  #
  def headers
    ['Appel à projets', 'Projet', 'E-mail', 'Nom', 'Prénom', 'Date du vote']
  end

  # If you need special behavior in the row generation (rendering associated
  # models or other specific logic), you can return an array here that will
  # be written to the XLS
  #
  # For safe XLS writing, use the #encode method on every string in the
  # returned array.
  #
  # Example :
  #
  #   fields = [...]
  #   fields.map!(&:encode)
  #
  def row_for(resource)
    [
      resource.votable.call_for_projects.title,
      resource.votable.name,
      resource.voter.email,
      resource.voter.last_name,
      resource.voter.first_name,
      I18n.l(resource.created_at)
    ]
  end

  # If you need complete control over you XLS generation, use the following
  # method instead of the #fields or #row_for methods, and return a valid XLS
  # StringIO object.
  #
  # A `#generate_workbook` method is provided, which will yield the workbook to
  # you so you can just fill it, and then returns a StringIO that can be
  # directly written to the Excel file.
  #
  # Please check the [Spreadsheet](https://github.com/zdavatz/spreadsheet) gem
  # documentation for more informations about how to build your Excel document.
  #
  # def generate
  #   generate_workbook do |workbook|
  #     sheet = workbook.create_worksheet
  #     sheet.row(0).concat ['data', 'row']
  #     sheet.row(1).concat ['other', 'row']
  #   end
  # end
end
