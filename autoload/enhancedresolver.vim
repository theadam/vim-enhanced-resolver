" Find a pair of quotes and get the thing in between them
"
" @return {String}
function! enhancedresolver#GetCursor() abort
  let l:word = match(getline('.'), '[''"].*[''"]') > -1
        \ ? substitute(getline('.'), '.*[''"]\(.*\)[''"].*', '\1', 'g')
        \ : ''
  return l:word
endfunction

function enhancedresolver#GetWebpackPath() abort
    if filereadable('webpack.production.config.js')
        return 'webpack.production.config.js'
    elseif filereadable('webpack.local.config.js')
        return 'webpack.local.config.js'
    else
        return 'webpack.config.js'
    endif
endfunction

function enhancedresolver#GetCommand() abort
    return (expand('<sfile>:p:h:h') . '/node_modules/.bin/enhancedresolve')
endfunction

" Get path to resolved module under cursor
"
" @return {String} path
function! enhancedresolver#Resolve() abort
  let l:request = enhancedresolver#GetCursor()
  let l:basepath = expand('%:p:h')
  let l:basepath = empty(l:basepath) ? getcwd() : l:basepath
  let l:webpackpath = enhancedresolver#GetWebpackPath()
  let l:result = substitute(system(join([
        \   enhancedresolver#GetCommand(),
        \   '--suppress',
        \   '--basepath', l:basepath,
        \   '--webpackConfig', l:webpackpath,
        \   l:request,
        \ ], ' ')), '\n', '', 'g')
  return l:result
endfunction

" Edit the path to resolved module under cursor
function! enhancedresolver#ResolveAndGo() abort
  let l:result = enhancedresolver#Resolve()
  if empty(l:result) || !filereadable(l:result) | return | endif
  silent! execute 'edit ' . l:result
endfunction
