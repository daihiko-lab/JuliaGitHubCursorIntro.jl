using Test

@testset "examples" begin
    @test isfile(joinpath(@__DIR__, "..", "examples", "analyze_survey.jl"))
    # スクリプト全体はパッケージの読み込みと図の保存まで行うため、include で実行
    include(joinpath(@__DIR__, "..", "examples", "analyze_survey.jl"))
end

@testset "submissions" begin
    submissions_dir = joinpath(@__DIR__, "..", "submissions")
    files = filter(re -> endswith(re, ".jl"), readdir(submissions_dir))
    @test !isempty(files)
    for f in files
        @test_nowarn include(joinpath(submissions_dir, f))
    end
end
