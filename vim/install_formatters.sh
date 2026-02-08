#!/bin/bash
# ====================================================================
# Vim 代码格式化工具安装脚本
# 支持: Shell (shfmt), Python (black), C/C++ (clang-format), Java
# ====================================================================

set -e

echo "🚀 开始安装代码格式化工具..."
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

success() { echo -e "${GREEN}✓ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠ $1${NC}"; }
error() { echo -e "${RED}✗ $1${NC}"; }

# --------------------------------------------------------------------
# 1. shfmt (Shell 格式化)
# --------------------------------------------------------------------
echo "📦 [1/4] 安装 shfmt (Shell 格式化)..."
if command -v shfmt &> /dev/null; then
    success "shfmt 已安装: $(shfmt --version)"
else
    if command -v go &> /dev/null; then
        go install mvdan.cc/sh/v3/cmd/shfmt@latest
        success "shfmt 安装成功 (via Go)"
    elif command -v snap &> /dev/null; then
        sudo snap install shfmt
        success "shfmt 安装成功 (via Snap)"
    else
        warn "无法自动安装 shfmt，请手动安装:"
        echo "    方式1: go install mvdan.cc/sh/v3/cmd/shfmt@latest"
        echo "    方式2: sudo snap install shfmt"
        echo "    方式3: 从 https://github.com/mvdan/sh/releases 下载"
    fi
fi
echo ""

# --------------------------------------------------------------------
# 2. black (Python 格式化)
# --------------------------------------------------------------------
echo "📦 [2/4] 安装 black (Python 格式化)..."
if command -v black &> /dev/null; then
    success "black 已安装: $(black --version | head -1)"
else
    if command -v pipx &> /dev/null; then
        pipx install black
        success "black 安装成功 (via pipx)"
    else
        warn "无法自动安装 black，请手动安装:"
        echo "    pipx install black"
    fi
fi
echo ""

# --------------------------------------------------------------------
# 3. clang-format (C/C++ 格式化)
# --------------------------------------------------------------------
echo "📦 [3/4] 安装 clang-format (C/C++ 格式化)..."
if command -v clang-format &> /dev/null; then
    success "clang-format 已安装: $(clang-format --version)"
else
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y clang-format
        success "clang-format 安装成功 (via apt)"
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y clang-tools-extra
        success "clang-format 安装成功 (via dnf)"
    elif command -v pacman &> /dev/null; then
        sudo pacman -S clang
        success "clang-format 安装成功 (via pacman)"
    else
        warn "无法自动安装 clang-format，请手动安装:"
        echo "    Ubuntu/Debian: sudo apt install clang-format"
        echo "    Fedora: sudo dnf install clang-tools-extra"
        echo "    Arch: sudo pacman -S clang"
    fi
fi
echo ""

# --------------------------------------------------------------------
# 4. google-java-format (Java 格式化)
# --------------------------------------------------------------------
echo "📦 [4/4] 安装 google-java-format (Java 格式化)..."

JAVA_FORMAT_VERSION="1.19.2"
JAVA_FORMAT_JAR="google-java-format-${JAVA_FORMAT_VERSION}-all-deps.jar"
JAVA_FORMAT_DIR="$HOME/.local/share/google-java-format"
JAVA_FORMAT_PATH="$JAVA_FORMAT_DIR/$JAVA_FORMAT_JAR"
JAVA_FORMAT_WRAPPER="$HOME/.local/bin/google-java-format"

if command -v google-java-format &> /dev/null; then
    success "google-java-format 已安装"
else
    # 创建目录
    mkdir -p "$JAVA_FORMAT_DIR"
    mkdir -p "$HOME/.local/bin"
    
    # 下载 JAR
    if [ ! -f "$JAVA_FORMAT_PATH" ]; then
        echo "    下载 google-java-format v${JAVA_FORMAT_VERSION}..."
        curl -fL -o "$JAVA_FORMAT_PATH" \
            "https://github.com/google/google-java-format/releases/download/v${JAVA_FORMAT_VERSION}/${JAVA_FORMAT_JAR}"
    fi
    
    # 创建 wrapper 脚本
    cat > "$JAVA_FORMAT_WRAPPER" << 'EOF'
#!/bin/bash
exec java -jar "$HOME/.local/share/google-java-format/google-java-format-1.19.2-all-deps.jar" "$@"
EOF
    chmod +x "$JAVA_FORMAT_WRAPPER"
    
    success "google-java-format 安装成功"
    warn "请确保 ~/.local/bin 在 PATH 中"
fi
echo ""

# --------------------------------------------------------------------
# 安装总结
# --------------------------------------------------------------------
echo "======================================================================"
echo "📋 安装检查:"
echo "======================================================================"
check_tool() {
    if command -v "$1" &> /dev/null; then
        success "$1 ✓"
    else
        error "$1 ✗ (未找到)"
    fi
}

check_tool "shfmt"
check_tool "black"
check_tool "clang-format"
check_tool "google-java-format"

echo ""
echo "======================================================================"
echo "🎉 安装完成! 在 Vim 中使用 <Space>f 格式化代码"
echo "======================================================================"
