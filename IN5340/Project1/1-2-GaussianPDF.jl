using Printf
using Statistics
using NaNStatistics
using Plots

N = 10_000
x = randn(N)
mₓ  = sum(x*1/N)
σₓ² = sum((x.-mₓ).^2 * 1/N)

step_size = 0.1
edges = -5.0:step_size:5.0
bins = histcounts(x, edges)
# Normalize PDF
pdf = bins/sum(bins*step_size)
theoretical_pdf = (x) -> 1.0/√(2π)*exp(-x.^2 ./ 2)

plot(
    edges[1:end-1],
    pdf,
    seriestype=:steppost, 
    label="Estimated PDF",
    linewidth=2
)
plot!(
    edges[1:end-1],
    theoretical_pdf.(edges[1:end-1]),
    label="Theoretical PDF",
    linewidth=2
)
plot!(
    legend=:bottom,
    background_color=:transparent,
    foreground_color=:white,
)

title!("PDF of x");xlabel!("Value");
ylabel!("Probability");
savefig("gaussian_pdf.svg")