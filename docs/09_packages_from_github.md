# 09. General 未登録パッケージを GitHub から使う

所要の目安: **約15分** ( [03_packages.md](03_packages.md) の続き・研究室コード向け) 

[General](https://github.com/JuliaRegistries/General) に載っているパッケージは `] add パッケージ名` だけで足ります。**まだ登録されていない** Julia パッケージ (研究室の試作、論文用の非公開リポジトリ、自分で clone した教材など) は、**Git リポジトリの URL** を指定して依存に入れます。

本教材リポジトリ自体も General には登録しません ( [03_packages.md](03_packages.md) 参照) 。**依存として** 別の GitHub 上の `.jl` リポジトリを `add` する手順がこの章の主題です。

公式の仕様は [Pkg.jl — Managing Packages (Adding unregistered packages) ](https://pkgdocs.julialang.org/v1/managing-packages/#Adding-unregistered-packages) および [API `Pkg.add`](https://pkgdocs.julialang.org/v1/api/#Pkg.add) を参照してください。VM 上の Julia **1.13.3** で記載コマンドを実行し、出力の雰囲気を確認しています。

---

## 1. URL で追加する (`add` / `Pkg.add`)

### Pkg REPL (`pkg>`)

プロジェクトのルートで環境を有効化したうえで:

```
] activate .
] add https://github.com/fredrikekre/ImportMacros.jl
```

登録済みパッケージと同様、末尾に **`#ブランチ名`** や **`#コミットSHA`** を付けられます (次章) 。

```
] add https://github.com/fredrikekre/ImportMacros.jl#v1.0.0
```

### Julia プログラムから (非 REPL)

```julia
using Pkg
Pkg.activate(".")
Pkg.add(url = "https://github.com/fredrikekre/ImportMacros.jl")
```

Julia 1.13 で上記を実行すると、おおむね次のような流れになります (抜粋) 。

```
     Cloning git-repo `https://github.com/fredrikekre/ImportMacros.jl`
    Updating …/Project.toml
  [92a963f6] + ImportMacros v1.0.0 `https://github.com/fredrikekre/ImportMacros.jl#master`
    Updating …/Manifest.toml
  [92a963f6] + ImportMacros v1.0.0 `https://github.com/fredrikekre/ImportMacros.jl#master`
```

> **例のパッケージ**: [ImportMacros.jl](https://github.com/fredrikekre/ImportMacros.jl) は General に載っていない小さなパッケージで、Pkg のドキュメントでも例としてよく使われます。ゼミ用の練習でもそのまま使えますが、**本番の研究プロジェクトでは README のライセンスとメンテ状況を確認** してください。

リポジトリ直下がパッケージ根ではない場合は、**サブディレクトリ** を `:` で指定します (例: `] add https://github.com/timholy/SnoopCompile.jl.git:SnoopCompileCore`) 。詳細は [Adding a package in a subdirectory of a repository](https://pkgdocs.julialang.org/v1/managing-packages/#Adding-a-package-in-a-subdirectory-of-a-repository) 。

---

## 2. `rev=` で版を指定する (タグ・ブランチ・コミット)

### 書き方

| 方法 | REPL 例 | `Pkg.add` 例 |
|------|---------|----------------|
| ブランチ (既定は多くの場合 `master` / `main`) | `add https://github.com/…/Pkg.jl` | `Pkg.add(url = "…", rev = "master")` |
| **タグ** (Git の tag。GitHub の Release と対応することが多い) | `add https://github.com/…/Pkg.jl#v1.0.0` | `Pkg.add(url = "…", rev = "v1.0.0")` |
| **コミット SHA** (先頭数文字でも可) | `add https://github.com/…/Pkg.jl#1f189fb` | `Pkg.add(url = "…", rev = "1f189fb")` |

タグを指す Git の考え方は [06_tags_releases.md](06_tags_releases.md) と同じです。Pkg が追跡するのは **リモート Git 上の ref** であり、GitHub の Release ページそのものではありません (多くの人がタグ `v1.0.0` を Release に添付します) 。

### 挙動の違い (再現性の観点)

| `rev` の種類 | 中身が動くか | `] update` の影響 |
|--------------|--------------|-------------------|
| **タグ** (`v1.0.0` など) | 通常は固定 (同じタグは同じコミット) | タグが指す版の範囲内で依存解決は動くが、**タグ先のコミットは変わらない** |
| **ブランチ** (`main` など) | **先端が進む** | ブランチの新しいコミットへ **追従** しうる |
| **コミット SHA** | **完全固定** | そのコミットに **ピン** したのと同様 (公式: [Adding registered packages — commit id](https://pkgdocs.julialang.org/v1/managing-packages/#Adding-registered-packages) の Note) |

検証例: `Pkg.add(url = "https://github.com/fredrikekre/ImportMacros.jl", rev = "v1.0.0")` のあと、`status` では

`ImportMacros v1.0.0 `https://github.com/fredrikekre/ImportMacros.jl#v1.0.0``

のように表示され、`Manifest.toml` には `repo-rev = "v1.0.0"` が記録されます ( §6 参照) 。

---

## 3. `pin` / `free` と `rev` の違い

### `rev` を付けて `add` したとき

- **ブランチ** を追跡している場合、`] update` でリモートの新しいコミットが取り込まれることがあります。
- **タグ** や **コミット SHA** は、もともと「そこを指す」指定です。

### `pin` (ピン留め)

現在チェックアウトされている版 (または追跡中の ref) を **更新対象から外します** 。`status` ではパッケージ名の横に **⚲** が付きます。

```
] pin ImportMacros
```

API: [`Pkg.pin`](https://pkgdocs.julialang.org/v1/api/#Pkg.pin) — 追跡中の path / リポジトリはそのままですが、**自動更新されません** 。

### `free` (ピン解除・開発パスや Git 追跡の解除)

- **`pin` した状態を戻す** (`⚲` を外す) 。
- 登録パッケージで **ブランチや dev パス追跡** をやめ、レジストリ版に戻すときにも使います ( [Pinning a package](https://pkgdocs.julialang.org/v1/managing-packages/#Pinning-a-package) 、 [free Example](https://pkgdocs.julialang.org/v1/managing-packages/#Adding-registered-packages) の例) 。

```
] free ImportMacros
```

**まとめ**: `rev = "abc123…"` は「最初からそのコミットを指定」、`pin` は「いま入っている状態を更新ループに載せない」ための操作です。長期に再現性を固定したいなら、**タグまたはコミット SHA で `add` し、必要なら Manifest をコミット** ( [03_packages.md](03_packages.md) §5) の組み合わせがよく使われます。

---

## 4. `Project.toml` の `[sources]` (Julia 1.11+)

Julia **1.11 以降**、URL や `rev` は **`[sources]`** にも書けます。`] add https://…` や `Pkg.add(url=…)` をすると、多くの場合 **自動で `[sources]` が追記** されます (Julia 1.13.3 で `ImportMacros` を追加した際も同様) 。

```toml
[sources]
ImportMacros = { url = "https://github.com/fredrikekre/ImportMacros.jl", rev = "master" }
```

手で書く・直すこともできます。キーの意味は [Project.toml and Manifest.toml — `[sources]`](https://pkgdocs.julialang.org/v1/toml-files/#The-sources-section) を参照してください。

| キー | 用途 |
|------|------|
| `url` | Git リポジトリ URL (`path` と同時には使わない) |
| `rev` | ブランチ名・タグ・コミット |
| `subdir` | モノレポ内のサブフォルダ |
| `path` | ローカルパス (`dev` 相当) |

**なぜ便利か**: Manifest を Git に含めない方針でも、**URL と ref だけ** を `Project.toml` に残せ、`] instantiate` のときに同じ Git ソースから取り直せます (登録パッケージだけの環境では Manifest なしでも `[compat]` だけで足りる、という話は [03_packages.md](03_packages.md) §5 との対比) 。

**Julia の版**: `[sources]` は **1.11+** 必須です。本教材の CI は **JETLS に Julia 1.13** を使っています ( [README](../README.md) 、 [05_ci.md](05_ci.md)) 。参加者は **1.11 未満** だと `[sources]` を読めず、Manifest や手動 `add` に頼る必要があります。

---

## 5. Private リポジトリ (認証)

URL が **認証の要る private リポジトリ** のとき、Pkg は内部で `git clone` / `git fetch` します。Git がリモートにログインできれば動きます。

### HTTPS

```
] add https://github.com/your-org/YourPrivatePkg.jl
```

- **Mac / Windows**: Git Credential Manager や `gh auth login` 後の GitHub クレデンシャルで、ブラウザまたはトークン認証が使われることが多いです。
- **Personal Access Token (PAT)**: パスワードの代わりにトークンを使う運用が一般的です (GitHub のドキュメント参照) 。

### SSH

URL に `@` が含まれるため **REPL では引用符が必要** です ( [Pkg.jl 公式例](https://pkgdocs.julialang.org/v1/managing-packages/#Adding-unregistered-packages) ) 。

```
] add "git@github.com:your-org/YourPrivatePkg.jl.git"
```

- **事前に** `ssh -T git@github.com` が通ること (鍵を `ssh-agent` に載せる、Windows では OpenSSH サービスや 1Password 連携など) 。
- `Project.toml` / `Manifest.toml` に **SSH URL がそのまま残る** ことがあるため、共同研究者と **HTTPS に揃える** か、全員が SSH 鍵を用意するかを決めるとトラブルが減ります。

### よく見るエラー (例)

| 症状 | 想定される原因 |
|------|----------------|
| `Authentication failed` / `403` | 権限不足・トークン期限・SSO 未承認 |
| `Repository not found` | タイポ、または **未認証のまま private にアクセス** (GitHub は存在を隠す) |
| `Host key verification failed` | 初回 SSH 接続の known_hosts 未登録 |
| `Could not clone` / タイムアウト | 学内プロキシ・VPN・ファイアウォール |

CI (GitHub Actions) で private 依存を取る場合は **Deploy key** や **PAT を Secrets に入れる** など、別設計が必要です。本ゼミの教材 CI では扱いません。

---

## 6. `Manifest.toml` に何が書かれるか

Git 由来の依存は、レジストリ版とはフィールドが異なります ( [Package entries — Added package by branch](https://pkgdocs.julialang.org/v1/toml-files/#Added-package-by-branch) ) 。

| フィールド | 意味 |
|------------|------|
| `repo-url` | クローン元 URL |
| `repo-rev` | 追跡している ref (ブランチ名・タグ名・コミット SHA) |
| `git-tree-sha1` | その時点の **ソースツリーの内容ハッシュ** (実体の同一性) |

`rev = "master"` で追加した例 (Julia 1.13.3) :

```toml
[[deps.ImportMacros]]
git-tree-sha1 = "0efe47004385c96d675583149ff9e70a06c12fe5"
repo-rev = "master"
repo-url = "https://github.com/fredrikekre/ImportMacros.jl"
uuid = "92a963f6-6b1d-11e9-1d6c-8d25856e017b"
version = "1.0.0"
```

タグ `v1.0.0` 指定時は `repo-rev = "v1.0.0"` になり、`repo-url` は同様です。

[03_packages.md](03_packages.md) §4–§5 で説明した **`instantiate` と Manifest をコミットするか** の話は、GitHub 未登録依存でも同じです。

- **Manifest をコミットする** … `repo-url` / `repo-rev` / `git-tree-sha1` まで含め、**同じツリー** を再現しやすい (分析・論文コード向け) 。
- **Manifest をコミットしない** … Julia 1.11+ なら `[sources]` で URL/ref を共有し、各自の `instantiate` で取り直す、という折衷が可能 (チームで Julia 版を揃えること) 。

---

## 7. `dev` と `add` の違い (概要)

| | `add` (URL / ローカル git) | `dev` ( [`develop`](https://pkgdocs.julialang.org/v1/managing-packages/#Developing-packages) ) |
|--|---------------------------|----------------------------------|
| 用途 | **依存として固定気味に取り込む** | **そのパッケージを編集しながら使う** |
| ローカル変更 | 取り込まれたコピーは depot 側。未コミットの手元変更は **`add` では即反映されない** | 既定で `~/.julia/dev/パッケージ名` など **作業ツリーを直接読む** |
| 再現性 | `Project.toml` + `Manifest.toml` (+ `[sources]`) で共有可能 | path 追跡は **手元のファイル内容** に依存し、他人の `instantiate` だけでは再現しきれない |

研究室で「助手がパッケージを fork して直す」なら `dev`、「特定コミットの分析コードを再実行」なら URL + タグ/SHA + Manifest、という使い分けが目安です。

ローカル **非 git** パスへの `add` と `dev` の注意 ( `add` では未コミット変更が載らない) は公式の Warning どおりです: [Adding a local package](https://pkgdocs.julialang.org/v1/managing-packages/#Adding-a-local-package) 。

---

## 8. 確認クイズ (自分用)

1. General に無い `.jl` リポジトリを足す最短の `pkg>` コマンドは？ → `add https://github.com/…/Name.jl`  
2. ブランチ先端の動きを追いたいときの `rev` は？ → ブランチ名 (例: `main`)  
3. 査読用に版を固定したいなら `rev` はタグとブランチのどちらが向く？ → **タグ** (またはコミット SHA)  
4. `] update` でブランチ追跡を止めたいが、今の版は維持したい → `pin`  
5. Julia 1.11+ で URL を Git に残す仕組みのセクション名は？ → `[sources]`  

---

## 次のステップ

- Git で `Project.toml` を直したあとの **コミット・PR** → [04_git_github.md](04_git_github.md)  
- タグ・GitHub Release の意味 → [06_tags_releases.md](06_tags_releases.md)  
- パッケージとして公開する話 → [07_github_for_julia.md](07_github_for_julia.md)  
