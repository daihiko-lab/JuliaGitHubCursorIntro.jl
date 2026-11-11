# 02. Julia 入門（REPL・読み込み・集計・図）

所要の目安: **約30分**（パッケージの話は [docs/03_packages.md](03_packages.md) で別途）

この章では、REPL の基本と、このリポジトリの **架空 CSV** を読み込んで集計し、棒グラフを保存するまでを体験します。

---

## 1. Julia REPL を開く

### ターミナルから

リポジトリのルート（`Project.toml` がある場所）で:

```bash
julia
```

プロンプトが `julia>` になれば REPL です。

### Cursor から

- コマンドパレットで「Julia: Start REPL」など（拡張機能のメニュー）
- またはターミナルで `julia` を実行

**終了**: `Ctrl + D`（Mac は同様）または `exit()` と入力

---

## 2. REPL のモード（覚えておくと便利）

| キー / 操作 | モード | 用途 |
|-------------|--------|------|
| `]` | Pkg モード `pkg>` | パッケージの追加など（次章） |
| `?` | ヘルプモード `help?>` | `?println` のように関数の説明 |
| `;` | シェルモード `shell>` | `;ls` のように OS コマンド |
| Backspace | `julia>` に戻る | |

初回は `julia>` だけで十分です。

---

## 3. ほんの少しの文法

REPL で一行ずつ試してみましょう。

```julia
# コメントは # から

x = 10
y = 3
x + y

name = "ゼミ"
println("こんにちは, ", name)

# ベクトル（配列に近い）
scores = [4.2, 3.8, 5.1]
mean(scores)   # 平均（Statistics が要る場合は using Statistics）
```

`mean` を使うには:

```julia
using Statistics
mean(scores)
```

Julia は **1始まり** のインデックスです: `scores[1]` が最初の要素。

---

## 4. プロジェクトを有効にする

このリポジトリは **Julia プロジェクト** です。ルートで REPL を開いたら:

```julia
using Pkg
Pkg.activate(".")   # または起動時に ] activate .
```

`pkg>` なら:

```
] activate .
```

パッケージを初めて入れるとき（事前準備で済ませていなければ）:

```
] instantiate
```

ダウンロードに数分かかることがあります。

---

## 5. ハンズオン: CSV を読んで集計する

データは **架空** です（`data/survey_responses.csv`）。列の意味:

| 列名 | 内容（架空） |
|------|----------------|
| `participant_id` | 参加者 ID |
| `condition` | `control` または `experimental` |
| `score` | 1–7 想定のスコア |
| `response_ms` | 反応時間（ミリ秒） |

### REPL でステップ実行

```julia
using CSV
using DataFrames
using Statistics

path = joinpath("data", "survey_responses.csv")
df = CSV.read(path, DataFrame)

first(df, 5)      # 先頭5行
names(df)         # 列名
nrow(df)          # 行数
```

**条件ごとの平均スコア**:

```julia
using DataFrames
gdf = groupby(df, :condition)
result = combine(gdf, :score => mean => :mean_score, nrow => :n)
```

`result` を表示して、`experimental` と `control` の違いを眺めてみましょう（架空データなので「意味のある差」とは限りません）。

---

## 6. 図を作って保存する

```julia
using Plots

conditions = result.condition
means = result.mean_score

p = bar(conditions, means; ylabel="平均スコア", xlabel="条件",
        title="条件ごとの平均スコア（架空データ）", legend=false)

mkpath("output")
savefig(p, joinpath("output", "mean_score_by_condition.png"))
```

`output/` フォルダは `.gitignore` 済みなので、練習で作った図が誤ってコミットされにくくなっています。PR で図を載せたいときは `submissions/` など方針に従ってください。

---

## 7. スクリプトとして一括実行

同じ処理は `examples/analyze_survey.jl` にまとめてあります。

```bash
julia examples/analyze_survey.jl
```

エラーが出たときは:

- `] activate .` と `] instantiate` をしたか
- カレントディレクトリがリポジトリのルートか

を確認してください。

---

## 8. 次に進む

- パッケージの追加・削除・`Project.toml` の意味 → [docs/03_packages.md](03_packages.md)
- Git で変更を共有する → [docs/04_git_github.md](04_git_github.md)
