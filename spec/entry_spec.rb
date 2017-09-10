require 'spec_helper'

describe Logbook::Entry do
  let(:start_line) { 1 }
  let(:end_line) { 4 }

  subject do
    Logbook::Entry.new(Time.now.utc).starts_at(start_line).ends_at(end_line)
  end

  it "knows if it matches a given line number" do
    expect(subject.at?(start_line)).to be_truthy
    expect(subject.at?(end_line)).to be_falsy
    expect(subject.at?(start_line - 1)).to be_falsy
  end
end
