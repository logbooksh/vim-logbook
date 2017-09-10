require 'spec_helper'
require 'date'

describe Logbook::Parser do
  describe "date header" do
    it "parses the date header" do
      date = "2017-09-03 (Sunday)"

      fixture = <<~DOC
      #{date}
      =======
      DOC

      expect(Logbook::Parser.new(fixture).parse.date).to eq(Date.parse(date))
    end

    it "takes the first valid date header it finds" do
      valid_date = "2017-09-03 (Sunday)"
      other_valid_date = "2017-01-01"
      invalid_date = "2017-19-34"

      fixture = <<~DOC
      #{invalid_date}
      =======

      #{valid_date}
      =======

      #{other_valid_date}
      =======
      DOC

      expect(Logbook::Parser.new(fixture).parse.date).to eq(Date.parse(valid_date))
    end
  end

  describe "entries" do
    let(:time) { "10:30" }
    let(:status) { "Start" }
    let(:title) { "My entry" }
    let(:id) { "entry-uuid" }
    let(:notes) do
      <<~NOTES
      Those are notes
      for the contents.
      NOTES
    end

    let(:contents) do
      <<~ENTRY
      [#{time}] [#{status}] #{title}
      [ID: #{id}] [Other: 1234]
      #{notes}
      ENTRY
    end

    subject { Logbook::Parser.new(contents).parse }

    it "parses the entry's title" do
      expect(subject.entries.first.title).to eq(title)
    end

    it "parses the entry's time" do
      expect(subject.entries.first.time).to eq(time)
    end

    it "parses the entry's status" do
      expect(subject.entries.first.status).to eq(status)
    end

    it "parses the entry's properties" do
      entry = subject.entries.first

      expect(entry.properties).to eq({"ID" => id, "Other" => "1234"})
    end

    it "parses the entry's notes" do
      expect(subject.entries.first.notes).to eq(notes)
    end

    it "ignores properties following notes" do
      other_entry = <<~ENTRY
        #{contents}
        [My: Property]
        More notes
        ENTRY

      logbook = Logbook::Parser.new(other_entry).parse

      expect(logbook.entries.first.properties.count).to eq(2)
      expect(logbook.entries.first.notes).to end_with("More notes")
    end

    context "multiple entries" do
      let(:contents) do
        <<~CONTENTS
        [#{time}] [#{status}] #{title}
        [ID: #{id}] [Other: 1234]

        [#{time}] [#{status}] #{title}

        #{notes}
        CONTENTS
      end

      it "saves the entries' location" do
        first_entry = subject.entries.first
        second_entry = subject.entries.last

        expect(first_entry.location.start).to eq(1)
        expect(first_entry.location.end).to eq(4)

        expect(second_entry.location.start).to eq(4)
        expect(second_entry.location.end).to eq(contents.each_line.count)
      end
    end
  end
end
