using Statistics
using NaNStatistics
using Printf

N = 10_000
x = rand(Float64, (12, N))

ms = mean(x, dims=1)
step_size = 0.01
edges = 0.0:step_size:1.0
bins = histcounts(ms, edges)
# Normalize PDF
pdf = bins/sum(bins*step_size)
sum(pdf*step_size)

mₓ = mean(ms)
σₓ = std(ms)^2

@printf "mₓ: %.3f" mₓ 
@printf "σₓ²: %.3f" σₓ

plot(edges[1:end-1], pdf, seriestype=:steppre)
plot!(background_color=:transparent,foreground_color=:white)
xlabel!("Value"); ylabel!("Propability")
title!("PDF of CLT experiment")
savefig("clt_pdf.svg")