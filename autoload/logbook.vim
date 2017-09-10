if exists('g:logbook_autoloaded') || &cp
  finish
endif

let g:logbook_autoloaded = 1

function! s:RubyMissingWarning() abort
  echohl WarningMsg
  echo 'logbook.vim requires Vim to be compiled with Ruby support'
  echo 'For more information type:  :help logbook'
  echohl none
endfunction

function! logbook#New() abort
  if has('ruby')
    ruby $logbook.new_logbook
  else
    call s:RubyWarning()
  endif
endfunction

function! logbook#AppendLog() abort
  if has('ruby')
    ruby $logbook.append_log
  else
    call s:RubyWarning()
  endif
endfunction

function! logbook#AppendTask() abort
  if has('ruby')
    ruby $logbook.new_task(Logbook::START)
  else
    call s:RubyWarning()
  endif
endfunction

function! logbook#AppendTodo() abort
  if has('ruby')
    ruby $logbook.new_task(Logbook::TODO)
  else
    call s:RubyWarning()
  endif
endfunction

function! logbook#StartTask() abort
  if has('ruby')
    ruby $logbook.start_current_task
  else
    call s:RubyWarning()
  endif
endfunction

function! logbook#PauseTask() abort
  if has('ruby')
    ruby $logbook.pause_current_task
  else
    call s:RubyWarning()
  endif
endfunction

function! logbook#ResumeTask() abort
  if has('ruby')
    ruby $logbook.resume_current_task
  else
    call s:RubyWarning()
  endif
endfunction

function! logbook#FinishTask() abort
  if has('ruby')
    ruby $logbook.finish_current_task
  else
    call s:RubyWarning()
  endif
endfunction

ruby << EOF
  begin
    require 'logbook'
    $logbook = Logbook::Vim.new
  rescue LoadError
    load_path_modified = false
    ::VIM::evaluate('&runtimepath').to_s.split(',').each do |path|
      lib = "#{path}/ruby/logbook/lib"
      if !$LOAD_PATH.include?(lib) && File.exist?(lib)
        $LOAD_PATH << lib
        load_path_modified = true
      end
    end
    retry if load_path_modified
  end
EOF
