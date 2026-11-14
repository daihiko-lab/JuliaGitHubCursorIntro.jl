# 01. 事前の環境構築

当日は時間が限られているため、**可能なら事前に** この手順を終えておいてください。うまくいかない箇所は、当日 0:10–0:25 の環境チェックで質問してください。

対象: **Mac / Windows** (エディタは **Cursor**) 

---

## 1. GitHub アカウント

1. [GitHub](https://github.com/) でアカウントを作成 (既にある場合はスキップ) 
2. **ユーザー名** を控える
3. ユーザー名を **オーナー (山本) に送る** (チャットやメールなど、ゼミで指定された方法) 
4. オーナーから届く **ハンズオン用 Private リポジトリ** のコラボレーター招待メールを承認する  
   - 招待されるのは **Organization 全体ではなく、当日用のハンズオンリポジトリ** です (URL はオーナーが案内)   
   - メールのリンクから承認すると、そのリポジトリを clone して push できるようになります

教材の **公開版** は [daihiko-lab/JuliaGitHubCursorIntro.jl](https://github.com/daihiko-lab/JuliaGitHubCursorIntro.jl) (Public) です。予習用に読んでも構いませんが、**PR 課題はハンズオン用リポジトリ** に対して出します。

> **補足**: 今回は fork は使いません。コラボレーターとして直接ブランチを切ります ([docs/04_git_github.md](04_git_github.md) のコラム参照) 。

---

## 2. Git のインストール

バージョン管理ツール **Git** が必要です。インストール後、ターミナル (または Cursor のターミナル) で `git --version` が表示されれば OK です。

### macOS

Apple 公式の **コマンドラインデベロッパツール** に Git が含まれます。

```bash
xcode-select --install
```

表示されたダイアログでインストールを進めます。既に入っている場合は「すでにインストール済み」と出ることがあります。

別案: [Git for macOS (git-scm.com) ](https://git-scm.com/download/mac) からインストールしても構いません。

### Windows

[**Git for Windows**](https://git-scm.com/download/win) のインストーラを使うのが一般的です。

- 既定の選択肢のままで問題ないことが多いです
- インストール中に「Git Bash」を入れるオプションがあります (あってもなくても可。Cursor のターミナルは **PowerShell** や **Git Bash** どちらでも使えます) 

**インストール後は、開いていたターミナルと Cursor を一度終了し、開き直してください。** PATH が更新され、`git` コマンドが認識されます。

---

## 3. Julia のインストール (juliaup) 

Julia 公式では、バージョン管理ツール [**juliaup**](https://github.com/JuliaLang/juliaup) 経由のインストールが推奨されています ([公式: Installing Julia](https://julialang.org/install/)) 。

### macOS / Linux / FreeBSD

ターミナルで:

```bash
curl -fsSL https://install.julialang.org | sh
```

インストール後、**新しいターミナル** を開き:

```bash
julia --version
```

### Windows

次のいずれかが手軽です ([公式](https://julialang.org/install/) と同じ内容です) 。

**Microsoft Store / winget (推奨)**

コマンドプロンプトまたは PowerShell で:

```powershell
winget install --name Julia --id 9NJNWW8PVKMN -e -s msstore
```

**PowerShell (App Installer)**

```powershell
Add-AppxPackage -AppInstallerFile https://install.julialang.org/Julia.appinstaller
```

インストール後、**ターミナルを開き直し**:

```powershell
julia --version
```

### 推奨バージョン

この教材は、ルートの **`Project.toml` の `[compat]` にある `julia` のバージョン以上** の Julia を想定しています。`juliaup` を使っている場合:

```bash
juliaup add release
juliaup default release
```

---

## 4. Cursor のインストールと Julia 拡張機能

1. [Cursor](https://cursor.com/) をダウンロードしてインストール
2. Cursor を起動し、拡張機能 (Extensions) で **Julia** を検索してインストール  
   - 拡張 ID の例: `julialang.language-julia` (Julia Language Support) 
3. 必要に応じて **Japanese Language Pack** などは任意

### Windows でよくあるつまずき: Julia が見つからない

- **juliaup インストール後に Cursor を再起動**していない  
- ターミナルでは `julia` が動くのに、Cursor だけ動かない → **Cursor 完全終了 → 再起動**  
- まだダメな場合: Cursor の設定で Julia 実行ファイルのパスを指定 (拡張機能の設定項目 **Julia: Executable Path**) 
  - 例 (Windows) : `%USERPROFILE%\.julia\juliaup\julia-*\bin\julia.exe` のようなパス  
  - `where julia` (Windows) や `which julia` (Mac) で実際のパスを確認

### Mac でのメモ

- `julia` は通常 `~/.juliaup/bin/julia` 付近にあります。シェルを開き直せば PATH に乗ります。

---

## 5. Git のユーザー設定

コミットに載る名前とメールを **一度だけ** 設定します (GitHub に登録したメール推奨) 。

```bash
git config --global user.name "あなたの名前"
git config --global user.email "you@example.com"
```

確認:

```bash
git config --global --list
```

---

## 6. 動作確認チェックリスト

教材リポジトリを clone する前に、次ができれば当日スムーズです。

| 項目 | コマンド・操作 | 期待する結果 |
|------|----------------|--------------|
| Git | `git --version` | バージョンが表示される |
| Julia | `julia --version` | `[compat]` の `julia` を満たすバージョンが表示される |
| このリポジトリ | コラボレーター招待を承認 | GitHub 上でリポジトリが見える |
| パッケージ (clone 後) | Julia で `] activate .` → `] instantiate` | エラーなく終わる |
| サンプル実行 | `julia examples/analyze_survey.jl` | 集計が表示され、`output/` に PNG ができる |

clone 手順は [docs/04_git_github.md](04_git_github.md) で当日も行います。事前に済ませても構いません。

---

## 参考リンク

- Julia インストール: https://julialang.org/install/
- juliaup: https://github.com/JuliaLang/juliaup
- Git for Windows: https://git-scm.com/download/win
- GitHub Docs (アカウント) : https://docs.github.com/ja/get-started/start-your-journey/creating-an-account-on-github
