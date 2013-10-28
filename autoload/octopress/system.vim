let s:V  = vital#of('alpaca_octopress.vim')
let s:PM = s:V.import('ProcessManager')
let s:P  = s:V.import('Process')

" Utils {{{
function! s:reltime() "{{{
  return str2float(reltimestr(reltime()))
endfunction"}}}

function! s:build_command(command_or_callback) "{{{
  let commands = []
  let callback = {}

  for option in a:command_or_callback
    if type(option) == type([])
      call extend(commands, option)
    elseif type(option) == type('')
      call add(commands, option)
    elseif type(option) == type({})
      call extend(callback, option)
    endif
    unlet option
  endfor

  let command = g:octopress#rake_command . ' ' . join(commands, ' ')

  return [command, callback]
endfunction"}}}

function! s:callback(instance, action) "{{{
  let callbacks = a:instance.callbacks

  if type(callbacks) == type({}) && has_key(callbacks, a:action)
    call {callbacks[a:action]}(a:instance.read(), a:instance)
  endif
endfunction"}}}
"}}}

function! s:synchronism_system(command, callbacks) "{{{
  let instance = s:WatchSync.new(a:command, a:callbacks)
  call instance.read()
  call instance.done()
endfunction"}}}

function! s:asynchronism_system(command, callbacks) "{{{
  call s:Watch.new(a:command, a:callbacks)
endfunction"}}}

function! octopress#system#execute(...) "{{{
  let [command, callback] = s:build_command(a:000)
  let g:octopress#debug.last_execute = [command, callback]

  if s:P.has_vimproc() && g:octopress#system#async == 1
    return s:asynchronism_system(command, callback)
  else
    return s:synchronism_system(command, callback)
  endif
endfunction"}}}

" Watching process for sync
let s:WatchSync = {}
function! s:WatchSync.new(command, callbacks) "{{{
  let instance = deepcopy(self)
  call remove(instance, 'new')

  let instance.command    = a:command
  let instance.callbacks  = a:callbacks

  return instance
endfunction"}}}

function! s:WatchSync.read() "{{{
  if !has_key(self, 'result')
    call octopress#message#print(self.command . '...')
    let self.result = s:P.system(self.command)
  endif

  return [self.result, '', 'inactive']
endfunction"}}}

function! s:WatchSync.done() "{{{
  call octopress#message#print('Done!!! ' . self.command)
  call s:callback(self, 'done')
endfunction"}}}

" Watching process for async {{{
let s:Watch = {
      \ 'instances' : {}
      \ }

function! s:Watch.new(command, callbacks) "{{{
  let instance = deepcopy(self)
  call instance.constructor(a:command, a:callbacks)
  call remove(instance, 'new')
  call remove(instance, 'constructor')
  call remove(instance, 'instances')

  return instance
endfunction"}}}

function! s:Watch.constructor(command, callbacks) "{{{
  let self.pid        = s:PM.new(a:command)
  let s:Watch.instances[self.pid] = self
  let self.command    = a:command
  let self.callbacks  = a:callbacks
  let self.start_time = reltime()
  let self.result     = ''
endfunction"}}}

function! s:Watch.read() "{{{
  try
    call s:PM.status(self.pid)
  catch "^ProcessManager doesn't know about.*"
    return [get(self, 'stdout', ''), get(self, 'stderr', ''), get(self, 'status', 'inactive')]
  endtry

  let self.last_read = s:PM.read(self.pid, [''])

  if has_key(self, 'stdout')
    let self.stdout .= self.last_read[0]
    let self.stderr .= self.last_read[1]
    let self.status  = self.last_read[2]
  else
    let self.stdout  = self.last_read[0]
    let self.stderr  = self.last_read[1]
    let self.status  = self.last_read[2]
  endif

  return [self.stdout, self.stderr, self.status]
endfunction"}}}

function! s:Watch.done() "{{{
  call octopress#message#print('Done!!! ' . self.command)
  call remove(s:Watch.instances, self.pid)
  call s:callback(self, 'done')
  call s:PM.stop(self.pid)
endfunction"}}}

function! s:Watch.in_process() "{{{
  call octopress#message#print(self.command . '...')
  call s:callback(self, 'in_process')
endfunction"}}}

function! s:Watch.check() "{{{
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
"}}}

function! octopress#system#reload() "{{{
  call s:start_watching()

  for pid in keys(s:Watch.instances)
    call s:PM.stop(pid)
    let s:Watch.instances = {}
  endfor
endfunction"}}}

function! s:start_watching() "{{{
  if exists('s:loaded_start_watching')
    return
  endif
  let s:loaded_start_watching = 1

  augroup OctopressWatching
    autocmd!
    autocmd CursorHold * call s:Watch.check()
  augroup END
endfunction"}}}

call octopress#system#reload()
