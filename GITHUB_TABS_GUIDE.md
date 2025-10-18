# GitHubリポジトリ完全ガイド (初心者向け)

**作成日**: 2025年10月19日  
**対象リポジトリ**: https://github.com/nuccoss/devspo  
**対象者**: GitHub初心者

---

## 📚 GitHubリポジトリの8つのタブ完全ガイド

このドキュメントでは、GitHubリポジトリの各タブの機能と使い方を初心者向けに解説します。

---

## 1️⃣ **Code** (コード) - プロジェクトの中身

### 機能概要
- **何ができる?**: ファイルやフォルダを見る・編集する
- **役割**: プロジェクトの「本棚」

### 現在の状態 (2025/10/19時点)
- ✅ **7 Commits**: 合計7回の変更が記録されている
- ✅ **1 Branch**: `master`ブランチのみ
- ✅ **最新コミット**: "chore: Reorganize PowerShell scripts and update CHANGELOG"
- ✅ **言語構成**: 
  - AutoHotkey 67.7%
  - PowerShell 26.9%
  - Batchfile 0.4%
  - C 5.0%

### 重要なファイル
```
devspo/
├── キーボード修正スクリプト/     # メインプロジェクト
├── WORKSPACE_STRUCTURE.md      # LLM/Agent向けガイド
├── README.md                   # プロジェクト説明書
├── CHANGELOG.md                # 変更履歴
├── CONTRIBUTING.md             # 貢献ガイド
└── LICENSE.md                  # ライセンス (MIT)
```

### 初心者向けアドバイス
💡 ここがプロジェクトの「本棚」です。すべてのファイルがここに保管されています。

---

## 2️⃣ **Issues** (課題) - バグ報告・機能要望

### 機能概要
- **何ができる?**: バグや新機能のアイデアを管理
- **役割**: 「TODO リスト」や「バグトラッキングシステム」

### 現在の状態
- ❌ **Open: 0** (未解決の課題なし)
- ❌ **Closed: 0** (解決済みの課題なし)

### 使い方
1. 「New issue」ボタンでバグ報告や機能要望を作成
2. タイトルと説明を記入
3. ラベル (bug, enhancement, documentationなど) を付ける
4. 他の人がコメント・議論できる
5. 完了したら「Close」

### 使用例
```markdown
Title: [Bug] K270左Ctrl効かない問題

Description:
## 症状
K270の左Ctrlキーが効かない

## 再現手順
1. スクリプト起動
2. K270左Ctrlを押す
3. 反応しない

## 期待される動作
正常にCtrl操作が効く

## 環境
- OS: Windows 11
- AHK: v2.0.18
```

### 初心者向けアドバイス
💡 「TODO リスト」のようなものです。今は空っぽで問題なし!

---

## 3️⃣ **Pull requests** (プルリクエスト) - コード変更提案

### 機能概要
- **何ができる?**: コード変更の提案・レビュー
- **役割**: 「変更承認フロー」

### 現在の状態
- ❌ **プルリクエストなし**

### 使い方 (チーム開発時)
1. 新しいブランチを作成 (`git checkout -b feature/new-function`)
2. コードを変更・コミット
3. GitHubでPull requestを作成
4. 他の人がレビュー・コメント
5. 承認されたらマージ (`Merge pull request`)

### ワークフロー例
```
master (本番)
  ↑
  │ Pull Request (レビュー待ち)
  │
feature/ki-002-fix (開発ブランチ)
```

### 初心者向けアドバイス
💡 あなたは1人開発者なので、現在は使用していません。チーム開発で重要になります。

---

## 4️⃣ **Actions** (アクション) - 自動化 (CI/CD)

### 機能概要
- **何ができる?**: 自動テスト・デプロイ
- **役割**: 「ロボット助手」

### 現在の状態
- ⚠️ **未設定** (GitHub Actionsが有効化されていない)

### 推奨ワークフロー例

#### 例1: AutoHotkey構文チェック
```yaml
# .github/workflows/ahk-syntax-check.yml
name: AutoHotkey Syntax Check

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  check:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install AutoHotkey
        run: |
          choco install autohotkey -y
      
      - name: Run Syntax Check
        run: |
          AutoHotkey.exe /ErrorStdOut "キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk"
```

#### 例2: PowerShell スクリプト検証
```yaml
# .github/workflows/powershell-test.yml
name: PowerShell Script Test

on: [push, pull_request]

jobs:
  test:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run PSScriptAnalyzer
        shell: pwsh
        run: |
          Install-Module -Name PSScriptAnalyzer -Force
          Invoke-ScriptAnalyzer -Path "キーボード修正スクリプト\PowerShell Scripts\" -Recurse
```

### GitHub推奨テンプレート
- ✅ **C/C++ with Make** (Interceptionライブラリ用)
- ✅ **MSBuild based projects**
- ✅ **Deploy PowerShell app to Azure Functions App**

### 初心者向けアドバイス
💡 「ロボット助手」です。コードをpushすると自動でテストを実行してくれます。v1.0安定後に設定するのがおすすめ!

---

## 5️⃣ **Projects** (プロジェクト) - タスク管理ボード

### 機能概要
- **何ができる?**: カンバン式のタスク管理
- **役割**: 「Trelloのようなボード」

### 現在の状態
- ❌ **プロジェクトなし**

### 使い方
1. 「New project」でボード作成
2. カラムを作成 (例: TODO, In Progress, Done)
3. カード形式でタスク管理
4. ドラッグ&ドロップで移動

### プロジェクトボード例
```
┌─────────────┬─────────────┬─────────────┐
│   TODO      │ In Progress │    Done     │
├─────────────┼─────────────┼─────────────┤
│ KI-001調査  │ v1.0テスト  │ 運用手順作成│
│ GitHub      │             │ フォルダ整理│
│ Actions設定 │             │ README更新  │
└─────────────┴─────────────┴─────────────┘
```

### 初心者向けアドバイス
💡 Trelloのようなボードです。個人開発では必須ではありませんが、大規模プロジェクトで便利!

---

## 6️⃣ **Wiki** (ウィキ) - ドキュメント集

### 機能概要
- **何ができる?**: 詳細なドキュメントを書く
- **役割**: 「取扱説明書」

### 現在の状態
- ❌ **未作成** ("Welcome to the devspo wiki!")

### 推奨コンテンツ
1. **Getting Started** (はじめに)
   - インストール手順
   - 初回セットアップ
   
2. **Troubleshooting** (トラブルシューティング)
   - よくある問題と解決法
   - FAQ
   
3. **Advanced Usage** (高度な使い方)
   - カスタマイズ方法
   - PowerShellスクリプト活用
   
4. **Development Guide** (開発ガイド)
   - ビルド手順
   - テスト方法

### README vs Wiki 使い分け
| README.md | Wiki |
|-----------|------|
| プロジェクト概要 | 詳細なチュートリアル |
| クイックスタート | 段階的な解説 |
| ライセンス情報 | FAQ・Tips集 |
| 1ページ完結 | 複数ページ構成 |

### 初心者向けアドバイス
💡 「取扱説明書」です。現在は`README.md`と`運用手順_20251019.md`があるので、Wikiは任意です。

---

## 7️⃣ **Security** (セキュリティ) - 脆弱性管理

### 機能概要
- **何ができる?**: セキュリティ問題を監視
- **役割**: 「警備システム」

### 現在の状態 (2025/10/19)

#### ✅ 有効化済み
1. **Security policy: Enabled**
   - セキュリティポリシー有効
   - `SECURITY.md`ファイルで脆弱性報告方法を明記

2. **Security advisories: Enabled**
   - セキュリティ勧告有効
   - 脆弱性の公開・非公開通知

3. **Secret scanning: Enabled**
   - シークレットスキャン有効
   - API キー、パスワード、トークンの検出

#### ⚠️ 未設定 (推奨設定)
1. **Code scanning: Needs setup**
   - コードスキャン未設定
   - CodeQLで自動脆弱性検出
   - **推奨**: 「Set up code scanning」をクリックして有効化

2. **Dependabot alerts: Disabled**
   - 依存関係アラート無効
   - npm, pip, nugetパッケージの脆弱性検出
   - **推奨**: 「Enable Dependabot alerts」で有効化

3. **Private vulnerability reporting: Disabled**
   - 非公開脆弱性報告無効
   - セキュリティ研究者が非公開で報告可能
   - **推奨**: パブリックリポジトリでは有効化推奨

### セキュリティスコア
```
現在のスコア: 3/6 (50%)
推奨スコア: 6/6 (100%)

改善手順:
1. Code scanning有効化 → +1
2. Dependabot alerts有効化 → +1
3. Private vulnerability reporting有効化 → +1
```

### 初心者向けアドバイス
💡 「警備システム」です。現在の設定で基本的には安全ですが、3つの追加設定を有効化するとさらに安全になります!

---

## 8️⃣ **Insights** (洞察) - 統計情報

### 機能概要
- **何ができる?**: プロジェクトの活動状況を可視化
- **役割**: 「活動記録」

### 現在の状態 (October 11-18, 2025)

#### サマリー
- 📊 **1 author**: nuccoss (単独開発)
- 📊 **7 commits** to master
- 📊 **7 commits** to all branches
- 📊 **0 files changed** (表示バグの可能性)
- 📊 **0 additions / 0 deletions** (実際は大量の追加あり)

#### Top Committers
```
nuccoss ████████████████████ 10 commits
```

### 利用可能なインサイト
1. **Pulse** (パルス)
   - 週間活動サマリー
   - マージされたPR、クローズされたIssue

2. **Contributors** (貢献者)
   - 貢献者ランキング
   - コミット数グラフ

3. **Community** (コミュニティ)
   - コミュニティ健全性スコア
   - README, LICENSE, CONTRIBUTINGの有無

4. **Traffic** (トラフィック)
   - 訪問者数 (パブリックリポジトリのみ)
   - リファラー、人気コンテンツ

5. **Commits** (コミット)
   - コミット履歴グラフ
   - 時系列での活動

6. **Code frequency** (コード頻度)
   - 追加・削除行数の推移

7. **Dependency graph** (依存関係グラフ)
   - パッケージ依存関係の可視化

8. **Network** (ネットワーク)
   - フォーク・ブランチの関係図

### 初心者向けアドバイス
💡 「活動記録」です。あなたの開発ペースが一目でわかります!

---

## 9️⃣ **Settings** (設定) - リポジトリ管理

### 機能概要
- **何ができる?**: リポジトリの詳細設定
- **役割**: 「管理者パネル」

### 現在の設定

#### General (一般)
- 📛 **Repository name**: `devspo`
- 📝 **Description**: "Professional workspace for emergency system automation and keyboard control solutions (99.2% reliability)"
- 🌐 **Visibility**: Public (公開リポジトリ)
- ❌ **Template repository**: 無効
- ❌ **Require contributors to sign off**: 無効

#### Default branch (デフォルトブランチ)
- 🔄 **Default branch**: `master`
- Pull requestとコードコミットの基準ブランチ

#### Releases (リリース)
- ❌ **Enable release immutability**: 無効
- リリース後のアセット・タグの変更を禁止

#### Social preview (ソーシャルプレビュー)
- 🖼️ **Social image**: 未設定
- 推奨サイズ: 640×320px (1280×640px推奨)

### 重要な設定項目

#### 1. **Branches** (ブランチ)
- ブランチ保護ルール
- マージ前のレビュー必須化
- ステータスチェック必須化

#### 2. **Collaborators** (共同作業者)
- 共同作業者の追加
- アクセス権限の管理 (Read, Write, Admin)

#### 3. **Webhooks** (ウェブフック)
- 外部サービス連携
- イベント通知 (push, pull request, issueなど)

#### 4. **Pages** (GitHub Pages)
- 静的サイト公開
- `gh-pages`ブランチからデプロイ

#### 5. **Secrets and variables** (シークレットと変数)
- 環境変数の暗号化保存
- GitHub Actionsで使用

### 初心者向けアドバイス
💡 「管理者パネル」です。基本的には現状の設定でOKです!

---

## 🎯 初心者向け優先度ガイド

### 🔥 今すぐ使うべき (v1.0完成時点)
1. ✅ **Code**: ファイル管理・コード編集
   - 使用頻度: 毎日
   - 重要度: ★★★★★

2. ✅ **Security**: シークレットスキャン確認
   - 使用頻度: 週1回
   - 重要度: ★★★★☆

3. ✅ **Insights**: 開発活動の可視化
   - 使用頻度: 週1回
   - 重要度: ★★★☆☆

### 🟡 必要に応じて使う
4. **Issues**: バグ発見時・機能要望時
   - 使用頻度: バグ発見時
   - 重要度: ★★★★☆

5. **Settings**: リポジトリ名変更・説明更新
   - 使用頻度: 月1回
   - 重要度: ★★☆☆☆

### 🔵 チーム開発で重要
6. **Pull requests**: コードレビュー
   - 使用頻度: (チーム開発時) 毎日
   - 重要度: (単独開発) ★☆☆☆☆

7. **Actions**: CI/CDパイプライン
   - 使用頻度: 設定後は自動
   - 重要度: ★★★★☆

### 🟢 任意・上級者向け
8. **Projects**: カンバン式タスク管理
   - 使用頻度: (大規模プロジェクト) 毎日
   - 重要度: (個人開発) ★★☆☆☆

9. **Wiki**: 大規模ドキュメント
   - 使用頻度: (ドキュメント重視) 週1回
   - 重要度: (現状) ★☆☆☆☆

---

## 💡 次のステップ提案

### ステップ1: README.mdを充実させる ✅ (完了)
- [x] バッジ追加
- [x] プロジェクト概要更新
- [x] v1.0情報反映

### ステップ2: セキュリティ強化 (推奨)
```
優先度: HIGH

1. Code scanning有効化
   - Settings → Security → Code scanning → Set up code scanning
   - CodeQL Analysisを選択

2. Dependabot alerts有効化
   - Settings → Security → Dependabot alerts → Enable

3. Private vulnerability reporting有効化
   - Settings → Security → Private vulnerability reporting → Enable
```

### ステップ3: GitHub Actions設定 (推奨)
```
優先度: MEDIUM

1. AutoHotkey構文チェック
   - .github/workflows/ahk-syntax-check.yml作成
   - push時に自動実行

2. PowerShellスクリプト検証
   - .github/workflows/powershell-test.yml作成
   - PSScriptAnalyzerで静的解析
```

### ステップ4: Releasesを作成 (任意)
```
優先度: LOW

1. v1.0.0タグ作成
   - git tag -a v1.0.0 -m "Initial stable release"
   - git push origin v1.0.0

2. GitHub Releasesでリリース作成
   - リリースノート記載
   - 実行ファイル配布 (optional)
```

### ステップ5: GitHub Pages公開 (任意)
```
優先度: LOW

1. gh-pagesブランチ作成
2. index.htmlで運用手順を公開
3. Settings → Pages → Source: gh-pages
```

---

## 📊 現在のリポジトリ健全性スコア

### 総合評価 (2025/10/19)

```
✅ Code管理: 100/100
   - ファイル整理完了
   - WORKSPACE_STRUCTURE.md作成
   - README.md充実

✅ ドキュメント: 95/100
   - README.md: ★★★★★
   - CHANGELOG.md: ★★★★★
   - 運用手順_20251019.md: ★★★★★
   - Wiki: ☆☆☆☆☆ (未作成)

✅ セキュリティ: 80/100
   - Security policy: ✅
   - Secret scanning: ✅
   - Code scanning: ⚠️ (未設定)
   - Dependabot: ⚠️ (未設定)

⚠️ 自動化: 0/100
   - GitHub Actions: ❌ (未設定)
   - CI/CD: ❌ (未設定)

⚠️ コミュニティ: 50/100
   - Issues: 0 open / 0 closed
   - Pull requests: 0
   - Contributors: 1
   (※個人開発では正常)

━━━━━━━━━━━━━━━━━━━━━━━━
総合スコア: 325/500 (65%)
評価: B+ (個人開発としては優秀!)
━━━━━━━━━━━━━━━━━━━━━━━━
```

### 改善提案

#### 短期 (1週間以内)
1. Code scanning有効化 → +10点
2. Dependabot alerts有効化 → +10点
3. Private vulnerability reporting有効化 → +5点

**期待スコア**: 350/500 (70%) → A-

#### 中期 (1ヶ月以内)
4. GitHub Actions設定 (AHK構文チェック) → +30点
5. GitHub Actions設定 (PowerShell検証) → +20点
6. Issue作成 (KI-001, KI-002) → +10点

**期待スコア**: 410/500 (82%) → A

#### 長期 (3ヶ月以内)
7. v1.0.0 Release作成 → +20点
8. Wiki作成 (Getting Started, FAQ) → +15点
9. GitHub Pages公開 → +10点

**期待スコア**: 455/500 (91%) → A+

---

## 🔗 参考リンク

### 公式ドキュメント
- [GitHub Docs (日本語)](https://docs.github.com/ja)
- [GitHub Skills](https://skills.github.com/) - 対話型チュートリアル
- [GitHub Actions](https://docs.github.com/ja/actions)
- [GitHub Pages](https://docs.github.com/ja/pages)

### コミュニティ
- [GitHub Community Forum](https://github.com/orgs/community/discussions)
- [GitHub Status](https://www.githubstatus.com/) - サービス稼働状況

### ツール
- [shields.io](https://shields.io/) - バッジ生成
- [GitHub README Stats](https://github.com/anuraghazra/github-readme-stats) - 統計カード生成

---

## 📝 用語集

### よく使う用語

| 用語 | 説明 |
|------|------|
| **Repository (リポジトリ)** | プロジェクトの保管場所 |
| **Commit (コミット)** | 変更の記録単位 |
| **Branch (ブランチ)** | 並行開発の分岐 |
| **Fork (フォーク)** | 他人のリポジトリをコピー |
| **Pull Request (PR)** | 変更の提案 |
| **Issue** | バグ報告・機能要望 |
| **Merge (マージ)** | ブランチの統合 |
| **Clone (クローン)** | リポジトリをローカルにコピー |
| **Push (プッシュ)** | ローカル変更をリモートへ送信 |
| **Pull (プル)** | リモート変更をローカルへ取得 |

### GitHub特有の用語

| 用語 | 説明 |
|------|------|
| **Star (スター)** | お気に入り登録 |
| **Watch (ウォッチ)** | 更新通知を受け取る |
| **Actions** | CI/CD自動化 |
| **Gist** | コードスニペット共有 |
| **Codespace** | クラウドIDE |
| **Copilot** | AIコード補完 |
| **Dependabot** | 依存関係自動更新 |
| **CodeQL** | セキュリティスキャン |

---

## ✅ チェックリスト

### v1.0完成時 (現在)
- [x] リポジトリ作成
- [x] README.md作成
- [x] CHANGELOG.md作成
- [x] LICENSE追加
- [x] SECURITY.md追加
- [x] CONTRIBUTING.md追加
- [x] 運用手順_20251019.md作成
- [x] WORKSPACE_STRUCTURE.md作成
- [x] 7 commits完了

### v1.1準備 (推奨)
- [ ] Code scanning有効化
- [ ] Dependabot alerts有効化
- [ ] Private vulnerability reporting有効化
- [ ] GitHub Actions設定 (AHK構文チェック)
- [ ] GitHub Actions設定 (PowerShell検証)
- [ ] Issue #1作成 (KI-001)
- [ ] Issue #2作成 (KI-002)

### v2.0準備 (任意)
- [ ] v1.0.0 Release作成
- [ ] Wiki作成
- [ ] GitHub Pages公開
- [ ] プロジェクトボード作成
- [ ] 自動テストカバレッジ50%達成

---

## 🎉 おわりに

このガイドを参考に、GitHubリポジトリを最大限に活用してください!

**質問・フィードバック**:
- 📧 GitHubのIssueで質問
- 💬 Discussionsで議論

**ハッピーコーディング!** 🚀

---

**最終更新**: 2025年10月19日  
**作成者**: GitHub Copilot (devspo project)  
**ライセンス**: MIT License
