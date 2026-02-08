#!/bin/bash
#
# Dotfiles 安装脚本
# 使用 GNU Stow 管理符号链接
# 自动安装 Oh My Zsh、Powerlevel10k 和常用插件
#

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
STOW_PACKAGES=(vim zsh git tmux)

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
step() { echo -e "${BLUE}[STEP]${NC} $1"; }

# 检查是否安装了 zsh
check_zsh() {
    if ! command -v zsh &> /dev/null; then
        warn "Zsh 未安装，正在尝试安装..."
        
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y zsh
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm zsh
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y zsh
        elif command -v brew &> /dev/null; then
            brew install zsh
        else
            error "无法自动安装 zsh，请手动安装"
            exit 1
        fi
    fi
    info "Zsh 已就绪"
}

# 检查是否安装了 stow
check_stow() {
    if ! command -v stow &> /dev/null; then
        warn "GNU Stow 未安装，正在尝试安装..."
        
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y stow
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm stow
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y stow
        elif command -v brew &> /dev/null; then
            brew install stow
        else
            error "无法自动安装 stow，请手动安装"
            exit 1
        fi
    fi
    info "GNU Stow 已就绪"
}

# 检查是否安装了 git
check_git() {
    if ! command -v git &> /dev/null; then
        warn "Git 未安装，正在尝试安装..."
        
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y git
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm git
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y git
        elif command -v brew &> /dev/null; then
            brew install git
        else
            error "无法自动安装 git，请手动安装"
            exit 1
        fi
    fi
    info "Git 已就绪"
}

# 安装 Oh My Zsh
install_omz() {
    step "检查 Oh My Zsh..."
    if [ -d "$HOME/.oh-my-zsh" ]; then
        info "Oh My Zsh 已安装"
        return 0
    fi
    
    info "正在安装 Oh My Zsh..."
    # 使用 --unattended 避免交互，--keep-zshrc 保留现有配置
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    info "Oh My Zsh 安装完成"
}

# 安装 Powerlevel10k 主题
install_p10k() {
    step "检查 Powerlevel10k 主题..."
    local P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    
    if [ -d "$P10K_DIR" ]; then
        info "Powerlevel10k 已安装"
        return 0
    fi
    
    info "正在安装 Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    info "Powerlevel10k 安装完成"
    
    echo ""
    warn "⚠️  提示: 为了正确显示图标，请确保你的终端使用 Nerd Font 字体"
    warn "   推荐安装 MesloLGS NF: https://github.com/romkatv/powerlevel10k#fonts"
}

# 安装 Zsh 插件
install_zsh_plugins() {
    step "检查 Zsh 插件..."
    local ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    # zsh-autosuggestions
    local AUTOSUGGESTIONS_DIR="$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
    if [ ! -d "$AUTOSUGGESTIONS_DIR" ]; then
        info "正在安装 zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
    else
        info "zsh-autosuggestions 已安装"
    fi
    
    # zsh-syntax-highlighting
    local SYNTAX_HIGHLIGHTING_DIR="$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
    if [ ! -d "$SYNTAX_HIGHLIGHTING_DIR" ]; then
        info "正在安装 zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_HIGHLIGHTING_DIR"
    else
        info "zsh-syntax-highlighting 已安装"
    fi
    
    info "所有 Zsh 插件已就绪"
}

# 安装 fzf (可选但推荐)
install_fzf() {
    step "检查 fzf..."
    if command -v fzf &> /dev/null; then
        info "fzf 已安装"
        return 0
    fi
    
    if [ -d "$HOME/.fzf" ]; then
        info "fzf 已安装 (从 git)"
        return 0
    fi
    
    info "正在安装 fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
    info "fzf 安装完成"
}

# 设置 zsh 为默认 shell
set_default_shell() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        info "设置 zsh 为默认 shell..."
        if chsh -s "$(which zsh)"; then
            info "默认 shell 已更改为 zsh"
        else
            warn "无法自动更改默认 shell，请手动运行: chsh -s $(which zsh)"
        fi
    fi
}

# 备份已存在的配置文件
backup_existing() {
    local backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    local need_backup=false
    
    # 检查是否有需要备份的文件
    for pkg in "${STOW_PACKAGES[@]}"; do
        for file in "$DOTFILES_DIR/$pkg"/.*; do
            [ -f "$file" ] || continue
            local filename=$(basename "$file")
            if [ -f "$HOME/$filename" ] && [ ! -L "$HOME/$filename" ]; then
                need_backup=true
                break 2
            fi
        done
    done
    
    if $need_backup; then
        info "备份现有配置文件到 $backup_dir"
        mkdir -p "$backup_dir"
        
        for pkg in "${STOW_PACKAGES[@]}"; do
            for file in "$DOTFILES_DIR/$pkg"/.*; do
                [ -f "$file" ] || continue
                local filename=$(basename "$file")
                if [ -f "$HOME/$filename" ] && [ ! -L "$HOME/$filename" ]; then
                    mv "$HOME/$filename" "$backup_dir/"
                    info "  备份: $filename"
                fi
            done
        done
    fi
}

# 使用 stow 安装指定的包
stow_package() {
    local pkg=$1
    info "正在链接 $pkg..."
    cd "$DOTFILES_DIR"
    stow -v --target="$HOME" "$pkg"
}

# 卸载（取消链接）
unstow_package() {
    local pkg=$1
    info "正在取消链接 $pkg..."
    cd "$DOTFILES_DIR"
    stow -v --target="$HOME" -D "$pkg"
}

# 完整安装 zsh 环境（Oh My Zsh + 主题 + 插件）
install_zsh_environment() {
    step "=========================================="
    step "安装 Zsh 完整环境"
    step "=========================================="
    
    check_zsh
    check_git
    install_omz
    install_p10k
    install_zsh_plugins
    install_fzf
}

# 显示帮助信息
show_help() {
    echo "用法: $0 [选项] [包名...]"
    echo ""
    echo "选项:"
    echo "  install [包...]    安装指定的包（默认安装全部）"
    echo "  uninstall [包...]  卸载指定的包"
    echo "  list               列出所有可用的包"
    echo "  deps               只安装依赖（Oh My Zsh、插件等）"
    echo "  help               显示此帮助信息"
    echo ""
    echo "可用的包: ${STOW_PACKAGES[*]}"
    echo ""
    echo "示例:"
    echo "  $0                 # 完整安装（包括所有依赖和配置）"
    echo "  $0 install zsh     # 只安装 zsh 配置"
    echo "  $0 deps            # 只安装 Oh My Zsh 等依赖"
}

# 主函数
main() {
    local action="${1:-install}"
    shift 2>/dev/null || true
    local packages=("$@")
    
    # 如果没有指定包，使用全部包
    if [ ${#packages[@]} -eq 0 ]; then
        packages=("${STOW_PACKAGES[@]}")
    fi
    
    case "$action" in
        install)
            echo ""
            echo "========================================"
            echo "    Dotfiles 安装程序"
            echo "========================================"
            echo ""
            
            check_stow
            
            # 如果安装 zsh 包，先安装 zsh 环境依赖
            if [[ " ${packages[*]} " =~ " zsh " ]]; then
                install_zsh_environment
            fi
            
            backup_existing
            
            step "=========================================="
            step "链接配置文件"
            step "=========================================="
            
            for pkg in "${packages[@]}"; do
                if [[ " ${STOW_PACKAGES[*]} " =~ " $pkg " ]]; then
                    stow_package "$pkg"
                else
                    warn "未知的包: $pkg"
                fi
            done
            
            # 如果安装了 zsh，询问是否设置为默认 shell
            if [[ " ${packages[*]} " =~ " zsh " ]]; then
                echo ""
                set_default_shell
            fi
            
            echo ""
            echo "========================================"
            info "✨ 安装完成！"
            echo "========================================"
            echo ""
            info "提示: 运行 'exec zsh' 或重新打开终端以应用更改"
            info "如果 p10k 配置向导没有自动启动，运行: p10k configure"
            ;;
        uninstall)
            for pkg in "${packages[@]}"; do
                if [[ " ${STOW_PACKAGES[*]} " =~ " $pkg " ]]; then
                    unstow_package "$pkg"
                else
                    warn "未知的包: $pkg"
                fi
            done
            info "卸载完成"
            ;;
        deps)
            # 只安装依赖，不链接配置
            install_zsh_environment
            info "依赖安装完成"
            ;;
        list)
            echo "可用的包:"
            for pkg in "${STOW_PACKAGES[@]}"; do
                echo "  - $pkg"
            done
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            error "未知的操作: $action"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
