function! octopress#command#preview#execute(...)
  let command = 'preview'
  let callback = {}
  call octopress#system#execute(command, callback)
endfunction
