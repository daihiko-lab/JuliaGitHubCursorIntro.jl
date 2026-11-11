using JuliaGitHubCursorIntro
using Test

@testset "JuliaGitHubCursorIntro" begin
    @test occursin("Julia", JuliaGitHubCursorIntro.greet())
    @test isfile(JuliaGitHubCursorIntro.survey_data_path())
end

@testset "survey analysis" begin
    out = JuliaGitHubCursorIntro.run_survey_analysis!()
    @test out isa String
    @test isfile(out)
    @test endswith(out, "mean_score_by_condition.png")
end

@testset "submissions" begin
    submissions_dir = joinpath(pkgdir(JuliaGitHubCursorIntro), "submissions")
    files = filter(re -> endswith(re, ".jl"), readdir(submissions_dir))
    @test !isempty(files)
    for f in files
        @test_nowarn include(joinpath(submissions_dir, f))
    end
end
