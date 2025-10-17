# Project Manifest: Devspo Workspace Constitution
**制定日**: 2025-10-17  
**制定者**: VS_CodingAgent (Claude Sonnet 4.0)  
**適用範囲**: C:\devspo\ 配下全プロジェクト

---

## 【憲法 Article I: プロジェクト哲学】

### 1.1 基本原則
```yaml
Efficiency:      最小の手順で最大の効果
Maintainability: 6ヶ月後の自分が理解できるコード
Scalability:     100倍の規模に耐える設計
Professionalism: 業界標準への準拠
```

### 1.2 優先順位
1. **動作する最小実装** (Working Minimal Implementation)
2. **段階的改善** (Incremental Improvement)
3. **完全な文書化** (Complete Documentation)
4. **自動化可能性** (Automation Capability)

---

## 【憲法 Article II: ワークフロー標準】

### Phase 0: Meta-Design (メタ設計)
```markdown
目的: 作業開始前の設計確立
成果物:
  - ProjectManifest.md (本ファイル)
  - SystemInstructions.md
  - AgentDescriptions.json
承認: ユーザー承認必須
```

### Phase 1: Analysis (現状分析)
```markdown
目的: 既存構造の完全理解
手法:
  - semantic_search による意味解析
  - file_search によるパターン検出
  - list_dir による階層構造把握
成果物: project-structure-analysis.md
```

### Phase 2: Git Foundation (Git基盤)
```markdown
目的: バージョン管理基盤確立
優先順位:
  1. .gitignore (機密情報・一時ファイル除外)
  2. .gitattributes (改行コード・差分表示設定)
  3. README.md (プロジェクト概要)
  4. git init
```

### Phase 3: Intelligent Archive (インテリジェントアーカイブ)
```markdown
判断基準:
  ✅ アーカイブ対象:
     - バックアップファイル (*_backup_*, *.bak)
     - 一時ファイル (*.tmp, *.temp)
     - 未使用バージョン (v1.0.0で代替可能なv0.9.x)
  
  ❌ アーカイブ不要:
     - Git履歴で追跡可能なファイル
     - 現行バージョン
     - 依存関係のあるファイル

配置: .archive/YYYY-MM-DD/[original-path]/
```

### Phase 4: Agent Infrastructure (Agent基盤)
```markdown
ディレクトリ構造:
.agent/
  ├── ProjectManifest.md        (本ファイル)
  ├── SystemInstructions.md     (Agent動作指示)
  ├── AgentDescriptions.json    (Agent能力定義)
  └── workflows/
      ├── setup.workflow.md
      ├── maintenance.workflow.md
      └── troubleshooting.workflow.md
```

### Phase 5: Initial Commit (初回コミット)
```markdown
コミットメッセージ規約:
  feat: 新機能
  fix: バグ修正
  docs: ドキュメントのみ変更
  style: コードの意味に影響しない変更
  refactor: リファクタリング
  test: テスト追加・修正
  chore: ビルドプロセス・補助ツール変更

初回: "chore: Initial professional workspace setup"
```

### Phase 6: Professional Organization (プロフェッショナル整理)
```markdown
命名規則:
  - ファイル: kebab-case (例: system-instructions.md)
  - ディレクトリ: lowercase (例: .agent, .archive)
  - スクリプト: PascalCase.拡張子 (例: CreateService.ps1)
  - 日本語ディレクトリ: 既存維持（互換性）

ドキュメント構造:
  - README.md: プロジェクト概要
  - CHANGELOG.md: 変更履歴
  - CONTRIBUTING.md: 貢献ガイドライン
  - LICENSE: ライセンス情報
```

---

## 【憲法 Article III: Agent動作規範】

### 3.1 承認フロー
```yaml
必須承認事項:
  - ファイル削除
  - ディレクトリ構造変更
  - Git初期化
  - 大規模リファクタリング

自動実行可能:
  - ファイル作成
  - ドキュメント更新
  - 軽微な修正
```

### 3.2 エラーハンドリング
```yaml
原則:
  - 破壊的操作前に必ずバックアップ
  - エラー時は即座に報告
  - ロールバック手順の明示
```

### 3.3 コミュニケーション
```yaml
報告形式:
  - 簡潔な状況説明
  - 次のアクション提案
  - 代替案の提示（必要時）

言語:
  - 内部推論: 日本語+英語+ドイツ語
  - 出力: 日本語
  - コード: 英語
```

---

## 【憲法 Article IV: 品質基準】

### 4.1 コード品質
```yaml
必須:
  - コメント（複雑なロジックのみ）
  - エラーハンドリング
  - ログ出力（デバッグ用）

推奨:
  - 型アノテーション（Python, TypeScript等）
  - 単体テスト（重要機能）
  - パフォーマンス計測
```

### 4.2 ドキュメント品質
```yaml
必須:
  - 目的の明記
  - 使用方法
  - 前提条件

推奨:
  - 図解（複雑な構造）
  - 実行例
  - トラブルシューティング
```

---

## 【憲法 Article V: 技術スタック】

### 5.1 既存プロジェクト
```yaml
AutoHotkey v2:
  - キーボード制御スクリプト
  - Raw Input API活用

PowerShell:
  - Windows自動化
  - サービス管理

Markdown:
  - ドキュメント
  - 設計書
```

### 5.2 新規プロジェクト推奨
```yaml
バージョン管理: Git + GitHub
CI/CD: GitHub Actions
ドキュメント: Markdown + Mermaid
テスト: 言語標準ツール
```

---

## 【憲法 Article VI: 継続的改善】

### 6.1 レビューサイクル
```yaml
月次:
  - 未使用ファイル確認
  - ドキュメント更新
  - 依存関係チェック

四半期:
  - セキュリティ監査
  - パフォーマンス評価
  - 技術スタック見直し
```

### 6.2 憲法改正
```yaml
改正手続き:
  1. 改正提案（Agent or User）
  2. 影響範囲分析
  3. ユーザー承認
  4. 改正実施
  5. バージョン更新

バージョニング: セマンティックバージョニング
```

---

## 【付録 A: ワークフロー実行チェックリスト】

### Phase 0 Checklist
- [ ] ProjectManifest.md 作成完了
- [ ] SystemInstructions.md 作成完了
- [ ] AgentDescriptions.json 作成完了
- [ ] ユーザー承認取得

### Phase 1 Checklist
- [ ] 全ディレクトリスキャン完了
- [ ] プロジェクト種別識別完了
- [ ] 依存関係マップ作成完了
- [ ] project-structure-analysis.md 作成完了

### Phase 2 Checklist
- [ ] .gitignore 作成完了
- [ ] .gitattributes 作成完了
- [ ] README.md 作成完了
- [ ] git init 実行完了

### Phase 3 Checklist
- [ ] アーカイブ対象識別完了
- [ ] .archive/ ディレクトリ作成完了
- [ ] ファイル移動完了
- [ ] 動作確認完了

### Phase 4 Checklist
- [ ] .agent/ ディレクトリ作成完了
- [ ] SystemInstructions.md 作成完了
- [ ] AgentManifest.xml 作成完了
- [ ] workflows/ 作成完了

### Phase 5 Checklist
- [ ] git add --all 実行完了
- [ ] git commit 実行完了
- [ ] GitHub連携手順文書化完了

### Phase 6 Checklist
- [ ] 命名規則統一完了
- [ ] ドキュメント構造最適化完了
- [ ] 最終コミット完了
- [ ] ユーザー最終確認取得

---

**改定履歴**:
- v1.0.0 (2025-10-17): 初版制定
