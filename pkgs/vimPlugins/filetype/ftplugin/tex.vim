setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2

let b:ale_linters = {'tex': ['texlab']}
let b:ale_fixers = {'tex': ['remove_trailing_lines', 'trim_whitespace', 'texlab']}
