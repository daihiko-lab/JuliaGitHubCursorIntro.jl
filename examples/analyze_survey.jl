#!/usr/bin/env julia
# 架空アンケートデータの読み込み・集計・可視化の例 (docs/02_julia_basics.md と対応)

using CSV
using DataFrames
using Plots
using Statistics

const DATA_PATH = joinpath(@__DIR__, "..", "data", "survey_responses.csv")
const OUTPUT_DIR = joinpath(@__DIR__, "..", "output")

function main()
    df = CSV.read(DATA_PATH, DataFrame)

    println("行数: ", nrow(df))
    println("列名: ", names(df))

    by_condition = combine(groupby(df, :condition), :score => mean => :mean_score, nrow => :n)
    println("\n条件ごとの平均スコア:")
    show(by_condition; allcols = true, allrows = true)
    println()

    mkpath(OUTPUT_DIR)
    out_path = joinpath(OUTPUT_DIR, "mean_score_by_condition.png")
    p = bar(
        by_condition.condition,
        by_condition.mean_score;
        ylabel = "平均スコア",
        xlabel = "条件",
        title = "条件ごとの平均スコア (架空データ) ",
        legend = false,
    )
    savefig(p, out_path)
    return println("図を保存しました: ", out_path)
end

main()
