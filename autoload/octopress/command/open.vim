function! s:get_browser_command()
  if !exists('s:browser_command')
    if has('win32') || has('win64')
      let s:browser_command = '!start rundll32 url.dll,FileProtocolHandler %URL%'
    elseif exists(':OpenBrowser')
      let s:browser_command = ':OpenBrowser %URL%'
    elseif has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin'
      let s:browser_command = 'open %URL%'
    elseif executable('xdg-open')
      let s:browser_command = 'xdg-open %URL%'
    elseif executable('firefox')
      let s:browser_command = 'firefox %URL% &'
    else
      let s:browser_command = ''
    endif
  endif

  return s:browser_command
endfunction

function! s:open_browser(url)
  let command = s:get_browser_command()

  if len(command) == 0
    call octopress#message#print_error('Not found browser command')
  else
    if command =~ '^!'
      let command = substitute(command, '%URL%', '\=shellescape(a:url)', 'g')
      silent! exec command
    elseif command =~ '^:[A-Z]'
      let command = substitute(command, '%URL%', '\=a:url', 'g')
      exec command[1:]
    else
      let command = substitute(command, '%URL%', '\=shellescape(a:url)', 'g')
      call system(command)
    endif
  endif
endfunction

function! octopress#command#open#execute(options)
  call s:open_browser(g:octopress#url)
endfunction
