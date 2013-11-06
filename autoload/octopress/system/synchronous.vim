let s:P = vital#of('alpaca_octopress.vim').import('Process')

function! octopress#system#synchronous#new(command, callbacks) "{{{
  return s:Watch.new(a:command, a:callbacks)
endfunction"}}}

let s:Watch = octopress#system#super_class#inheritance()

function! s:Watch.constructor(command, callbacks) "{{{
  let self.command    = a:command
  let self.callbacks  = a:callbacks
  call self.read()
  call self.done()
endfunction"}}}

function! s:Watch.read() "{{{
  if !has_key(self, 'stdout')
    call octopress#message#print(self.command . '...')
    let self.stdout = s:P.system(self.command)
    let self.stdout_all = self.stdout
  endif

  return [self.stdout, '', 'inactive']
endfunction"}}}

function! s:Watch.done() "{{{
  call octopress#message#print('Done!!! ' . self.command)
  call self.do_callback('done')
endfunction"}}}
