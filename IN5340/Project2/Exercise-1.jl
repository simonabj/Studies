using Revise
# Start by getting some packages for this project
using DSP; using Plots; using Unitful; 
using MAT; using LaTeXStrings
import Unitful: Time, s, m, Hz, promote_unit
default(background_color=:transparent, foreground_color=:white)

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
    t,    
    real.(s_Tx.(t)),
    label="Re",
    xlabel="Pulse Time",
    ylabel="Pulse Value",
    legend=:bottom
)
plot!(
    t, imag.(s_Tx.(t)),
    label="Im",
)
savefig("1b.svg")

# Define a function for the match filtering
match_filter(ch,signal) = xcorr(ch, signal, padmode=:longest)[end÷2+1:end]

ml₁ = match_filter(data[:, 1], s_Tx.(t))
plot(
    axes(ml₁,1)/upreferred(fs),
    abs.(ml₁),
    xlabel="Time", ylabel="Cₓₛ",
    unitformat=:square
)
savefig("1b2.svg")

# We map the cross correlation to all channels
compressed = mapslices(
    ch -> match_filter(ch, s_Tx.(t)),
    data[1:1600,:], dims=(1,)) 

heatmap(
    axes(compressed,2), axes(compressed,1)/upreferred(fs), 
    amp2db.(abs.(compressed)/maximum(abs.(compressed))),
    # Just label & style
    clims=(-50, 0), colorbar_title=" \nResponse [dB]",
    ylabel="Time", xlabel="Channel", unitformat=:square,
    right_margin=8Plots.mm, title="Compressed data"
)
savefig("1c.svg")

ps = plot(
    [
        plot((1:1600)/upreferred(fs), abs.(d[1:1600,1]), 
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
s1 = s_Tx.(t)

τ₀ = mapslices(x -> mle(x,s1), data[1:1600,:], dims=(1,))
data_x4 = resample(data[1:1600,:], 4, dims=(1,))
data_x8 = resample(data[1:1600,:], 8, dims=(1,))

s4 = resample(s1, 4, dims=(1,))
s8 = resample(s1, 8, dims=(1,))

τₓ₄ = mapslices(x -> mle(x, s4), data_x4, dims=(1,))
τₓ₈ = mapslices(x -> mle(x, s8), data_x8, dims=(1,))

plot( uconvert.(u"ms",τ₀'/fc), xlabel="Channel",)
plot!( uconvert.(u"ms",τₓ₄'/4fc), xlabel="Channel",)
plot!( uconvert.(u"ms",τₓ₈'/8fc), xlabel="Channel",)