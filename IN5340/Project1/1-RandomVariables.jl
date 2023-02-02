#%% Import required packages
using Printf
using Statistics
using NaNStatistics
using Plots
using SixelTerm

default(display_type=:inline)
#%% Estimate The moments
N = 10_000

x = rand(N)

mₓ  = sum(x*1/N)
σₓ² = sum((x.-mₓ).^2 * 1/N)

mₓ_builtin = mean(x)
σₓ²_builtin = std(x)^2

@printf "mₓ_err: %.4f" abs(mₓ-mₓ_builtin)
@printf "σₓ²_err: %.4f" abs(σₓ²-σₓ²_builtin)

#%% Now plot them
step_size = 0.05
edges = -0.2:step_size:1.2
bins = histcounts(x, edges)

# Normalize PDF
pdf = bins/sum(bins*step_size)

theoretical_pdf = (x) -> Float64(0 <= x < 1)

#%% Plot the PDF

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
    seriestype=:steppost, label="Theoretical PDF",
    linewidth=2
)
plot!(
    legend=:bottom,
    background_color=:transparent,
    foreground_color=:white
)
title!("PDF of x");xlabel!("Value");
ylabel!("Probability");
savefig("uniform_pdf.svg")

#%% PDF Fulfills 3 properties

# 1.
reduce(&, pdf .>= 0) # true
# 2.
abs(sum(pdf*step_size)-1.0) < 1e-12 # true

#%% Repeating the experiment
r = 10 # Repeat 10 times
xs = rand(Float64, (N,r))

ms = mean(xs, dims=1)
σs = std(xs, dims=1).^2

#%% Plot Repeated experiment
plot(1:r, vec(ms), label="Mean")
plot!(vec(σs), label="Variance")
plot!(foreground_color=:white, background_color=:transparent)
xlabel!("Experiment iteration");ylabel!("Value")

