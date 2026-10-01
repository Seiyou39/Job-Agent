# Job Agent

求人票（JD）と自分の履歴書を Claude に読ませて、マッチ度・強み・不足スキル・想定質問・対策 ToDo をまとめて出してくれる就活支援 Web アプリです。勤務地が東京都内なら、その区市の家賃相場の予測もあわせて表示します。

## 主な機能

- **ユーザー登録 / ログイン**：Rails 8 標準の認証（`has_secure_password`）。パスワードリセット対応。
- **履歴書の登録**：プロフィール画面で履歴書テキストを保存しておき、分析のたびに使い回す。
- **JD 分析**：求人票を貼り付けると、Claude API（tool use で構造化出力）が次の項目を返す。
  - 企業名・職種名・勤務地（東京の区市）
  - マッチ度（0〜100）と総合アドバイス
  - アピールできる強み / 不足しているスキル
  - 想定される面接質問
  - 優先度付きの対策 ToDo リスト
- **ToDo 管理**：分析結果から自動生成された ToDo リストを、チェック・編集・追加できる。手動でリストを作ることも可能。
- **家賃予測**：勤務地の区市をもとに、別プロジェクトの [Tokyo Rent Predictor](https://tokyo-rent-predictor-app.onrender.com) API で 1K の家賃目安を取得して表示。
- **ダッシュボード**：過去の分析と ToDo リストを一覧で確認。
- **権限**：`admin` / `reviewer` の 2 ロール。ユーザー管理画面は admin のみ。

## 技術スタック

| 分類 | 使用技術 |
| --- | --- |
| 言語 / FW | Ruby 4.0.5 / Rails 8.1 |
| DB | SQLite3 |
| フロント | Hotwire（Turbo, Stimulus）, Importmap, Propshaft |
| バックグラウンド等 | Solid Queue / Solid Cache / Solid Cable |
| 外部 API | Anthropic Claude API（`claude-sonnet-4-5`）, Tokyo Rent Predictor API |
| デプロイ | Docker, Kamal, Thruster |
| CI | GitHub Actions（Brakeman, bundler-audit, RuboCop, テスト） |

## 構成

```
app/
├── controllers/
│   ├── analyses_controller.rb     # JD 分析の作成・表示・削除
│   ├── dashboard_controller.rb    # トップページ
│   ├── profiles_controller.rb     # 履歴書の編集
│   ├── todo_lists_controller.rb
│   └── todos_controller.rb
├── models/
│   ├── analysis.rb                # 分析結果（勤務地の区市マッピングを含む）
│   ├── todo_list.rb / todo.rb
│   └── user.rb
└── services/
    ├── claude_matcher_service.rb  # Claude API 呼び出し（tool use で JSON を受け取る）
    └── rent_predictor_service.rb  # 家賃予測 API 呼び出し
```

### 分析の流れ

1. ユーザーが JD を貼り付けて送信
2. `ClaudeMatcherService` が JD と保存済みの履歴書をプロンプトにまとめ、`submit_analysis` ツールの呼び出しを強制（`tool_choice`）して構造化データを受け取る
3. JD 内の指示文を無視するようプロンプトで明示し、プロンプトインジェクションを抑える
4. 分析結果・ToDo リスト・ToDo をトランザクション内でまとめて保存
5. 結果画面で勤務地が東京都内の区市なら `RentPredictorService` で家賃を予測（API が落ちていても画面は表示される）

## セットアップ

### 必要なもの

- Ruby 4.0.5
- SQLite3
- Anthropic API キー

### 手順

```bash
git clone https://github.com/Seiyou39/job_agent.git
cd job_agent
bundle install
bin/rails db:prepare
```

API キーを環境変数に設定します。

```bash
# macOS / Linux
export ANTHROPIC_API_KEY=sk-ant-xxxx

# Windows (PowerShell)
$env:ANTHROPIC_API_KEY = "sk-ant-xxxx"
```

Anthropic 互換 API（DeepSeek など）を使う場合は、接続先とモデルも指定できます。

```powershell
$env:ANTHROPIC_BASE_URL = "https://api.deepseek.com/anthropic"
$env:ANTHROPIC_MODEL = "deepseek-chat"
```

起動：

```bash
bin/dev
```

http://localhost:3000 を開き、ユーザー登録 → プロフィールで履歴書を保存 → 「分析」から JD を貼り付けて使います。

### admin ユーザーを作る

新規登録したユーザーは `reviewer` になります。admin にしたい場合は Rails コンソールで変更してください。

```bash
bin/rails console
User.find_by(email_address: "you@example.com").update!(role: "admin")
```

## テスト・静的解析

```bash
bin/rails test        # テスト
bin/rubocop           # Lint
bin/brakeman          # セキュリティ静的解析
bin/bundler-audit     # gem の脆弱性チェック
```

## デプロイ

Kamal 用の設定（`config/deploy.yml`）と `Dockerfile` を同梱しています。サーバーの IP とレジストリを書き換えたうえで、`RAILS_MASTER_KEY` と `ANTHROPIC_API_KEY` を環境変数として渡してください。

```bash
bin/kamal setup
bin/kamal deploy
```

## 注意

- `config/master.key` と `.env*` は `.gitignore` で除外しています。コミットしないでください。
- 履歴書と JD の内容は Anthropic API に送信されます。
