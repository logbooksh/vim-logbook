require 'spec_helper'

describe Logbook::Repository do
  let(:repository) { Logbook::Repository.new }
  let(:sheet) do
    sheet = Logbook::Sheet.new
    sheet.add_entry(entry)
    sheet
  end

  let(:entry) do
    entry = Logbook::Entry.new(time)
    entry.with_title(title)
    entry.add_properties({"ID" => task_id})
    entry
  end

  let(:title) { "Task title" }
  let(:time) { "10:15" }
  let(:task_id) { "task-id" }

  it "extracts tasks from sheets" do
    repository.load(sheet)

    expect(repository.tasks.count).to eq(1)
    expect(repository.tasks.values.first.title).to eq(title)
  end

  it "finds tasks by ID" do
    repository.load(sheet)

    expect(repository.tasks[task_id].id).to eq(task_id)
  end

  context "with multiple entries for the same task" do
    let(:final_title) { "Final title" }
    let(:final_status) { "Done" }
    let(:later_time) { "12:30" }

    before do
      entry = Logbook::Entry.new(later_time)
      entry.with_title(final_title)
      entry.with_status(final_status)
      entry.add_properties({"ID" => task_id})

      sheet.add_entry(entry)
    end

    it "extracts the last known title for a task" do
      repository.load(sheet)

      expect(repository.tasks[task_id].title).to eq(final_title)
    end

    it "extracts the last known status for a task" do
      repository.load(sheet)

      expect(repository.tasks[task_id].status).to eq(final_status)
    end
  end
end
