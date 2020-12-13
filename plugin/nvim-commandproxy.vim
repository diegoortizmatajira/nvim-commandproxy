if !has('nvim-0.5')
  echoerr 'You need neovim nightly to run this plugin'
  finish
endif

if exists('g:nvim_command_proxy_loaded') | finish | endif "prevents loading twice"

let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

let g:commandproxy_commands = {}

lua require 'nvim-commandproxy'.register_commands({ DevTestproxy = "echo 'X'" })

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:nvim_command_proxy_loaded = 1
