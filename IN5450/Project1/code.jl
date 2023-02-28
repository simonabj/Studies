using Revise
# Start by getting some packages for this project
using DSP; using Plots; using Unitful; using Printf;
using MAT; using LaTeXStrings; using Statistics
import Unitful: Time, s, m, Hz, promote_unit
default(background_color=:transparent, foreground_color=:white)

include("ASAparameters.jl")

toUnit(unit) = x -> uconvert(unit, x)
