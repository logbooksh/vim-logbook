require 'date'
require 'pry'

class Logbook::Parser
  attr_reader :contents, :state
  REGEX = {
    date_header: /^(\d{4}-\d\d-\d\d).*$/,
    entry_header: /^\[(\d\d:\d\d)\](?: \[(\w+)\] (.+))?$/,
    entry_properties: /\s*(?:\s*\[(\w+): (.*?)\]\s*)\s*/
  }

  def initialize(contents)
    @contents = contents
    @state = initial_state
  end

  def parse
    contents.each_line.with_index.reduce(Logbook::Sheet.new, &method(:parse_line))
  end

  private
  def parse_line(logbook, (line, line_number))
    line.chomp!.strip!
    line_number += 1

    case state[:label]
    when :start
      if (logbook.date.nil? && date = parse_date_header(line))
        logbook.with_date(date)
      end

      if (entry = parse_entry_header(line))
        entry.starts_at(line_number).ends_at(line_number)
        logbook.add_entry(entry)
        next_state(:entry_header, entry)
      end
    when :entry_header
      entry = state[:data]
      entry.ends_at(line_number)

      if (properties = parse_entry_properties(line))
        entry.add_properties(properties)
      elsif (next_entry = parse_entry_header(line))
        logbook.add_entry(next_entry)
        next_entry.starts_at(line_number).ends_at(line_number)
        next_state(:entry_header, next_entry)
      else
        entry.add_note(line)
        next_state(:entry_notes, entry)
      end
    when :entry_notes
      entry = state[:data]
      entry.ends_at(line_number)

      if (next_entry = parse_entry_header(line))
        logbook.add_entry(next_entry)
        next_entry.starts_at(line_number).ends_at(line_number)
        next_state(:entry_header, next_entry)
      else
        entry.add_note(line)
      end
    else
      puts "Ignoring line #{line_number + 1}"
    end

    logbook
  end

  def parse_date_header(line)
    line.scan(REGEX[:date_header]).each do |match|
      if valid_date?(match.first)
        return Date.parse(match.first)
      end
    end

    nil
  end

  def parse_entry_header(line)
    if (match_data = REGEX[:entry_header].match(line))
      time, status, title = match_data.captures
      Logbook::Entry.new(time).with_status(status).with_title(title)
    end
  end

  def parse_entry_properties(line)
    properties = line.scan(REGEX[:entry_properties]).to_h

    if properties.any?
      properties
    else
      nil
    end
  end

  def valid_date?(content)
    Date.parse(content)
    true
  rescue ArgumentError
    false
  end

  def initial_state
    next_state(:start)
  end

  def next_state(label, data = {})
    @state = {label: label, data: data}
  end
end
