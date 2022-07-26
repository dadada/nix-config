setlocal textwidth=79

let b:ale_linters = {'tex': ['texlab']}
let b:ale_fixers = {'tex': ['remove_trailing_lines', 'trim_whitespace', 'texlab']}
