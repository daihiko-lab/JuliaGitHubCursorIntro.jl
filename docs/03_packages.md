# 03. パッケージ管理 (Pkg) 

所要の目安: **約10分** (Julia 入門の一部) 

Julia のライブラリは **パッケージ** として配布されます。日常的に使う操作は次のとおりです。

---

## 1. Pkg モードに入る

REPL で **`]`** (右角括弧) を押すと、プロンプトが `pkg>` になります。

戻る: **Backspace** (または `Ctrl + C`) 

---

## 2. よく使うコマンド

| コマンド | 意味 |
|----------|------|
| `add CSV` | パッケージを追加 (現在の環境へ) |
| `rm CSV` | パッケージを削除 |
| `status` (短く `st`) | 入っているパッケージ一覧 |
| `update` | 互換範囲内で更新 |
| `activate .` | **このフォルダ** をプロジェクト環境にする |
| `instantiate` | `Project.toml` に書かれた依存をインストール |

この教材リポジトリは **Julia パッケージ風** (`src/JuliaGitHubCursorIntro.jl`、名前 **`JuliaGitHubCursorIntro`**) ですが、**General には登録しません** (ゼミ用に clone + `activate` するだけ) 。`Project.toml` には **CSV, DataFrames, Plots, Statistics** (Statistics は標準ライブラリですが、Julia の新しいバージョンでは明示的に依存へ書くことがあります) が書かれています。初回は:

```
] activate .
] instantiate
```

だけで足ります。

---

## 3. グローバル環境に入れすぎない理由

`pkg>` で `activate` せずに `add` すると、**グローバル環境** (`@v1.x`) にパッケージが溜まります。

- プロジェクト A と B で **別バージョン** が必要なときに衝突しやすい
- 再現性のある共有 (GitHub 上の `Project.toml`) とズレやすい

**習慣**: リポジトリのルートで `] activate .` してから作業する。

---

## 4. `Project.toml` と `Manifest.toml`

| ファイル | 役割 |
|----------|------|
| **Project.toml** | プロジェクト名・依存パッケージ・**互換バージョン (`[compat]`)** など。**ほぼ常に Git にコミットする** |
| **Manifest.toml** | その時点で実際に解決された **全パッケージ (間接依存含む) の正確なバージョン** のロックファイル |

`Pkg.resolve` や `add` / `instantiate` の過程で Manifest が更新されます。`instantiate` は **`Project.toml` を読み、あれば `Manifest.toml` でピン留めされた集合** を優先して環境を再現します (Manifest が無いときは `Project.toml` とレジストリから解決し直します) 。

**`Manifest.toml` を Git に含めるかどうかはプロジェクトの種類で分かれる** ことが多いです (次節) 。

---

## 5. `Manifest.toml` をコミットする？ しない？

### 対比: 登録パッケージ vs 分析・再現用リポジトリ

| 種類 | `Manifest.toml` | ざっくり理由 |
|------|-----------------|--------------|
| **[General](https://github.com/JuliaRegistries/General) に登録する Julia パッケージ** | **普通はコミットしない** (`.gitignore` する例が多い) | 利用者の Julia 版・OS ごとに解決結果が変わり得る。作者は **`Project.toml` の `[compat]`** で「動く範囲」を示し、各利用環境で `instantiate` させる文化が強い |
| **パッケージ登録しないプロジェクト** (研究室の分析コード、論文の再現用リポジトリ、卒論用の1本リポジトリなど) | **むしろコミットするべき場合が多い** | 共同研究者・未来の自分・査読者が **同じバージョン集合** で `instantiate` できる。論文の図表を **年後に再実行** するときの再現性に直結する |

どちらも「正しい／間違い」ではなく、**配布の仕方 (パッケージとして世界に出すか、固定した1本の研究コードか)** の違いに近いです。

### Manifest をコミットするときは **Julia 本体のバージョン** も揃える

Manifest だけあっても、**Julia のマイナーバージョンやビルド** が違うと、稀に解決結果やバイナリ互換がずれることがあります。再現性を重視するリポジトリでは次をセットで書くことが多いです。

- **`Project.toml` の `julia = "…"` (`[compat]`)** … 使った Julia の系列を明示
- **README や `juliaup` の設定** … 開発者・CI が同じ系列を使う  
  - 例: [juliaup](https://github.com/JuliaLang/juliaup) で `julia +1.13` のようにチャンネルを固定し、プロジェクト用に `juliaup override set 1.13` など (手順は juliaup のドキュメント参照) 
- **CI (GitHub Actions)** … `setup-julia` で **`1.13` のようにピン** する (本教材の CI も JETLS 用に 1.13 を使っています) 

「Manifest + Julia 版 + (できれば) OS」までセットで記録すると、再現の成功率が上がります。

### この教材リポジトリについて (現状の方針)

**現時点** では `.gitignore` で `Manifest.toml` を除外しており、**`[compat]` + 各自の `instantiate`** を前提にしています (ゼミ入門では、参加者の OS と Julia の細かい差を Manifest 1本で縛りすぎないため) 。

- **`.gitignore` の変更** (Manifest を追跡するかどうか) は **オーナー判断** です。判断が出るまではリポジトリ設定はそのままにし、ドキュメントだけ「両方の文化がある」と理解しておいてください。  
- ハンズオン用の Private コピーでも、当面は同じ考え方を想定しています (オーナーが方針を変えたら README を確認) 。

論文・査読用の **本番再現リポジトリ** を自分で作るときは、上の表の **右列 (Manifest をコミット)** を検討してください。

---

## 6. General に載っていない GitHub パッケージ

`CSV` のように **レジストリ名だけ** で足せるのは登録済みパッケージです。研究室の試作や GitHub だけにある `.jl` リポジトリは **URL で `add`** します。`rev` (タグ・ブランチ・コミット) 、`[sources]`、`Manifest.toml` の `repo-url` などは **[docs/09_packages_from_github.md](09_packages_from_github.md)** で扱います (ゼミ本編のあと・予習用でも可) 。

---

## 7. 確認クイズ (自分用) 

1. 今の環境を確認する `pkg>` コマンドは？ → `status`  
2. チームメンバーが clone したあと最初に打つべきは？ → `activate .` と `instantiate`  
3. 新しいパッケージを **この教材に** 追加したいときは？ → `add パッケージ名` (`Project.toml` が更新される) 

---

## 次のステップ

[docs/04_git_github.md](04_git_github.md) で、`Project.toml` を変更したら **コミット → push → PR** する流れを体験します。

GitHub 未登録パッケージを依存に入れる詳細 → [docs/09_packages_from_github.md](09_packages_from_github.md)
