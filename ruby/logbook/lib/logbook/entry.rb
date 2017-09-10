class Logbook::Entry
  attr_reader :properties, :status, :time, :title,
              :location

  def initialize(time)
    @time = time
    @notes = []
    @properties = {}
    @location = Struct.new(:start, :end).new
  end

  def notes
    @notes.join("\n")
  end

  def add_note(note)
    @notes << note
    self
  end

  def with_status(status)
    @status = status
    self
  end

  def with_title(title)
    @title = title
    self
  end

  def add_properties(properties)
    @properties.merge!(properties)
    self
  end

  def starts_at(line_number)
    @location.start = line_number
    self
  end

  def ends_at(line_number)
    @location.end = line_number
    self
  end

  def at?(line_number)
    line_number >= location.start && line_number < location.end
  end
end
