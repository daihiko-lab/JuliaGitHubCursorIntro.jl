using Aqua
using JuliaGitHubCursorIntro
using Statistics
using Test

@testset "Aqua" begin
    Aqua.test_all(JuliaGitHubCursorIntro)
end

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
        path = joinpath(submissions_dir, f)
        @testset f begin
            mod = Module()
            @test_nowarn Base.include(mod, path)
            @test isdefined(mod, :my_mean)
            sample = [1.0, 2.0, 3.0, 4.0, 5.0]
            @test Base.invokelatest(mod.my_mean, sample) ≈ mean(sample)
        end
    end
end
