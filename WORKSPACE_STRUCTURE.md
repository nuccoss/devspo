# devspo Workspace Structure

**作成日**: 2025年10月19日  
**目的**: LLM/Agent向けプロジェクト構造理解ドキュメント

---

## 📂 プロジェクト概要

**devspo** = Development Spoファイル管理・キーボード修正スクリプトワークスペース

### 主要プロジェクト
1. **キーボード修正スクリプト** (MSI内蔵キーボードLeft Ctrl無効化)
2. **Interception** (低レベルキーボード/マウスドライバ)
3. **Backup** (過去のスクリプトバックアップ)

---

## 🗂️ ディレクトリ構造

```
devspo/
├── 📁 キーボード修正スクリプト/       【メインプロジェクト】MSI内蔵KB Left Ctrl無効化
│   ├── SelectiveLeftCtrlBlocker.ahk  ⭐ メインスクリプト (AutoHotkey v2.0)
│   ├── README.md                      📄 プロジェクト説明
│   ├── CHANGELOG.md                   📄 変更履歴
│   ├── TROUBLESHOOTING.md             📄 トラブルシューティング
│   ├── 運用手順_20251019.md           📄 運用マニュアル (最新)
│   ├── LICENSE                        📄 MITライセンス
│   │
│   ├── 📁 Lib/                        【ライブラリ】AutoHotkey依存ファイル
│   │   ├── AutoHotInterception.ahk
│   │   ├── CLR.ahk
│   │   ├── Unblocker.ps1
│   │   ├── x64/                       (64bit DLL)
│   │   └── x86/                       (32bit DLL)
│   │
│   ├── 📁 AHK v1/                     【アーカイブ】AutoHotkey v1サンプル
│   ├── 📁 AHK v2/                     【アーカイブ】AutoHotkey v2サンプル
│   ├── 📁 Common/                     【共通】共有ライブラリ
│   │
│   ├── 📁 TestSessions/               【テストログ】Phase別テスト記録
│   │   └── 20251018/                  (2025年10月18日テスト)
│   │
│   ├── 📁 PowerShell Scripts/         【自動化】テスト・設定スクリプト
│   │   ├── RecordTestSession.ps1     (テスト記録自動化)
│   │   ├── CompleteSetup.ps1         (初回セットアップ)
│   │   ├── CreateWakeUpTask.ps1      (タスクスケジューラ登録)
│   │   ├── RegisterAutoInitialization.ps1
│   │   ├── OptimizePowerSettings.ps1
│   │   ├── LockScreenProtection.ps1
│   │   └── TestRecoveryProcedure.ps1
│   │
│   └── 📁 Diagnostic Logs/            【診断】ハードウェアショート診断ログ
│       ├── DiagnosticLog_20251018_*.txt
│       └── DiagnosticLog_20251019_*.txt
│
├── 📁 Interception/                   【ドライバ】低レベル入力インターセプト
│   ├── 📁 command line installer/     (CLIインストーラー)
│   ├── 📁 library/                    (C/C++ライブラリ)
│   │   ├── interception.h
│   │   ├── x64/
│   │   └── x86/
│   ├── 📁 licenses/                   (ライセンス情報)
│   ├── 📁 samples/                    (サンプルコード)
│   └── 📁 arksystem boot/             (ArkSystemブート戦略分析)
│
├── 📁 Backup_KeyboardFix_20250930_150222/  【バックアップ】2025年9月30日時点
│   ├── AutoHotInterception.ahk
│   ├── DisableLaptopLeftCtrl_Enhanced.ahk
│   ├── SelectiveLeftCtrlBlocker.ahk
│   ├── CHANGELOG.md
│   ├── README.md
│   ├── TROUBLESHOOTING.md
│   ├── 📁 AHK v1/
│   ├── 📁 AHK v2/
│   ├── 📁 Common/
│   └── 📁 Lib/
│
├── 📁 .agent/                         【Agent】LLM/Agent作業記録
│   └── workflows/
│       ├── setup.workflow.md
│       ├── troubleshooting.workflow.md
│       └── maintenance.workflow.md
│
├── 📁 .archive/                       【アーカイブ】過去の検証記録
│   └── 2025-10-17/
│       ├── verification-report.md
│       └── phase4-verification-report.md
│
├── 📄 README.md                       ⭐ プロジェクトルートREADME
├── 📄 CHANGELOG.md                    📄 全体変更履歴
├── 📄 CONTRIBUTING.md                 📄 貢献ガイドライン
├── 📄 LICENSE.md                      📄 MITライセンス
├── 📄 SECURITY.md                     📄 セキュリティポリシー
├── 📄 GITHUB_SETUP_GUIDE.md           📄 GitHubセットアップガイド
├── 📄 github-setup.md                 📄 GitHub詳細設定
├── 📄 workspace-structure-analysis.md 📄 ワークスペース構造分析
├── 📄 SystemInstructions.md           📄 システム指示書
├── 📄 AgentDescriptions.json          📄 エージェント定義
├── 📄 .gitignore                      📄 Git除外設定
└── 📄 .gitattributes                  📄 Git属性設定
```

---

## 📋 主要ファイル説明

### ⭐ 最重要ファイル

| ファイル | 説明 | 更新頻度 |
|---------|------|---------|
| `キーボード修正スクリプト/SelectiveLeftCtrlBlocker.ahk` | メインスクリプト | 高 |
| `キーボード修正スクリプト/運用手順_20251019.md` | 運用マニュアル | 中 |
| `README.md` | プロジェクト概要 | 低 |
| `CHANGELOG.md` | 変更履歴 | 高 |

### 📄 ドキュメント分類

#### プロジェクト管理
- `README.md` - プロジェクト全体説明
- `CHANGELOG.md` - 変更履歴 (全体)
- `CONTRIBUTING.md` - 貢献ガイドライン
- `LICENSE.md` - MITライセンス
- `SECURITY.md` - セキュリティポリシー

#### 技術文書
- `キーボード修正スクリプト/README.md` - スクリプト詳細
- `キーボード修正スクリプト/TROUBLESHOOTING.md` - トラブルシューティング
- `キーボード修正スクリプト/運用手順_20251019.md` - 運用マニュアル

#### GitHub関連
- `GITHUB_SETUP_GUIDE.md` - GitHub初回セットアップ
- `github-setup.md` - GitHub詳細設定

#### Agent/LLM向け
- `workspace-structure-analysis.md` - ワークスペース構造分析
- `SystemInstructions.md` - システム指示書
- `AgentDescriptions.json` - エージェント定義

---

## 🎯 プロジェクト別作業ガイド

### 1. キーボード修正スクリプト

**ディレクトリ**: `キーボード修正スクリプト/`

#### 主要タスク
- スクリプト修正: `SelectiveLeftCtrlBlocker.ahk`
- テスト実行: PowerShellスクリプト群
- ログ確認: `Diagnostic Logs/`

#### 開発フロー
```
1. SelectiveLeftCtrlBlocker.ahk 編集
2. スクリプト再起動
3. 統計情報確認 (トレイメニュー)
4. 診断ログ出力 (必要時)
5. CHANGELOG.md 更新
6. Git commit
```

### 2. Interception ドライバ

**ディレクトリ**: `Interception/`

#### 用途
- 低レベルキーボード/マウス入力インターセプト
- Raw Input API補完
- 現在は直接使用せず (参照用)

### 3. バックアップ

**ディレクトリ**: `Backup_KeyboardFix_20250930_150222/`

#### 用途
- 過去のスクリプトバージョン保管
- ロールバック時の参照
- 比較検証

---

## 🔄 Git ワークフロー

### ブランチ戦略
- `master` - 本番安定版
- `develop` - 開発版 (存在する場合)
- `feature/*` - 機能追加 (存在する場合)

### Commit メッセージ形式
```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

**Types**:
- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメント変更
- `style`: コードフォーマット
- `refactor`: リファクタリング
- `test`: テスト追加
- `chore`: ビルド・設定変更

**例**:
```
feat(ahk): Add manual reset guide on startup
fix(ahk): Resolve hotkey warning dialog issue
docs: Update operation manual with test results
```

---

## 🧪 テスト環境

### ハードウェア
- **PC**: MSI Laptop (内蔵キーボード Left Ctrl 物理破損)
- **外部KB**: Logitech K270 Bluetooth (VID_046D)

### ソフトウェア
- **OS**: Windows 10/11
- **AutoHotkey**: v2.0.18
- **PowerShell**: 5.1+

### テスト手順
1. Phase 1: ベースライン (正常状態)
2. Phase 2: ショート発生確認
3. Phase 3: 手動リセット実行

---

## 📊 診断ログ命名規則

### ファイル名形式
```
DiagnosticLog_YYYYMMDD_HHMMSS.txt
```

### 例
```
DiagnosticLog_20251019_143520.txt
```

### 保存場所
```
キーボード修正スクリプト/Diagnostic Logs/
```

---

## 🔍 検索・ナビゲーション

### よく使うファイルパス

#### スクリプト本体
```
C:\devspo\キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk
```

#### 運用マニュアル
```
C:\devspo\キーボード修正スクリプト\運用手順_20251019.md
```

#### 診断ログ
```
C:\devspo\キーボード修正スクリプト\Diagnostic Logs\
```

#### テスト記録
```
C:\devspo\キーボード修正スクリプト\TestSessions\20251018\
```

---

## 🆘 トラブルシューティング早見表

| 症状 | 確認ファイル | 対処 |
|------|------------|------|
| スクリプトエラー | `SelectiveLeftCtrlBlocker.ahk` | 構文確認、再起動 |
| K270動作不良 | 統計情報 (トレイメニュー) | 手動リセット実行 |
| ショート検出失敗 | 診断ログ | 高速連続信号確認 |
| 設定不明 | `運用手順_20251019.md` | マニュアル参照 |

---

## 📝 更新履歴

- **2025/10/19**: 初版作成 (v1.0)
  - キーボード修正スクリプト完成
  - 手動リセット方式確定
  - テスト完了 (Phase 1-2)

---

## 📞 関連リンク

- **GitHub Repository**: https://github.com/nuccoss/devspo
- **AutoHotkey v2.0**: https://www.autohotkey.com/v2/
- **Interception**: http://www.oblita.com/interception.html

---

**最終更新**: 2025年10月19日  
**管理者**: GitHub Copilot (devspo project)
