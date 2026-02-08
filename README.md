# Dotfiles

我的个人配置文件，使用 [GNU Stow](https://www.gnu.org/software/stow/) 管理。

## ✨ 特性

- **一键安装**: 自动安装所有依赖（Oh My Zsh、Powerlevel10k、插件等）
- **跨平台**: 支持 apt、pacman、dnf、brew 等包管理器
- **安全备份**: 自动备份现有配置文件
- **模块化**: 可选择性安装特定配置包

## 包含的配置

| 包   | 文件                  | 说明                            |
| ---- | --------------------- | ------------------------------- |
| vim  | `.vimrc`              | Vim 编辑器配置                  |
| zsh  | `.zshrc`, `.p10k.zsh` | Zsh shell 和 Powerlevel10k 主题 |
| git  | `.gitconfig`          | Git 配置                        |
| tmux | `.tmux.conf`          | Tmux 终端复用器配置             |

## 自动安装的依赖

安装 `zsh` 包时，脚本会自动安装：

- [Oh My Zsh](https://ohmyz.sh/) - Zsh 配置框架
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - 强大的 Zsh 主题
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) - 命令自动补全
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - 语法高亮
- [fzf](https://github.com/junegunn/fzf) - 模糊搜索工具

## 快速安装

```bash
# 克隆仓库
git clone git@github.com:Ciusdusk/Dotfiles.git ~/dotfiles

# 运行安装脚本（自动安装所有依赖和配置）
cd ~/dotfiles
./install.sh
```

> ⚠️ **字体提示**: 为了正确显示 Powerlevel10k 图标，请确保你的终端使用 [Nerd Font](https://github.com/romkatv/powerlevel10k#fonts) 字体（推荐 MesloLGS NF）

## 使用方法

```bash
# 完整安装（包括所有依赖和配置）
./install.sh

# 只安装特定的包
./install.sh install vim zsh

# 只安装依赖（不链接配置文件）
./install.sh deps

# 卸载配置
./install.sh uninstall vim

# 查看可用的包
./install.sh list

# 查看帮助
./install.sh help
```

## 工作原理

此配置使用 GNU Stow 创建符号链接。每个子目录（vim、zsh 等）代表一个"包"，运行 stow 时会将包内的文件链接到 `$HOME` 目录。

例如，`vim/.vimrc` 会被链接到 `~/.vimrc`。

## 添加新配置

1. 创建新目录：`mkdir -p ~/dotfiles/新包名`
2. 将配置文件移入：`mv ~/.config_file ~/dotfiles/新包名/`
3. 在 `install.sh` 的 `STOW_PACKAGES` 数组中添加新包名
4. 运行 `./install.sh install 新包名`
