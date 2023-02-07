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
σₓ² = std(ms)^2

@printf "mₓ: %.3f" mₓ 
@printf "σₓ²: %.3f" σₓ²

theoretical_pdf = (x) -> 1.0/√(2π*σₓ²)*exp(-(x-mₓ).^2 ./ (2σₓ²))
plot(edges[1:end-1], pdf, seriestype=:steppost, label="Estimate")
plot!(edges[1:end-1], theoretical_pdf.(edges[1:end-1]), label="Theoretical")
plot!(background_color=:transparent,foreground_color=:white)
xlabel!("Value"); ylabel!("Propability")
title!("PDF of CLT experiment with theoretical PDF")
savefig("clt_pdf_theoretical.svg")