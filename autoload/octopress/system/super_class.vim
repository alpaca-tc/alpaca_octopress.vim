let s:Watch = {
      \ 'instances' : {},
      \ 'stdout_all' : '',
      \ 'stderr_all' : '',
      \ }

function! s:Watch.new(command, callbacks) "{{{
  let instance = deepcopy(self)
  let instance.super = self
  call instance.constructor(a:command, a:callbacks)
  call remove(instance, 'new')
  call remove(instance, 'constructor')
  call remove(instance, 'instances')

  return instance
endfunction"}}}

function! s:Watch.constructor(command, callbacks) "{{{
  let self.command    = a:command
  let self.callbacks  = a:callbacks
endfunction"}}}

function! s:Watch.done() "{{{
  call octopress#message#print('Done!!! ' . self.command)
  call s:do_callback('done')
endfunction"}}}

function! s:Watch.in_process() "{{{
  call self.do_callback('in_process')
endfunction"}}}

function! s:Watch.read() "{{{
  return [get(self, 'stdout', ''), get(self, 'stderr', ''), get(self, 'status', 'not_found')]
endfunction"}}}

function! s:Watch.read_all() "{{{
  call self.read()
  return [get(self, 'stdout_all', ''), get(self, 'stderr_all', ''), get(self, 'status', 'not_found')]
endfunction"}}}

function! s:Watch.do_callback(action) "{{{
  let callbacks = get(self, 'callbacks', {})
  if type(callbacks) == type({}) && has_key(callbacks, a:action)
    call {callbacks[a:action]}(self.read_all(), self)
    return 1
  else
    return 0
  endif
endfunction"}}}

function! octopress#system#super_class#inheritance() "{{{
  return deepcopy(s:Watch)
endfunction"}}}
