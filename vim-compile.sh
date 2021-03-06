cd ~/vim
./configure --with-features=huge \
--enable-multibyte \
--enable-rubyinterp=yes \
--enable-pythoninterp=yes \
--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
# --enable-python3interp \
# --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
--enable-perlinterp=yes \
--enable-luainterp=yes \
--enable-gui=gtk2 \
--enable-cscope \
--prefix=/usr/local
make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
