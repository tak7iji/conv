### Windows上での実行方法

1. rubyinstaller（http://rubyinstaller.org/ ）を利用してRubyをインストール
2. 1．でインストールしたRubyバージョンに対応するDevKitをインストール（http://rubyinstaller.org/downloads/ ）
3. mingw-get-setup.exeをダウンロードしてインストール（http://sourceforge.net/projects/mingw/files/Installer/ ）
4. インストールしたmingw-getを利用してmsys-zipをインストール
5. 2．でインストールしたDevKitのインストールディレクトリ直下にあるdevkitvars.batのPATH環境変数に、「;%RI_DEVKIT%msys\1.0\bin」を追加
6. 「Ruby コマンドプロンプトを開く」でコマンドプロンプトを起動
7. gem install conv-x.y.z.gemでgemをインストール
8. 6．で起動したコマンドプロンプト上でdevkitvars.batを実行
9. convを実行
