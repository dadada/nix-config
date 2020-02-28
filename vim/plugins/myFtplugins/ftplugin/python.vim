" Check Python files with flake8 and pylint.
let b:ale_linters = ['flake8', 'pylint']
" Fix Python files with autopep8 and yapf.
let b:ale_fixers = ['autopep8', 'yapf', 'add_blank_lines_for_python_control_statements', 'autopep8', 'remove_trailing_lines', 'reorder-python-imports', 'trim_whitespace']
