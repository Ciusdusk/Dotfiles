" ====================================================================
set nocompatible            " 关闭 vi 兼容模式
set encoding=utf-8          " 强制使用 UTF-8 编码 (解决中文乱码的关键)
set fileencodings=utf-8,gbk,latin1
set backspace=indent,eol,start " 修复退格键无法删除某些字符的问题
set history=1000            " 记录 1000 条历史指令
set mouse=a                 " 开启鼠标全功能支持 (点击、滚动、选中)

" 剪贴板设置 (WSL 提示: 如果无效，请运行 sudo apt install vim-gtk)
set clipboard=unnamedplus   

" 禁止生成恼人的临时文件 (如 .swp, .backup)
set nobackup
set nowritebackup
set noswapfile

" ====================================================================
" 2. 界面与显示 (UI & Display)
" ====================================================================
syntax on                   " 开启语法高亮
set number                  " 显示绝对行号
set ruler                   " 右下角显示光标位置
set showcmd                 " 右下角显示未输完的指令
set laststatus=2            " 总是显示状态栏
set cursorline              " 高亮当前行 (后面会优化颜色，防止刺眼)
set showmatch               " 高亮匹配的括号
set scrolloff=5             " 光标移动到缓冲区顶部/底部时保持 5 行距离

" ====================================================================
" 3. 缩进与代码排版 (Coding Style)
" ====================================================================
set autoindent              " 继承上一行的缩进
set smartindent             " 智能缩进 (针对 C/C++ 等语言)
set tabstop=4               " Tab 键的宽度为 4 个空格
set shiftwidth=4            " 自动缩进宽度为 4
set expandtab               " 将 Tab 自动转换为空格 (Python 开发铁律)
set softtabstop=4           " 退格键一次删除 4 个空格
set wrap                    " 长行自动换行显示 (不影响实际文件)

" ====================================================================
" 4. 搜索设置 (Search)
" ====================================================================
set hlsearch                " 高亮搜索结果
set incsearch               " 边输入边搜索 (实时预览)
set ignorecase              " 搜索忽略大小写
set smartcase               " 智能大小写 (如果输入大写，则强制区分大小写)

" ====================================================================
" 5. 快捷键映射 (Key Mappings)
" ====================================================================
" 设置 Leader 键为空格 (比默认的 \ 更顺手)
let mapleader=" "

" [神器] 按两次 Esc 快速取消搜索高亮 (解决 '背景一直亮' 的问题)
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" 快速保存 (空格 + w)
nnoremap <Leader>w :w<CR>
" 快速退出 (空格 + q)
nnoremap <Leader>q :q<CR>

" ====================================================================
" 6. 颜色与主题深度优化 (Colors & Theme Fixes)
" ====================================================================
" 强制开启 256 色支持 (解决 WSL/Tmux 颜色丢失的核心)
set t_Co=256
set background=dark

" 使用 desert 主题 (Vim 内置主题中对比度最好的之一)
colorscheme desert

" --------------------------------------------------------------------
" [关键修复区] 覆盖主题默认设置，解决背景刺眼和注释看不清
" --------------------------------------------------------------------

" 背景透明化: 让 Vim 使用终端本身的背景 (解决 '灰底/色块' 问题)
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE


" 注释颜色优化: 强制设为淡蓝色 (110) 或 淡灰色 (248)
" 这样可以清晰区分代码和注释
highlight Comment ctermfg=110

" 行号颜色优化: 设为深灰色，不抢眼
highlight LineNr ctermfg=DarkGrey

" ====================================================================
" 7. 插件管理 (Plugins via vim-plug)
" ====================================================================
" 自动安装 vim-plug (如果不存在)
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'vim-autoformat/vim-autoformat'
call plug#end()

" ====================================================================
" 8. 代码格式化 (Code Formatting)
" ====================================================================
" 格式化快捷键: 空格 + f
nnoremap <Leader>f :Autoformat<CR>

" 保存时自动格式化 (可选，取消注释启用)
autocmd BufWrite * :Autoformat

" Shell: shfmt (4空格缩进, switch-case缩进)
let g:formatdef_shfmt = '"shfmt -i 4 -ci"'
let g:formatters_sh = ['shfmt']

" Python: black (PEP 8 标准)
let g:formatdef_black = '"black -q -"'
let g:formatters_python = ['black']

" C/C++: clang-format
let g:formatters_c = ['clangformat']
let g:formatters_cpp = ['clangformat']

" Java: google-java-format
let g:formatdef_google_java = '"google-java-format -"'
let g:formatters_java = ['google_java']
