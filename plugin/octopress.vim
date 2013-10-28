"=============================================================================
" FILE: alpaca_octpress
" AUTHOR: Ishii Hiroyuki <alprhcp666@gmail.com>
" Last Modified: 2013-10-27
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

if exists('g:loaded_alpaca_octpress')
  finish
endif
let g:loaded_alpaca_octpress = 1

let s:save_cpo = &cpo
set cpo&vim

let s:save_cpo = &cpo
set cpo&vim

let g:octopress#rake_command = get(g:, 'octopress#rake_command', 'rake')
let g:octopress#project_url = get(g:, 'octopress#project_url', '')
let g:octopress#system#async = get(g:, 'octopress#system#async', 0)
let g:octopress#open = get(g:, 'octopress#open', 'tabnew')
let g:octopress#debug = {}

command! -bang -nargs=* -complete=customlist,octopress#complete Octopress call octopress#execute(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
