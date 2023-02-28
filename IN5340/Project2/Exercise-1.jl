using Revise
# Start by getting some packages for this project
using DSP; using Plots; using Unitful; using Printf;
using MAT; using LaTeXStrings; using Statistics
import Unitful: Time, s, m, Hz, promote_unit
default(background_color=:transparent, foreground_color=:white)

toUnit(unit) = x -> uconvert(unit, x)

# Import the MAT file 
mat_file = matopen("sonardata2.mat")

B    = read(mat_file, "B")    * Hz
fs   = read(mat_file, "fs")   * Hz
c    = read(mat_file, "c")    * m/s
T_p  = read(mat_file, "T_p")  * s
fc   = read(mat_file, "fc")   * Hz
t_0  = read(mat_file, "t_0")  * s
data = read(mat_file, "data")

# Signal model
α = B / T_p

s_Tx(t::Time) = (-T_p/2<=t<=T_p/2) ? exp(2π*α*t^2/2 * im) : 0.0im
s_Tx(t) = s_Tx(t*s) # Convert any input to Time

# Plot simple signal
t = -T_p/2 : 1/fs : T_p/2
plot(
    t .|> toUnit(u"ms"),    
    real.(s_Tx.(t)),
    label="Re",
    xlabel="Pulse Time",
    ylabel="Pulse Value",
    legend=:bottom,
    unitformat=:square
)
plot!(
    t .|> toUnit(u"ms"), imag.(s_Tx.(t)),
    label="Im"
)
savefig("1b.svg")

# Define a function for the match filtering
match_filter(ch,signal) = xcorr(ch, signal, padmode=:longest)[end÷2+1:end]

ml₁ = match_filter(data[:, 1], s_Tx.(t))
plot(
    axes(ml₁,1)/upreferred(fs),
    abs.(ml₁),
    xlabel="Time", ylabel="Cₓₛ",
    unitformat=:square, title="Match-filtered signal on channel 1"
)
savefig("1b2.svg")

# We map the cross correlation to all channels
compressed = mapslices(
    ch -> match_filter(ch, s_Tx.(t)),
    data[1:1600,:], dims=(1,)) 

heatmap(
    axes(compressed,2), axes(compressed,1)/fs .|> toUnit(u"ms") , 
    amp2db.(abs.(compressed)/maximum(abs.(compressed))),
    # Just label & style
    clims=(-50, 0), colorbar_title=" \nResponse [dB]",
    ylabel="Time", xlabel="Channel", unitformat=:square,
    right_margin=8Plots.mm, title="Compressed data"
)
savefig("1c.svg")

ps = plot(
    [
        plot((1:1600)/fs .|> toUnit(u"ms"), abs.(d[1:1600,1]), 
        unitformat=:square, xlabel="Time", ylabel="Value")
        for d in [data, compressed]
    ]...,
    layout=[1,1],
)
plot!(ps[1], title="Raw")
plot!(ps[2], title="Compressed")
savefig("1c2.svg")


# 1d
mle(ch, signal) = match_filter(ch, signal) .|> abs |> argmax
s0 = s_Tx.(t)
s4 = resample(s0, 4, dims=(1,))
s8 = resample(s0, 8, dims=(1,))

data_x0 = data[1:1600,:]
data_x4 = resample(data[1:1600,:], 4, dims=(1,))
data_x8 = resample(data[1:1600,:], 8, dims=(1,))

τₓ₀ = mapslices(x -> mle(x, s0), data_x0, dims=(1,))
τₓ₄ = mapslices(x -> mle(x, s4), data_x4, dims=(1,))
τₓ₈ = mapslices(x -> mle(x, s8), data_x8, dims=(1,))

plot( uconvert.(u"ms",τₓ₀'/ fs), label="1x sample")
plot!(uconvert.(u"ms",τₓ₄'/4fs), label="4x sample")
plot!(uconvert.(u"ms",τₓ₈'/8fs), label="8x sample")
plot!(xlabel="Channel", ylabel="Time Delay [ms]")
title!("Time delay of peak per channel")
savefig("1d.svg")

β²ᵣₘₛ = (2π)^2*fc^2
Signal = map(ch -> abs.(compressed[τₓ₀[ch], ch]), 1:32)
Noise =  map(ch -> abs.(compressed[1:1600 .!= τₓ₀[ch], ch]), 1:32) .|> mean
SNR = Signal./Noise

CRLB = 1 ./ (SNR.*β²ᵣₘₛ)
std = sqrt.(CRLB) .|> x -> uconvert(u"µs", x)
plot(std, xlabel="Channel", ylabel="Lower bound", unitformat=:square)
title!("Lower bound on accuracy per channel")
savefig("2.svg")

waveperiod = 1/fs |> toUnit(u"µs")
res = [minimum(std)/waveperiod, maximum(std)/waveperiod]
@printf "Lower limit for accuracy: (%.3f - %.3f) wave periods" res...

plot(τₓ₀'/ fs .|> toUnit(u"ms"), label="Time delay")
plot!(xlabel="Channel", ylabel="Time Delay [ms]")
plot!(
    twinx(), 1:32, std ./ 1u"µs", 
    legend=:topright, color=:darkorange, 
    label="CRLB", ylabel="CRLB [µs]"
)
savefig("2b.svg")


# 3
upsample = 8

x = resample(compressed[:,1], upsample) .|> abs .|> x->x^2
N = size(x,1)

# Index 1:N on boolian check
fwhm_filter = x .>= 0.5maximum(x)
fwhm_t = ((1:N)./(upsample*fs))[fwhm_filter] .|> toUnit(u"ms")
fwhm_x = x[fwhm_filter] .|> log

H = [r^c for r=fwhm_t, c=0:2]
θ = ustrip(H) \ fwhm_x ./ unit.(H[1,:])

σ = sqrt(-1/(2θ[3]))
τ = -θ[2] / 2θ[3]
I = exp(θ[1] - θ[2]^2/4θ[3])

g(t) = I*exp(-(t-τ)^2/(2σ^2))

ns = 1100:1200
pulse_t = ns ./ (upsample * fs) .|> toUnit(u"ms")
plot(pulse_t, x[ns], label="8x sampled data",
            xlabel="Time", ylabel="Intensity", unitformat=:square,
            title="Water column peak w/ estimated Gaussian"
)
plot!(pulse_t, g.(pulse_t), label="Gaussian fit")
savefig("3a.svg")

function lse(samples, upsample=8)
    x = resample(samples, upsample) .|> abs .|> x->x^2
    N = size(x,1)

    fwhm_filter = x .>= 0.5maximum(x)
    fwhm_t = ((1:N) ./ (upsample*fs))[fwhm_filter] .|> toUnit(u"ms")
    fwhm_x = x[fwhm_filter] .|> log

    H = [r^c for r=fwhm_t, c=0:2]
    θ = ustrip(H) \ fwhm_x ./ unit.(H[1,:])
    return sqrt(-1/(2θ[3])), -θ[2] / 2θ[3], exp(θ[1] - θ[2]^2/4θ[3])
end

# 3b

τ_lse = mapslices(
    ch -> lse(ch)[2], # For each channel, get the 2nd parameter from lse
    compressed,
    dims=1
)

plot(τ_lse', ylabel="Time delay", xlabel="Channel", unitformat=:square, title="LSE Time delay estimation", label="LSE")
savefig("3b.svg")

plot(10:20, τ_lse'[10:20], ylabel="Time delay", xlabel="Channel", unitformat=:square, label="LSE")
plot!(10:20, uconvert.(u"ms",τₓ₈'/8fs)[10:20], label="MLE")
plot!(xticks=10:20, title="Time delay estimate comparison")
savefig("3b2.svg")