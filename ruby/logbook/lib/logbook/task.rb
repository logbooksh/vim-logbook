class Logbook::Task
  attr_reader :id, :title, :status, :entries

  ID_PROPERTY = "ID"

  def initialize
    @entries = []
  end

  def add_entry(entry)
    @entries << entry

    self.id = entry.properties[ID_PROPERTY]
    self.title = entry.title unless entry.title.nil? || entry.title.empty?
    self.status = entry.status unless entry.status.nil? || entry.status.empty?

    self
  end

  private
  attr_writer :id, :title, :status
end
