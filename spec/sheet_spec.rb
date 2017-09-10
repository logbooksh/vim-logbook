require 'spec_helper'

describe Logbook::Sheet do
  it "knows which entry matches a given line number" do
    entry = Logbook::Entry.new("10:15").starts_at(1).ends_at(4)
    sheet = Logbook::Sheet.new
    sheet.add_entry(entry)

    line_number = 2
    empty_line_number = 99

    expect(sheet.entry_at(line_number)).to eq(entry)
    expect(sheet.entry_at(empty_line_number)).to be_nil
  end
end
