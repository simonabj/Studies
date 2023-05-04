using Statistics, LaTeXStrings, DSP, StatsBase
using Formatting, MAT, FFTW, Unitful, LinearAlgebra
import Unitful: m, s, Hz, AbstractQuantity

matfile = matread("mimo_project.mat")

Nᵣₓ = matfile["N_rx"] |> Int
Nₜₓ = matfile["N_tx"] |> Int
Nₜ  = matfile["N_t"]  |> Int

c   = matfile["c"] * m/s
B   = matfile["B"] * Hz
fs  = matfile["fs"] * Hz
fc  = matfile["fc"] * Hz
Tₚ  = matfile["T_p"] * s

tₓ_pos = vec(matfile["tx_pos"] * m)
rₓ_pos = vec(matfile["rx_pos"] * m)

tdma_data = matfile["tdma_data"]
cdma_data = matfile["cdma_data"];

α = B/Tₚ
S_up   = (t -> @. exp(1im*2π*((fc - B/2)*t + α*t^2/2)))(0s:1/fs:Tₚ);
S_down = (t -> @. exp(1im*2π*((fc + B/2)*t - α*t^2/2)))(0s:1/fs:Tₚ);

match_filter(x, y) = conv(x, reverse(conj(y)))[length(y)÷2+1:end-(length(y)÷2)]

v_pos1 = map(x->(x+tₓ_pos[1]) / 2, rₓ_pos)
v_pos2 = map(x->(x+tₓ_pos[2]) / 2, rₓ_pos)
v_pos = sort([v_pos1; v_pos2])

δr = c/2B

λ = c/fc
L₁ = v_pos1[end] - v_pos1[1]
Lₐ = v_pos[end] - v_pos[1]

@show δβ₁ = λ/2L₁;
@show δβₐ = λ/2Lₐ;
@show δβ₁_4m = δβ₁*4m;
@show δβₐ_4m = δβₐ*4m;

X = (-5:δβₐ/10:5)m
Y =  0m:δr/5:5m
grid = [ [i,j] for i=X, j=Y ]
mfdata = mapslices(channel -> match_filter(channel, S_up), tdma_data, dims=(1,))

results = zeros(size(grid))

ccall((:DAS, "./DAS.so"), Cvoid,
    (Ptr{ComplexF64}, Ptr{ComplexF64}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Cint, Cdouble, Cdouble),
    results, mfdata, ustrip.(collect(X)), ustrip.(collect(Y)), size(grid,1), size(grid,2), rₓ_pos, tₓ_pos, Nₜ, Nᵣₓ, Nₜₓ, ustrip(c), ustrip(fs))