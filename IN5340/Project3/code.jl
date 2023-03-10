using Revise
using CairoMakie

nord3 = "#4c566a"
nord4 = "#d8dee9"
set_theme!(Theme(
    font_size = 25,
    Axis = (
        backgroundcolor = :transparent,
        xtickcolor = nord4, ytickcolor = nord4,
        xgridcolor = nord3, ygridcolor = nord3,
        xlabelcolor = nord4, ylabelcolor = nord4,
        xticklabelcolor = nord4, yticklabelcolor = nord4,
        topspinecolor = nord4, bottomspinecolor = nord4,
        leftspinecolor = nord4, rightspinecolor = nord4,
        titlecolor = nord4,
    ),
))

# Test plot
F = Figure(backgroundcolor=:transparent)
a = Axis(F[1,1], title="Nord Test")
lines!(0:0.01:2pi, sin.(0:0.01:2pi))
lines!(0:0.01:2pi, cos.(0:0.01:2pi))
F
save("test.pdf", F)


##########################
# Imports & Preamble 
##########################
using Unitful, MAT, DSP, FFTW
import Unitful: Hz, m, s

toUnit(unit) = x -> uconvert(unit, x)

sonardata = matread("sonardata4.mat")

B     = sonardata["B"]    * Hz
fs    = sonardata["fs"]   * Hz
fc    = sonardata["fc"]   * Hz
T_p   = sonardata["T_p"]  * s
data  = sonardata["data"]
α     = B / T_p 

s_Tx(t) = exp.(1im*2π*α*(t.^2) ./ 2) .* (abs.(t) .< T_p/2)

##########################
# 1
##########################

N = 1024
arr = data[1200:1200+N, 14]

PSD = fft ∘ fftshift ∘ x->abs.(x.*conj(x)).^2 ./ length(x)

Farr = fftshift(fft(arr))
Pₓₓ = abs.(Farr.*conj(Farr)).^2 / N
lines(abs.(Pₓₓ))

win = kaiser(N, 2.2) |> x->x/sum(x)
Pₓₓ2 = 