" ==========================================
" 基础设置
" ==========================================
set nocompatible            " 关闭 vi 兼容模式
syntax on                   " 开启语法高亮
set number                  " 显示行号
set cursorline              " 高亮当前行
set showmatch               " 高亮匹配的括号
set ruler                   " 显示光标位置

" ==========================================
" 缩进与排版
" ==========================================
set autoindent              " 自动缩进
set smartindent             " 智能缩进
set tabstop=4               " Tab 宽度为 4
set shiftwidth=4            " 自动缩进宽度为 4
set expandtab               " 将 Tab 转为空格 (Python 开发必备)
set softtabstop=4

" ==========================================
" 搜索设置
" ==========================================
set hlsearch                " 高亮搜索结果
set incsearch               " 边输入边搜索
set ignorecase              " 搜索忽略大小写
set smartcase               " 智能大小写 (输入大写时才敏感)

" ==========================================
" 交互体验
" ==========================================
set mouse=a                 " 开启鼠标支持 (点击定位光标，滚轮翻页)
set clipboard=unnamedplus   " 共享系统剪贴板 (需要 vim-gtk 或 neovim)
set history=1000            " 记录 1000 条历史

" ==========================================
" 颜色主题 (适配深色终端)
" ==========================================
set background=dark
colorscheme ron             " 内置配色，ron 在深色背景下对比度较好
