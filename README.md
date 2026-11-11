# JuliaGitHubCursorIntro.jl

<!-- リポジトリ名変更時: 文字列 JuliaGitHubCursorIntro.jl / daihiko-lab/JuliaGitHubCursorIntro.jl を検索 (詳細は docs/05_ci.md §8) -->

<p>
<a href="https://github.com/daihiko-lab/JuliaGitHubCursorIntro.jl/actions/workflows/CI.yml"><img src="https://img.shields.io/github/actions/workflow/status/daihiko-lab/JuliaGitHubCursorIntro.jl/CI.yml?branch=main&amp;style=flat-square&amp;logo=githubactions&amp;logoColor=white&amp;label=Test" alt="Test"></a>
<a href="https://codecov.io/gh/daihiko-lab/JuliaGitHubCursorIntro.jl"><img src="https://img.shields.io/codecov/c/github/daihiko-lab/JuliaGitHubCursorIntro.jl?style=flat-square&amp;logo=codecov&amp;logoColor=white" alt="cov"></a>
<a href="https://docs.julialang.org/en/v1/"><img src="https://img.shields.io/badge/Julia-1.13+-9558B2?style=flat-square&amp;logo=julia&amp;logoColor=white" alt="Julia 1.13+"></a>
<a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow?style=flat-square" alt="License: MIT"></a>
<a href="https://github.com/fredrikekre/Runic.jl"><img src="https://img.shields.io/badge/code_style-%E1%9A%B1%E1%9A%A2%E1%9A%BE%E1%9B%81%E1%9A%B2-black" alt="code style: runic"></a>
</p>

ゼミ (社会心理学研究室) 向けの **Julia / Git / GitHub / Cursor** 導入会 (約2時間) 用教材です。架空データを使った Julia の入門演習と、全員で **ブランチ → コミット → push → プルリクエスト (PR)** まで体験する課題を含みます。

## このリポジトリと当日のハンズオン

| 種類 | 説明 |
|------|------|
| **このリポジトリ (Public)** | 教材の **公開版** です。[`daihiko-lab/JuliaGitHubCursorIntro.jl`](https://github.com/daihiko-lab/JuliaGitHubCursorIntro.jl) で誰でも閲覧・clone できます (旧 slug `julia-github-intro-2026` / `julia-github-cusor-intro` / `julia-github-cursor-intro` などからは GitHub がリダイレクトします) 。 |
| **当日のハンズオン用 (Private)** | ゼミ当日の PR 演習は、オーナーが用意する **別の Private リポジトリ** で行います (おおむねこの内容の複製) 。参加者はそちらに **コラボレーター招待** され、clone・push・PR は **ハンズオン用の URL** に対して行います。 |

複製の具体的な手順 (テンプレート化、Organization 内の複製、Import など) は **オーナーが決め、当日までに URL を案内** します。予習は Public 版を clone してもかまいませんが、**課題の PR は案内されたハンズオン用リポジトリへ** 出してください ([docs/04_git_github.md](docs/04_git_github.md)) 。

- **オーナー**: [daihiko-lab](https://github.com/daihiko-lab) (山本) 
- **データ**: `data/` の CSV は **すべて架空** です (実在の人物・研究データではありません) 

## 当日の流れ (目安) 

| 時間 | 内容 |
|------|------|
| 0:00–0:10 | 導入 (なぜ Julia・GitHub・Cursor か) |
| 0:10–0:25 | 環境チェック (下記「最初にやること」参照) |
| 0:25–0:55 | Julia 入門 (うち約10分はパッケージ管理) |
| 0:55–1:05 | 休憩・フォロー |
| 1:05–1:40 | Git/GitHub ハンズオン (clone → branch → commit → push → PR) |
| 1:40–1:50 | CI デモ (オーナー設置の CI を **見るだけ**。設定の参考: [DistSSHRun.jl](https://github.com/yamanori99/DistSSHRun.jl)) |
| 1:50–2:00 | タグ・リリースの概要 (**デモのみ**) 、Cursor の AI 機能紹介、まとめ |

## ドキュメント

| 資料 | 内容 |
|------|------|
| [docs/01_setup.md](docs/01_setup.md) | **事前準備** (GitHub・Git・Julia・Cursor) |
| [docs/02_julia_basics.md](docs/02_julia_basics.md) | REPL・基本文法・CSV 集計と図 |
| [docs/03_packages.md](docs/03_packages.md) | パッケージ管理 (Pkg・Project.toml) |
| [docs/04_git_github.md](docs/04_git_github.md) | Cursor での Git/GitHub 操作 |
| [docs/05_ci.md](docs/05_ci.md) | CI の見方 (参加者は設定しない) |
| [docs/06_tags_releases.md](docs/06_tags_releases.md) | タグ・GitHub Releases (説明・デモ用) |
| [docs/07_github_for_julia.md](docs/07_github_for_julia.md) | Julia 向け GitHub 機能コラム (**発展・読み物**) |
| [docs/08_licensing.md](docs/08_licensing.md) | ライセンスの基礎 (コード・データ・Zenodo) |
| [submissions/README.md](submissions/README.md) | **PR 課題**の説明 |

## 参加者が最初にやること

1. **[docs/01_setup.md](docs/01_setup.md)** に沿って環境を整える (未完了の人は当日の環境チェック枠で対応します) 
2. GitHub の **ユーザー名をオーナーに送る**
3. **ハンズオン用 Private リポジトリ** へのコラボレーター招待メールを承認する (案内はオーナーから) 
4. **ハンズオン用リポジトリ** を clone する (URL はオーナー案内。[docs/04_git_github.md](docs/04_git_github.md) の手順) 
5. リポジトリのルートで Julia を起動し、パッケージを入れる:
   ```julia
   ] activate .
   ] instantiate
   ```
6. [docs/02_julia_basics.md](docs/02_julia_basics.md) のハンズオン用スクリプトを試す:
   ```bash
   julia examples/analyze_survey.jl
   ```

(任意) 事前予習として、公開版 `https://github.com/daihiko-lab/JuliaGitHubCursorIntro.jl` を clone して読んでも構いません。

## Julia パッケージとしての構成

教材本体は **Julia パッケージ風** に整理しています (モジュール名 **`JuliaGitHubCursorIntro`** ) 。

| 場所 | 内容 |
|------|------|
| [`Project.toml`](Project.toml) | パッケージ名・UUID・`[compat]` ( **`JuliaGitHubCursorIntro`** ) |
| [`src/JuliaGitHubCursorIntro.jl`](src/JuliaGitHubCursorIntro.jl) | モジュール本体 (CSV 集計の API など) |
| [`test/runtests.jl`](test/runtests.jl) | `using JuliaGitHubCursorIntro` を前提にしたテスト |
| [`examples/analyze_survey.jl`](examples/analyze_survey.jl) | 上記モジュールを呼ぶ薄いスクリプト |

**[General](https://github.com/JuliaRegistries/General) レジストリには登録しません。** `] add JuliaGitHubCursorIntro` ではなく、clone 後に `] activate .` して使います (登録パッケージとの違いは [docs/03_packages.md](docs/03_packages.md)) 。

## リポジトリの主な場所

- `examples/` … 当日触るサンプルコード (`JuliaGitHubCursorIntro` を利用) 
- `data/` … ハンズオン用 CSV (架空データ) 
- `submissions/` … PR 課題で各自がファイルを追加する場所
- `test/` … `Pkg.test()` 用 (CI でも実行) 

## ライセンス

このリポジトリは [**MIT License**](LICENSE) の下で公開されています。MIT / CC / Zenodo などの考え方は [docs/08_licensing.md](docs/08_licensing.md) も参照してください (法的助言ではありません) 。
