require "date"
require "time"
require "securerandom"

class Logbook::Vim
  TODO = "ToDo"
  START = "Start"
  PAUSE = "Pause"
  RESUME = "Resume"
  DONE = "Done"

  INITIAL_TASK_STATUS = TODO
  STATUSES = [TODO, START, PAUSE, RESUME, DONE]

  def new_logbook
    buffer = current_buffer

    if empty_buffer?(buffer)
      today = Date.today.strftime("%Y-%m-%d")
      day_plan = "Day Plan"

      [today, header(today), "", day_plan, underline(day_plan), underline(day_plan)].each_with_index do |line, i|
        buffer.append(i, line)
      end
    end
  end

  def append_log
    new_log = "[#{log_time}]"
    current_buffer.append(current_buffer.count, new_log)
    current_buffer.append(current_buffer.count, "")
    current_window.cursor = [current_buffer.count, 1]
    Vim::command("startinsert")
  end

  def new_task(status = INITIAL_TASK_STATUS)
    task = {title: "", status: status, id: generate_task_id}

    line = if status == INITIAL_TASK_STATUS
      append_task(task, false)
    else
      append_task(task)
    end

    current_window.cursor = [line, task_title_index(current_buffer[line])]
    Vim::command("startinsert!")
  end

  def start_current_task
    task = current_task

    if task && task[:status] == TODO
      change_current_task_status(START)
    end
  end

  def pause_current_task
    task = current_task

    if task
      change_current_task_status(PAUSE)
    end
  end

  def resume_current_task
    task = current_task

    if task
      change_current_task_status(RESUME)
    end
  end

  def finish_current_task
    task = current_task

    if task
      change_current_task_status(DONE)
    end
  end

  def change_current_task_status(status)
    task = current_task

    if task
      task[:status] = status
      append_task(task)
      current_window.cursor = [current_buffer.count, 1]
    end
  end

  private
  def append_task(task, with_log_time = true)
    prefix = with_log_time ? "[#{log_time}] " : ""
    new_log = "#{prefix}[#{task[:status]}] #{task[:title]}"
    tags = align_with_title(new_log) + "[ID: #{task[:id]}]"

    current_buffer.append(current_buffer.count, "") if current_buffer[current_buffer.count] != ""
    starting_line_number = current_buffer.count + 1
    current_buffer.append(current_buffer.count, new_log)
    current_buffer.append(current_buffer.count, tags)

    starting_line_number
  end

  def empty_buffer?(buffer)
    buffer.length == 1 && buffer.line == ""
  end

  def current_buffer
    Vim::Buffer.current
  end

  def current_window
    Vim::Window.current
  end

  def header(text)
    "=" * text.length
  end

  def underline(text)
    "-" * text.length
  end

  def generate_task_id
    SecureRandom::uuid
  end

  def log_time
    Time.now.strftime("%H:%M")
  end

  def align_with_title(line)
    " " * task_title_index(line)
  end

  def task_title_index(line)
    line.rindex(']') + 2
  end

  def current_task
    row, _ = current_window.cursor
    current_sheet.entry_at(row)
  end

  def current_sheet
    contents = current_buffer.count.times.map { |i| current_buffer[i] }.join("\n")
    Logbook::Parser.new(contents).parse
  end
end
