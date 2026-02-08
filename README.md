# Dotfiles

我的个人配置文件，使用 [GNU Stow](https://www.gnu.org/software/stow/) 管理。

## 包含的配置

| 包   | 文件                  | 说明                            |
| ---- | --------------------- | ------------------------------- |
| vim  | `.vimrc`              | Vim 编辑器配置                  |
| zsh  | `.zshrc`, `.p10k.zsh` | Zsh shell 和 Powerlevel10k 主题 |
| git  | `.gitconfig`          | Git 配置                        |
| tmux | `.tmux.conf`          | Tmux 终端复用器配置             |

## 快速安装

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# 运行安装脚本（会自动安装 stow）
cd ~/dotfiles
./install.sh
```

## 使用方法

```bash
# 安装所有配置
./install.sh install

# 只安装特定的包
./install.sh install vim zsh

# 卸载配置
./install.sh uninstall vim

# 查看可用的包
./install.sh list
```

## 工作原理

此配置使用 GNU Stow 创建符号链接。每个子目录（vim、zsh 等）代表一个"包"，运行 stow 时会将包内的文件链接到 `$HOME` 目录。

例如，`vim/.vimrc` 会被链接到 `~/.vimrc`。

## 添加新配置

1. 创建新目录：`mkdir -p ~/dotfiles/新包名`
2. 将配置文件移入：`mv ~/.config_file ~/dotfiles/新包名/`
3. 在 `install.sh` 的 `STOW_PACKAGES` 数组中添加新包名
4. 运行 `./install.sh install 新包名`
