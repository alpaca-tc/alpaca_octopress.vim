let s:PM = vital#of('alpaca_octopress.vim').import('ProcessManager')

function! octopress#system#asynchronous#new(command, callbacks) "{{{
  return s:Watch.new(a:command, a:callbacks)
endfunction"}}}

let s:Watch = octopress#system#super_class#inheritance()
let s:Watch.instances = {}

function! s:Watch.constructor(command, callbacks) "{{{
  let self.pid        = s:PM.new(a:command)
  let s:Watch.instances[self.pid] = self
  let self.command    = a:command
  let self.callbacks  = a:callbacks
endfunction"}}}

function! s:Watch.read() "{{{
  try
    call s:PM.status(self.pid)
  catch "^ProcessManager doesn't know about.*"
    return [
          \ get(self, 'stdout_all', ''),
          \ get(self, 'stderr_all', ''),
          \ get(self, 'status', 'not_exists')]
  endtry

  let [self.stdout, self.stderr, self.status] = s:PM.read(self.pid, [''])
  let self.stdout_all .= self.stdout
  let self.stderr_all .= self.stderr

  return [self.stdout_all, self.stderr_all, self.status]
endfunction"}}}

function! s:Watch.done() "{{{
  let g:read_all = self.read_all()
  call octopress#message#print('Done!!! ' . self.command)
  call remove(s:Watch.instances, self.pid)
  call self.do_callback('done')
  call s:PM.stop(self.pid)
endfunction"}}}

" Watching process for sync
function! s:check_status() "{{{
  if empty(s:Watch.instances)
    return 0
  endif

  for pid in keys(s:Watch.instances)
    let instance = s:Watch.instances[pid]
    let status = s:PM.status(pid)

    if status == 'active'
      call instance.in_process()
    elseif status == 'inactive'
      call instance.done()
    endif
  endfor
endfunction"}}}

function! s:start_watching() "{{{
  if exists('s:loaded_start_watching')
    return
  endif
  let s:loaded_start_watching = 1

  augroup OctopressWatching
    autocmd!
    autocmd CursorHold * call s:check_status()
  augroup END
endfunction"}}}

call s:start_watching()
