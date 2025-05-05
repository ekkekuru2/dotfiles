#!/bin/sh
set -eu # エラー発生時,未定義変数で終了

#if [ $(id -u) -ne 0 ]; then
#    echo "***Please run as root***"
#    exit 1
#fi

DOT_DIR="$HOME/dotfiles"
cd $HOME
# dotfilesリポジトリがクローンされているか
if [ ! -d ${DOT_DIR} ]; then
    echo "~/dotfiles not found"
    if type git > /dev/null 2>&1; then # gitが存在すれば
        git clone https://github.com/ekkekuru2/dotfiles.git
    else
	# gitを使わずcurlとかで落としてくる例もあったので余裕があれば書く
        echo "git required!"
        exit 1
    fi
fi

# aptやpackman,yum等のパッケージマネージャーでインストールすべきパッケージをインストール
# もしDebianベースのOSなら
# aptを使う
#if [ cat /etc/os-
#while read line # 1行ずつ読む
#do
#    apt install $line
#done < $DOT_DIR/apt.txt

# homeディレクトリ以下の内容を$HOMEにリンク
# 存在する場合はmv .old
cd 
for f in *
do
    if [ -e $HOME/$f ]; then
        mv $HOME/$f $HOME/$f.old
    fi

    ln -snf $DOT_DIR/$f $HOME/$f
    echo "Succesfully installed $f !"
done



