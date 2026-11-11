#!/usr/bin/env julia
# 架空アンケートデータの読み込み・集計・可視化 (docs/02_julia_basics.md と対応)

const _ROOT = dirname(@__DIR__)
using Pkg
Pkg.activate(_ROOT)

using JuliaGitHubCursorIntro

JuliaGitHubCursorIntro.run_survey_analysis!()
