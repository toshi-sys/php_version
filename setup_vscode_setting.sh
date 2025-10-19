set -e

### ローカル環境のVSCODEにWslのPHPコンテナパスを通す ###

# ★ ↓ 各ローカル環境に合わせてsettings.jsonパスを設定
# ★ ↓ WSL環境のsettings.jsonパスを設定。PCローカルのsettings.jsonとは違うので注意！
SETTING_FILE=$HOME"/.vscode-server/data/Machine/settings.json"
# ★ ↓ 本プロジェクトのphp.shファイルパスを設定
PHP_PATH=$(pwd)'/php.sh'

# wsl用settings.jsonがない場合は生成
if [ ! -e $SETTING_FILE ]; then
  mkdir -p ~/.vscode-server/data/Machine
  echo '{}' > "$SETTING_FILE"
  echo "settings.json file created."
fi

# 一時ファイル
TMP_FILE="settings.tmp.json"
# バックアップ作成
cp "$SETTING_FILE" "${SETTING_FILE}.$(date +"%Y%m%d")"

# jqがなければインストール
if ! command -v jq &> /dev/null; then
  sudo apt -y update
  sudo apt -y install jq
  echo "jq installed"
fi

# jqでsettings.jsonを編集
jq \
  --arg newPath "$PHP_PATH" \
  '.["php.validate.enable"] = "true" |
   .["php.validate.executablePath"] = $newPath |
   .["php.debug.executablePath"] = $newPath' \
  "$SETTING_FILE" > "$TMP_FILE" && mv "$TMP_FILE" "$SETTING_FILE"

# エラーチェック
if [ $? -ne 0 ]; then
  echo "Error: jq command failed."
  exit 1
fi