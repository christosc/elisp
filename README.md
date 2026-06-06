# Various Emacs Lisp scripts.

* emacs.d/init.el: Emacs initialization settings.
* macgreek.el:  An Emacs input method mimicking the Mac's one for inputting polytonic Greek.

## INSTALLATION:
 Add to your .emacs.d/init.el file the following:
 1. Clone within e.g. ~/.emacs.d/elisp.
 2. Add to init.el the following:
    (add-to-list 'load-path "~/.emacs.d/elisp")
    (require 'mac-greek)
    (setq default-input-method "mac-greek")
 3. Then you can switch between the input methods with C-\ .

## Emacs installation

As of Emacs 31 (from master branch) the build I make is configured like this:

```
  $ ./configure --prefix=/data/chryssoc --without-x --with-native-compilation=aot --enable-link-time-optimization --without-compress-install --disable-gc-mark-trace --with-tree-sitter
```

On WSL I needed more elaborate configuration:

```
PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig  ./configure   --prefix=$HOME/.local/emacs-31 CPPFLAGS="-I$HOME/.local/include" LDFLAGS="-L$HOME/.local/lib" --without-x \
                                            --with-native-compilation=aot --enable-link-time-optimization --without-compress-install --disable-gc-mark-trace --with-tree-sitter
```