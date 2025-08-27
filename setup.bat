@echo off
echo =============================================
echo flr2dat ポータブルRuby環境セットアップ
echo =============================================

cd /d "%~dp0"

REM ruby.zipを展開
if exist ruby.zip (
    if not exist ruby\ (
        echo ruby.zip を展開しています...
        powershell -Command "Expand-Archive -Path 'ruby.zip' -DestinationPath '.' -Force"
    ) else (
        echo 既にrubyフォルダが存在するため展開をスキップします。
    )
) else (
    echo ruby.zip が見つかりません。既に展開済みか、ファイルがありません。
)
echo.

REM gemインストール先を設定
set GEM_HOME=%~dp0gems
set GEM_PATH=%~dp0gems

echo gemインストール先: %GEM_HOME%

echo.
echo rubyXL をインストール中...
ruby\bin\gem.cmd install rubyXL --install-dir gems

echo.
echo roo をインストール中...  
ruby\bin\gem.cmd install roo --install-dir gems

echo.
echo nkf をインストール中...
ruby\bin\gem.cmd install nkf --install-dir gems

echo.
echo その他の依存gemをインストール中...
ruby\bin\gem.cmd install nokogiri --install-dir gems
ruby\bin\gem.cmd install zip --install-dir gems

echo.
echo インストール済みgem一覧:
ruby\bin\gem.cmd list --local --install-dir gems

echo.
echo 依存gemをインストール中...
ruby\bin\gem.cmd install bundler
ruby\bin\bundle.bat config set --local path 'vendor/bundle'
ruby\bin\bundle.bat install

if errorlevel 1 (
    echo エラー: gemのインストールに失敗しました。
    echo インターネット接続を確認してください。
    pause
    exit /b 1
)

echo.
echo インストール完了！
pause
