# 07. Julia でよく使う GitHub 機能（発展的な読み物）

**対象**: 自分で **Julia パッケージ** を作ったり、論文用の再現可能なリポジトリを整えたりする人向けの **コラム** です。

ゼミの当日ハンズオンでは扱いません。将来パッケージ開発に進むときの「地図」として読んでください。

関連: [タグとリリース（06）](06_tags_releases.md) / [ライセンスの基礎（08_licensing.md）](08_licensing.md)

---

## 1. Issues（イシュー）

**Issues** は、リポジトリごとの **バグ報告・機能要望・質問のチケット** です。

### 他人のパッケージで困ったとき

1. まず **README** や **ドキュメント**、**Discourse**（Julia コミュニティフォーラム）を検索
2. 同じリポジトリの **Issues を検索**（既に報告済みか確認）
3. 再現手順が分かれば **新規 Issue** を立てる（最小の例・バージョン情報・`Project.toml` の Julia バージョンなど）

礼儀として「再現可能な最小例（MWE）」を書くと、メンテナが助けやすくなります。

### 自分のプロジェクトでは

- 卒論・論文用リポジトリでも「やることリスト」代わりに Issues を使う人がいます
- 今回の教材の PR 課題とは別物で、**長期的なタスク管理** に向いています

---

## 2. GitHub Actions と julia-actions

**GitHub Actions** は、GitHub 上でワークフロー（YAML）を動かす CI/CD です。Julia では [**julia-actions**](https://github.com/julia-actions) というコミュニティ製アクションが定番です。

この教材リポジトリの例:

- `julia-actions/setup-julia` … 指定バージョンの Julia をセットアップ
- `julia-actions/cache` … パッケージキャッシュで CI を速くする
- `julia-actions/julia-runtest` … `Pkg.test()` を実行

[05_ci.md](05_ci.md) で「結果を見る」練習をしています。パッケージ作者は、**複数 OS × 複数 Julia バージョン** の matrix を書くことが多いです。

---

## 3. CompatHelper と Dependabot

依存の更新を **自動 PR** してくれる仕組みです。

| ツール | 主な対象 |
|--------|----------|
| [**CompatHelper.jl**](https://github.com/JuliaRegistries/CompatHelper.jl) | `Project.toml` の **`[compat]`** 範囲の更新 PR（専用ワークフロー） |
| [**Dependabot**](https://docs.github.com/ja/code-security/dependabot) | **GitHub Actions** の更新、または **`package-ecosystem: julia`** で Julia 依存の更新 |

[DistSSHRun.jl](https://github.com/yamanori99/DistSSHRun.jl)（オーナー参考リポジトリ）では、**CompatHelper ワークフローは使わず**、Dependabot の **`julia` エコシステム** で `[compat]` を更新しています。本教材リポジトリも同じ方針です（[05_ci.md](05_ci.md)）。

---

## 4. General レジストリへの登録（Registrator）と TagBot

Julia の公式パッケージ登録先は [**General** レジストリ](https://github.com/JuliaRegistries/General) です。自分のパッケージを `] add YourPackage` で世界中が入れられるようにする流れはおおむね次のとおりです。

1. GitHub にパッケージリポジトリ（`Project.toml`・`src/`・テストなど）を用意
2. [**Registrator**](https://github.com/JuliaRegistries/Registrator.jl) … 新バージョンを General に **登録要求**（Web UI または GitHub App）
3. 短い **自動チェック**（JuliaRegistries の Bot）のあとマージされると、そのバージョンが `] add` 可能に
4. [**TagBot**](https://github.com/JuliaTagBot/TagBot) … 登録に成功したコミットに **git タグ** を付け、**GitHub Release** を自動作成

TagBot が行うことは、手動のタグ・リリース（[06_tags_releases.md](06_tags_releases.md)）の **自動化版** です。論文用の一回きりリポジトリでは TagBot までは不要なことが多いですが、**パッケージ公開** ではほぼ標準的な組み合わせです。

---

## 5. Documenter.jl と GitHub Pages

[**Documenter.jl**](https://github.com/JuliaDocs/Documenter.jl) は、Julia 向けの **ドキュメント生成** ツールです。Markdown とコード例から HTML を作り、API リファレンスを載せられます。

- ビルドした静的サイトを **GitHub Pages** にデプロイする、という流れが一般的
- GitHub Actions で `Documenter` を動かし、**`gh-pages` ブランチ** や **GitHub Pages の Actions デプロイ** に送る

本教材は `docs/*.md` をそのまま読む形式ですが、Julia パッケージ本番では Documenter が主流です。

---

## 6. Codecov

[**Codecov**](https://about.codecov.io/) は **テストカバレッジ**（どの行がテストで実行されたか）を集計・可視化するサービスです。

- CI で `julia-processcoverage` / `Codecov` アップロードステップを追加
- PR ごとに「カバレッジが上がった／下がった」がコメントされることがある

研究用の一回きりスクリプトより、**メンテナンスするパッケージ** 向けの文化です。

---

## 7. まとめ

| 機能 | ざっくり用途 |
|------|----------------|
| Issues | バグ・質問・タスク |
| Actions + julia-actions | テスト・ドキュメント・登録の自動化 |
| CompatHelper / Dependabot | 依存の更新 PR |
| Registrator / TagBot | General 登録とリリース自動化 |
| Documenter + Pages | パッケージドキュメント公開 |
| Codecov | カバレッジ可視化 |

ゼミ後に **自分の小さなパッケージ** を作ってみるとき、この一覧を見返すと次の一手が分かりやすくなります。
