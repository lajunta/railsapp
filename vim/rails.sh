pushd ~/.vim/bundle; \
git clone git://github.com/slim-template/vim-slim.git; \
popd

cd ~/.vim/bundle
git clone https://github.com/tpope/vim-rails.git
vim -u NONE -c "helptags vim-rails/doc" -c q
