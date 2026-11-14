# PR ハンズオン課題 (4 ステップ)

Git / GitHub ハンズオンでは、**ペア** になって次の 4 段階を体験します。操作の詳細は [docs/04_git_github.md](../docs/04_git_github.md) を参照してください。

## 全体の流れ

| ステップ | 内容 | 主な成果物 |
|---------|------|------------|
| 1 | **自分の PR** | `submissions/<GitHubユーザー名>.jl` を新規追加 |
| 2 | **ペアで相手の PR を見る** | 相手 PR へのコメント・Suggested changes・ (任意) 相手ブランチへの commit |
| 3 | **直された自分の PR を取り込む** | `git pull` → 確認 → 追加 commit → push |
| 4 | **コンフリクト解消** | 共有ファイル `submissions/members.md` の末尾に1行追加し、必要なら conflict を解消 |

当日はオーナー案内の **Private ハンズオン用リポジトリ** に対して PR を出します (fork は使いません) 。

---

## ステップ 1: 自分の PR

### やること

1. `main` からブランチを切る (例: `feat/mean-yourusername`) 
2. `submissions/<GitHubユーザー名>.jl` を **新規作成** する (ファイル名は **自分の GitHub ユーザー名** 。ドットを含んでいてもよい) 
3. **平均関数** と **簡単な呼び出し例** を書く
4. commit → push → **Pull Request** を作成する
5. PR 上で **CI** が走る。失敗したらログを見て直し、同じブランチに commit → push する

### 最低限の要件

- `my_mean(x) = sum(x) / length(x)` 程度の **ごく簡単な平均** を定義すること
- ファイルを `include` してもエラーで止まらないこと (呼び出し例をファイル末尾に書いてよい) 
- **他人の `.jl` は編集しない** (自分のファイルだけ) 

CI のテストは `submissions/*.jl` を **1 ファイルずつ別モジュール** に `include` します。全員が同名の `my_mean` を定義しても、**Main 上でのメソッド上書き警告** は出ません (`test/runtests.jl` 参照) 。

### ひな形

```julia
# submissions/yourusername.jl

"""配列 x の算術平均を返す (空配列のときの扱いはステップ 2 で議論してもよい) """
function my_mean(x)
    return sum(x) / length(x)
end

# 呼び出し例 (include 時に実行される)
my_mean([1, 2, 3, 4, 5])
```

### Runic (書式チェック) が落ちたとき

CI の **Runic** ジョブは、Julia コードの書式をチェックします。ローカルで直す例:

```bash
julia -e 'using Pkg; Pkg.add("Runic"); using Runic; Runic.main("submissions/yourusername.jl")'
```

(`Project.toml` の `[compat]` に合う Julia で実行してください。リポジトリルートで `] activate .` してからでも構いません) 

書式を直したら commit → push し、PR の CI が緑になるか確認します (詳細は [docs/05_ci.md](../docs/05_ci.md)) 。

### 見本ファイル

教材リポジトリには参考用の [example_githubuser.jl](example_githubuser.jl) があります。**PR 課題として提出する必要はありません** (自分用ファイルを新規作成してください) 。

---

## ステップ 2: ペアで相手の PR を見る

ペアの相手が出した PR を開き、**コードレビュー** をします。

### やれること (例)

- **コメント**: 「ドキュメント文字列 (`"""..."""`) を足すと読みやすい」など
- **Suggest changes**: GitHub のレビュー画面で具体的な修正案を提案する
- **改善の例**: 空配列 `[]` を渡したときに分かりやすいエラーを出す (`ArgumentError` など) 

### 相手のブランチに直接 commit する (任意)

全員 **コラボレーター** なので、相手のブランチを checkout して修正を commit → push することもできます (ゼミの指示・相手の了承を得てから) 。

```bash
git fetch origin
git switch 相手のブランチ名
# ファイルを編集
git add submissions/相手のユーザー名.jl
git commit -m "Add docstring to my_mean (review)"
git push origin 相手のブランチ名
```

相手はステップ 3 で `git pull` して取り込みます。

---

## ステップ 3: 他人に直された自分の PR を取り込む

ステップ 2 で自分のブランチに追加 commit が入った場合、**push する前に pull** します。

### 手順

```bash
git switch 自分のブランチ名
git pull origin 自分のブランチ名   # または git pull --rebase (好みで)
git log -p -1                      # 直近の差分を確認
# 必要ならさらに自分で編集
git add ...
git commit -m "Address review feedback"
git push origin 自分のブランチ名
```

### `non-fast-forward` で push が拒否されるとき

リモートのブランチに、自分の手元に **ない commit** があると `git push` が失敗します。**先に `git pull` で取り込む** のが基本です (force push は **禁止** ) 。

```text
! [rejected]        feat/mean-yourusername -> feat/mean-yourusername (non-fast-forward)
```

pull 後にコンフリクトが出たら、エディタで直してから commit → push します。

---

## ステップ 4: コンフリクト解消 (`members.md`)

共有ファイル [**members.md**](members.md) の **表の末尾** に、自分の名前と `my_mean` の計算結果を **1 行** 追加します。全員が同じ「末尾」付近を編集するので、**複数の PR が並ぶとコンフリクト** が自然に起きます。

### やること

1. 自分のブランチで `submissions/members.md` を編集 (末尾に1行追加) 
2. commit → push → (既に PR があれば更新、なければ新規 PR でも可。ゼミの指示に従う) 
3. `main` に先に別の PR がマージされていれば、GitHub またはローカルで **conflict** を解消する:
   - **Cursor** のマージエディタ
   - ターミナル: `git fetch origin` → `git merge origin/main` (または `git rebase origin/main`) 
   - **GitHub** の「Resolve conflicts」 (Web エディタ) 
4. `<<<<<<<` / `=======` / `>>>>>>>` マーカーを消し、**両方の行を残す** など正しい表に直す
5. commit → push して PR を更新する

コンフリクトの考え方とコマンド例は [docs/04_git_github.md §10](../docs/04_git_github.md#10-コンフリクトを解消する-membersmd) を参照してください。

---

## 注意

- 機密情報 (本名・連絡先など) は **書かない**
- 図やメモを PR に載せたい場合は `submissions/` 内に置くか、ゼミの指示に従う
- **マージ** はオーナー・TA の指示どおり (参加者が勝手に merge しない場合があります) 
