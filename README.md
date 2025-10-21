# php_version


## ■プロジェクト概要
PHPバージョンの異なるDockerコンテナを起動し、phpプログラムの動作確認をバージョン別に確認できる環境を構築する。


## ■動作環境
各PHPバージョンのコンテナはWSL上で起動する。
動作確認するPHPプログラムはVSCodeで実行されることを想定する。


## ■使用方法

### 1.動作環境の構築
ルートパスの「setup_multi_containers.sh」を実行して、WSLに各PHPバージョンのコンテナを起動する。
起動するコンテナは、/docker配下に各PHPのバージョンに対応したDockerfileを作成済み。
実際の実行コマンドは以下。  

`bash setup_multi_containers.sh`

### 2.VSCodeのsetting.json作成・更新
VSCodeの拡張機能パッケージ「PHP IntelliSense」を使用してXdebugやPHP構文チェックを行う場合のみ必要な作業。
WSLに配置されたVSCodeの設定ファイルsetting.jsonに、php.shのパスを通す。

`bash setup_vscode_setting.sh`

### 3.PHPプログラム実行
VSCodeのコマンドパレットから設定済みのタスクを呼び出し、プログラムを実行する。
VSCodeのターミナルに実行結果が出力される。
具体的な手順は以下。

#### 3-1.
VSCodeで実行するphpプログラムを開く 
#### 3-2.
VSCodeで 「Ctrl+Shift+P」 を押して 「Tasks: Run Task」 を選択
#### 3-3.
「Run with PHP 7.4」 など、実行するバージョンのタスクを選択


## ■拡張について
### PHPコンテナ
別バージョンのPHPを試したい場合には、以下を拡張する。
- Dockerfile_PHPX.X  
  /docker配下にDockerfileを作成する。  
  ファイル名はDockerfile_PHPX.Xとし、X.Xには実装するPHPバージョンを記載する。本ファイルは、のちに記述するcompose.ymlで呼び出される。

- compose.yml  
  /docker配下のcompose.ymlに上で作成したDockerfile_PHPX.Xを呼び出すサービスを追記する。    

  追記例
  ```
  # ----------------------------------------
  # PHP-FPM 7.0 コンテナ
  # ----------------------------------------
  php70:
    build:
      context: .
      dockerfile: Dockerfile_PHP7.0
    container_name: php70
    volumes:
      - ../src:/app:delegated
    environment:
      # PHP-FPM プロセス数など調整可能
      PHP_UPLOAD_MAX_FILESIZE: 20M
      PHP_POST_MAX_SIZE: 20M
    networks:
      - myapp_network
  ```
- tasks.json  
  /.vscode/tasks.jsonに2-3.で選択するタスクを追記する。  

  追記例
  ```
      {
      "label": "Run with PHP 7.0",
      "type": "shell",
      "command": "bash",
      "args": [
        "-c",
        "docker exec --user $(id -u):$(id -g) php70 php /app/$(basename '${file}')"
      ],
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      },
      "problemMatcher": []
    },
  ```

### PHPプログラム
動作確認したいPHPプログラムを追加したい場合には、以下を拡張する。
- PHPプログラム  
  /src配下に動作確認したいPHPプログラムを実装する。  
  本プログラムは、PHPコンテナ起動時（使用方法1）に、各コンテナの/app配下にマウントされる。共通クラスを実装したい場合は、/src/util配下に実装し、呼び出す。

## ■ディレクトリ構成
```
PHP_VERSION  
│  
├── /.vscode  
│     ├── launch.json  
│     └── tasks.json  
├── /docker  
│     ├── compose.yml(setup.shで生成)  
│     ├── Dockerfile_PHP7.0  
│     ├── Dockerfile_PHP7.4  
│     ├── Dockerfile_PHP8.0  
│     ├── Dockerfile_PHP8.2  
│     ├── xdebug.ini(setup.shで生成)  
│     └── ... (拡張したいコンテナDockerfile作成)    
├── /src  
│     ├── /util  
│     │    └── Common.php  
│     ├── Test.php  
│     ├── Test6_1.php  
│     └── .... (動作確認したいPHPプログラム実装)    
│  
├── php_run_tasks.sh (タスク実行シェル、tasks.jsonに呼ばれる)  
├── php.sh (phpパス、setting.jsonに呼ばれる　※効いてる？)
├── README.md  
├── rm.sh (コンテナ一括削除)  
├── setup_containers.sh (コンテナ一括生成)  
├── setup_vscode_setting.sh (vscode setting.jsonファイル作成・更新)  
└── start_containers.sh (停止中のコンテナ一括起動)  
```

  
## ■その他

### VSCode拡張機能について
- PHP IntelephenseとPHP IntelliSense

|拡張機能パッケージ|主な機能|強み|setting.jsonの設定|本プロジェクト推奨|
|:---|:---|:---|:---|:---:|
|PHP Intelephense|高速な補完、型推論、定義ジャンプ、リファレンス検索など|高速な補完・型推論|未使用||
|PHP IntelliSense|PHPの構文チェック、補完、定義ジャンプ（PHP実行ファイル依存）|コンテナPHPで構文チェック|php.validate.executablePath|〇|

※両方インストールすると、機能が競合することがあるので片方を無効化推奨


### VSCode環境ファイルについて
- setting.json  
WSL環境にて適用されるsetting.jsonファイルは以下  
/{HOME}/.vscode-server/data/Machine/setting.json  
※ホスト環境の{HOME}/.vscode/setting.jsonではないので注意  

- setting.json設定内容  
  "php.validate.enable": true,  
  "php.validate.executablePath": "{プロジェクトルートパス}/php_version/php.sh",  
  "php.debug.executablePath": "{プロジェクトルートパス}/php_version/php.sh",  
  


以上。