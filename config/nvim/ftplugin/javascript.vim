setlocal textwidth=120

let g:jsx_ext_required = 0
let g:javascript_plugin_jsdoc = 1

let javaScript_fold=1

nmap <leader>x :VimuxRunCommand('npm test')<cr>

" Linting
let b:ale_linters = ['eslint']
let b:ale_fixers = ['eslint']
