command! LogbookNew call logbook#New()
command! LogbookAppendLog call logbook#AppendLog()
command! LogbookAppendTask call logbook#AppendTask()
command! LogbookAppendTodo call logbook#AppendTodo()
command! LogbookStartTask call logbook#StartTask()
command! LogbookPauseTask call logbook#PauseTask()
command! LogbookResumeTask call logbook#ResumeTask()
command! LogbookFinishTask call logbook#FinishTask()

nmap <buffer> <Leader>ll <Plug>(LogbookAppendLog)
nmap <buffer> <Leader>lS <Plug>(LogbookAppendTask)
nmap <buffer> <Leader>lt <Plug>(LogbookAppendTodo)

nmap <buffer> <Leader>ls <Plug>(LogbookStartTask)
nmap <buffer> <Leader>lp <Plug>(LogbookPauseTask)
nmap <buffer> <Leader>lr <Plug>(LogbookResumeTask)
nmap <buffer> <Leader>ld <Plug>(LogbookFinishTask)

nnoremap <silent> <Plug>(LogbookAppendLog) :LogbookAppendLog<CR>
nnoremap <silent> <Plug>(LogbookAppendTask) :LogbookAppendTask<CR>
nnoremap <silent> <Plug>(LogbookAppendTodo) :LogbookAppendTodo<CR>
nnoremap <silent> <Plug>(LogbookStartTask) :LogbookStartTask<CR>
nnoremap <silent> <Plug>(LogbookPauseTask) :LogbookPauseTask<CR>
nnoremap <silent> <Plug>(LogbookResumeTask) :LogbookResumeTask<CR>
nnoremap <silent> <Plug>(LogbookFinishTask) :LogbookFinishTask<CR>

setlocal tw=79
