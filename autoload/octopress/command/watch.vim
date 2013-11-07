function! octopress#command#watch#execute(...)
  let command = 'watch'
  let callback = {}
  call octopress#system#execute(command, callback)
endfunction
