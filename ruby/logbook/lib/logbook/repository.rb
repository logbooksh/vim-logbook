class Logbook::Repository
  attr_reader :sheets, :tasks

  TASK_ID = "ID"

  def initialize
    @sheets = []
    @tasks = Hash.new { Logbook::Task.new }
  end

  def load(sheet)
    @sheets << sheet

    sheet.entries.each do |entry|
      id = entry.properties[TASK_ID]

      unless id.nil?
        task = tasks[id]
        task.add_entry(entry)
        tasks[id] = task
      end
    end
  end
end
