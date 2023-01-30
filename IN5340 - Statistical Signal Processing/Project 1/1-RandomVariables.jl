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
edges = -0.2:step_size:1.2
bins = histcounts(x, edges)
pdf = bins/sum(bins*step_size)

theoretical_pdf = (x) -> Float64(0 <= x < 1)

plot(edges[1:end-1], pdf, seriestype=:steppost, label="Estimated PDF")
plot!(edges[1:end-1],theoretical_pdf.(edges[1:end-1]),seriestype=:steppost,label="Theoretical PDF")
plot!(legend=:bottom,background_color=:transparent,foreground_color=:white)
title!("PDF of x")
xlabel!("Value")
ylabel!("Probability")
savefig("pdf_plot.png")