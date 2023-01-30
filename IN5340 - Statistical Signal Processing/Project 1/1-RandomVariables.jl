using Statistics
using NaNStatistics
using Plots

N = 10_000

x = rand(N)

mₓ  = sum(x*1/N)
σₓ² = sum((x.-mₓ).^2 * 1/N)

mₓ_builtin = mean(x)
σₓ²_builtin = std(x)^2

step_size = 0.05
edges = 0:step_size:1
bins = histcounts(x, edges)
pdf = (bins)./(maximum(bins).-minimum(bins))
b = bar(edges, bins/N*mₓ, widen=false, bar_width=step_size)