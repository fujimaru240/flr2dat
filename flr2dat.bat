@echo off
setlocal

REM スクリプトのディレクトリに移動
cd /d "%~dp0"

REM ポータブルRubyのパスを設定
set PATH=%~dp0ruby\bin;%PATH%
set GEM_HOME=%~dp0vendor\bundle\ruby\3.2.0
set GEM_PATH=%~dp0vendor\bundle\ruby\3.2.0
set BUNDLE_GEMFILE=%~dp0Gemfile

REM Rubyの存在チェック
if not exist "ruby\bin\ruby.exe" (
    echo エラー: ruby\bin\ruby.exe が見つかりません。
    echo ポータブルRubyが正しく配置されているか確認してください。
    pause
    exit /b 1
)

REM 必要なgemがインストールされているかチェック
echo 依存関係を確認中...
ruby\bin\ruby.exe -e "require 'rubyXL'" 2>nul
if errorlevel 1 (
    echo rubyXL gemが見つかりません。gemをインストール中...
    ruby\bin\gem.cmd install rubyXL --install-dir vendor\bundle\ruby\3.2.0
)

echo スクリプトを実行中...
REM メインスクリプトを実行
ruby\bin\ruby.exe main_v2.rb %*

if errorlevel 1 (
    echo エラーが発生しました。
    pause
) else (
    echo 処理が完了しました。
    if "%1"=="" pause
)

endlocal
