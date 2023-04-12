using Unitful
import Unitful: °, m, Hz, s

N = 100
M = 10

SNR1 = 0
SNR2 = 0

θ₁ = 0°
θ₂ = -10°

γ = 45° # Degree phase shift between sources

d = 0.5m  # Element spacing in array
k = 2π/m  # Normalized wavenumber

T = 0.5s   # Sampling Interval
ω₁ = 2π*Hz # Normalized frequency
ω₂ = 2π*Hz # Normalized frequency (2)

noise = randn(M,N) + 1im*randn(M,N)

amp1 = sqrt(2)*10^(SNR1/20)
amp2 = sqrt(2)*10^(SNR2/20)

ϕ₁ = -k*d*sin(θ₁)
ϕ₂ = -k*d*sin(θ₂)

a1 = exp(1im*ϕ₁) .^ (0:M-1)
a2 = exp(1im*ϕ₂) .^ (0:M-1)
A = [a1 a2]

phase1 = 1im*2π*rand(N,1)
phase2 = 1im*2π*rand(N,1)

# Uncomment to make sources coherent
# phase2 = phase1

signal1 = amp1*exp.(phase1).*exp(1im*ω₁*T).^(0:N-1)
signal2 = amp2*exp.(1im*γ)*exp.(phase2).*exp(1im*ω₂*T).^(0:N-1)

S = [signal1 signal2]'

x = A*S + noise

println("Signal 1:    amplitude $amp1, frequency $(ω₁/2π), direction of arrival $θ₁")
println("Signal 2:    amplitude $amp2, frequency $(ω₂/2π), direction of arrival $θ₂, rel. phase $γ")
println("Noise: standard deviation $(sqrt(1+1))")
println("Output vector x is size $M elements by $N time samples")