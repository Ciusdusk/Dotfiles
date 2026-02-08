#!/bin/bash
#
# Dotfiles 安装脚本
# 使用 GNU Stow 管理符号链接
#

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
STOW_PACKAGES=(vim zsh git tmux)

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

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

# 显示帮助信息
show_help() {
    echo "用法: $0 [选项] [包名...]"
    echo ""
    echo "选项:"
    echo "  install [包...]  安装指定的包（默认安装全部）"
    echo "  uninstall [包...] 卸载指定的包"
    echo "  list             列出所有可用的包"
    echo "  help             显示此帮助信息"
    echo ""
    echo "可用的包: ${STOW_PACKAGES[*]}"
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
            check_stow
            backup_existing
            for pkg in "${packages[@]}"; do
                if [[ " ${STOW_PACKAGES[*]} " =~ " $pkg " ]]; then
                    stow_package "$pkg"
                else
                    warn "未知的包: $pkg"
                fi
            done
            echo ""
            info "✨ 安装完成！"
            info "提示: 运行 'source ~/.zshrc' 或重新打开终端以应用更改"
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
