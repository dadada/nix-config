let b:ale_fixers = ['clang-format', 'remove_trailing_lines', 'trim_whitespace']
let b:ale_linters = ['clangd']

"setlocal tabstop=8 expandtab shiftwidth=2 smarttab
" GNU Coding Standards
setlocal cindent
setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal textwidth=79
setlocal fo-=ro fo+=cql
