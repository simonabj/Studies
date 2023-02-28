import VectorizedRoutines.Matlab: repeat, meshgrid
import FFTW: fft, fftshift, ifft, ifftshift

Base.@kwdef struct ParamStruct
    # Simulation grid
    Nx = 1024;       # No of pixels, x-direction
    Ny = 1024;       # No of pixels, y-direction
    # Medium / problem
    fc = 3e6;       # Center frequency, probe
    c = 1500;       # Speed of sound
    lambda = c/fc;  # Wavelength

    # Physical grid
    dx = lambda/2;  # pixel size, x-direction, [m]
    dy = lambda/2;  # pixel size, y-direction, [m]
    Dx = Nx*dx;     # Physical length, x-direction, [m]
    Dy = Ny*dy;     # Physical length, y-direction, [m]

    # Frequency grid
    u = (2*(0:Nx.-1)./Nx.-1); # Defines as in fft
    v = (2*(0:Ny.-1)./Ny.-1); # Aliasing will occure if sampling distance too large

    # Axis
    ax = range(-Dx/2, Dx/2, Nx);
    ay = range(-Dy/2, Dy/2, Ny);
end

function ASAsource(P::ParamStruct, type, vararg...)
    r = vararg[1]
    x,y = meshgrid(P.ax, P.ay)
    U0 = zeros((P.Nx, P.Ny))

    if type == "piston"
        U0[x.^2 + y.^2 .<= r^2] .= 1
    elseif type == "square"
        U0[(abs.(x) .<= r) .& (abs.(y) .<= r)] .= 1
    else
        error("Source type not defined in ASAsource.jl")
    end
    return U0
end

function ASApropagator(P::ParamStruct, z)
    Prop = zeros((P.Nx, P.Ny))
    uSq = repeat((P.u .^2) ,1,P.Ny)
    vSq = repeat((P.v .^2)',P.Nx,1)
    Prop = exp.(1im*2π*z*sqrt.(Complex.(1 .- uSq .- vSq)) ./ P.lambda)
    Prop[uSq + vSq .> 1] .= 0
    return Prop
end

function fft2t(x)
    return fftshift(fft(ifftshift(x), (1,2)))
end

function ifft2t(x)
    return fftshift(ifft(ifftshift(x, (1,2))))
end
