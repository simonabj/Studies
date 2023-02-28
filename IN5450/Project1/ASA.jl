using Revise
using Unitful
using Plots
using DSP
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

U = ifft2t(fft2t(U0).*Prop)

################
# Plot some images or something
heatmap(
    P.ax, P.ay, 
    U .|> abs .|> amp2db,
    xlabel="x [m]",
    ylabel="y [m]",
    clims = (-36 ,3.7),
    colorbar_label=" \nResponse [dB]",
    top_margin=5Plots.mm,
    right_margin=8Plots.mm
)
title!(@sprintf "Center cut of wave field at depth z = %.1f cm.\n Estimated using ASA." 100*z)

l = @layout []