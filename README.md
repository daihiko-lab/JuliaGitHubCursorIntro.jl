# julia-github-intro-2026

ゼミ（社会心理学研究室）向けの **Julia / Git / GitHub / Cursor** 導入会（約2時間）用教材リポジトリです。架空データを使った Julia の入門演習と、全員で **ブランチ → コミット → push → プルリクエスト（PR）** まで体験する課題を含みます。

## このリポジトリについて

- **オーナー**: [daihiko-lab](https://github.com/daihiko-lab)（山本）
- **参加者**: オーナーから **このリポジトリのコラボレーター** として招待されます（Organization への参加は不要です）
- **データ**: `data/` の CSV は **すべて架空** です（実在の人物・研究データではありません）

## 当日の流れ（目安）

| 時間 | 内容 |
|------|------|
| 0:00–0:10 | 導入（なぜ Julia・GitHub・Cursor か） |
| 0:10–0:25 | 環境チェック（下記「最初にやること」参照） |
| 0:25–0:55 | Julia 入門（うち約10分はパッケージ管理） |
| 0:55–1:05 | 休憩・フォロー |
| 1:05–1:40 | Git/GitHub ハンズオン（clone → branch → commit → push → PR） |
| 1:40–1:50 | CI デモ（オーナー設置の CI を **見るだけ**） |
| 1:50–2:00 | タグ・リリースの概要（**デモのみ**）、Cursor の AI 機能紹介、まとめ |

## ドキュメント

| 資料 | 内容 |
|------|------|
| [docs/01_setup.md](docs/01_setup.md) | **事前準備**（GitHub・Git・Julia・Cursor） |
| [docs/02_julia_basics.md](docs/02_julia_basics.md) | REPL・基本文法・CSV 集計と図 |
| [docs/03_packages.md](docs/03_packages.md) | パッケージ管理（Pkg・Project.toml） |
| [docs/04_git_github.md](docs/04_git_github.md) | Cursor での Git/GitHub 操作 |
| [docs/05_ci.md](docs/05_ci.md) | CI の見方（参加者は設定しない） |
| [docs/06_tags_releases.md](docs/06_tags_releases.md) | タグ・GitHub Releases（説明・デモ用） |
| [submissions/README.md](submissions/README.md) | **PR 課題**の説明 |

## 参加者が最初にやること

1. **[docs/01_setup.md](docs/01_setup.md)** に沿って環境を整える（未完了の人は当日の環境チェック枠で対応します）
2. GitHub の **ユーザー名をオーナーに送る**
3. 届いた **コラボレーター招待メールを承認**する
4. このリポジトリを clone する（手順は [docs/04_git_github.md](docs/04_git_github.md)）
5. リポジトリのルートで Julia を起動し、パッケージを入れる:
   ```julia
   ] activate .
   ] instantiate
   ```
6. [docs/02_julia_basics.md](docs/02_julia_basics.md) のハンズオン用スクリプトを試す:
   ```bash
   julia examples/analyze_survey.jl
   ```

## リポジトリの主な場所

- `examples/` … 当日触るサンプルコード
- `data/` … ハンズオン用 CSV（架空データ）
- `submissions/` … PR 課題で各自がファイルを追加する場所
- `test/` … 簡単な自動テスト（CI でも実行）

## ライセンス

[MIT License](LICENSE)
