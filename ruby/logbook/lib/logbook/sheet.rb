class Logbook::Sheet
  attr_reader :date, :entries

  def initialize
    @date = nil
    @entries = []
  end

  def with_date(date)
    @date = date
  end

  def add_entry(entry)
    @entries << entry
  end

  def entry_at(line_number)
    entries.find { |entry| entry.at?(line_number) }
  end
end
