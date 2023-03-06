using Revise
using DSP
using Plots
using Printf

default(background_color=:transparent, foreground_color=:white)

################
# Load the precode
include("precode.jl")

################
# Parameters
P = ParamStruct()

################
# Source, i.e. U(x,y,z_0)

U0 = ASAsource(P, "square", 15*P.lambda)

################
# Define propagator for distance (z-z0)
z = 0.08
Prop = ASApropagator(P, z)

U0 = ifft2t(fft2t(U0).*Prop)
kernel = hanning(5)*hanning(5)'
kernel = kernel/sum(kernel)
U0Mod = conv(U0, kernel)[3:end-2, 3:end-2]


################
# Plot some images or something
sig2db = amp2db ∘ abs

heatmap(
    P.ax, P.ay, 
    U0 .|> sig2db, #abs .|> amp2db,
    xlabel="x [m]",
    ylabel="y [m]",
    clims = (-36 ,3.7),
    colorbar_title=" \nResponse [dB]",
    top_margin=5Plots.mm,
    right_margin=8Plots.mm
)
title!(@sprintf "Wave field at depth z = %.1f cm.\n Estimated using ASA." 100*z)
savefig("1a.svg")

plot(
    P.ax, U0[:, P.Nx÷2] .|> sig2db,
    linewidth=2,
    ylim = maximum(U0 .|> sig2db) .+ (-40, 0),
    xlabel = "x [m]", ylabel="Response [dB]",
    legend = :none
)
title!(@sprintf "Center cut of wave field at depth z = %.1f cm.\n Estimated using ASA." 100*z)
savefig("1b.svg")

# 2?
z = 0.40
dz = 2*P.lambda
nZ = round(z / dz) |> Int
Zs = range(0,z,nZ)
Resp = Complex.(zeros(P.Nx, nZ))

Prop = ASApropagator(P, dz)
U = ifft2t(fft2t(U0Mod) .* Prop)
Resp[:, 1] .= U[:, P.Ny÷2]

for ii = 2:nZ
    if ii % 25 == 0
        print("#")
    end
    global U = ifft2t(fft2t(global U).*Prop)
    Resp[:, ii] .= U[:, P.Ny÷2]
end

Resp

heatmap(
    P.ax, Zs,
    Resp .|> sig2db,
    xlabel="x [m]", ylabel="z [m]",
    clims = (-36 ,3.7),
    colorbar_title=" \nResponse [dB]",
    top_margin=5Plots.mm,
    right_margin=8Plots.mm
)

size(Resp)

plot(
    P.ax, Resp[:, nZ÷2] .|> sig2db
)