"""
    JuliaGitHubCursorIntro

ゼミ向け Julia / GitHub / Cursor 入門教材用パッケージです。
**General レジストリには登録しません** (教材リポジトリ内で `] activate .` して使う構成) 。
"""
module JuliaGitHubCursorIntro

using CSV
using DataFrames
using Plots
using Statistics

export greet, output_dir, pkg_root, run_survey_analysis!, survey_data_path

"""教材用の短い挨拶文字列を返す。"""
greet() = "Julia / GitHub / Cursor 入門 (2026) "

"""パッケージ (リポジトリ) ルートの絶対パス。"""
pkg_root() = dirname(@__DIR__)

survey_data_path() = joinpath(pkg_root(), "data", "survey_responses.csv")

output_dir() = joinpath(pkg_root(), "output")

"""
    run_survey_analysis!()

架空アンケート CSV を読み込み、条件ごとの平均を表示し、棒グラフを `output/` に保存する。
"""
function run_survey_analysis!()
    df = CSV.read(survey_data_path(), DataFrame)

    println("行数: ", nrow(df))
    println("列名: ", names(df))

    by_condition = combine(groupby(df, :condition), :score => mean => :mean_score, nrow => :n)
    println("\n条件ごとの平均スコア:")
    show(by_condition; allcols = true, allrows = true)
    println()

    mkpath(output_dir())
    out_path = joinpath(output_dir(), "mean_score_by_condition.png")
    p = bar(
        by_condition.condition,
        by_condition.mean_score;
        ylabel = "Mean score",
        xlabel = "Condition",
        title = "Mean score by condition (fictional data)",
        legend = false,
    )
    savefig(p, out_path)
    println("Saved figure: ", out_path)
    return out_path
end

end # module
