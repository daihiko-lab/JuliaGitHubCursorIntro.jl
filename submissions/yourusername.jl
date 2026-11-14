# submissions/yourusername.jl

"""配列 x の算術平均を返す (空配列のときの扱いはステップ 2 で議論してもよい) """
function my_mean(x)
    return sum(x) / length(x)
end

# 呼び出し例 (include 時に実行される)
my_mean([1, 2, 3, 4, 5])
