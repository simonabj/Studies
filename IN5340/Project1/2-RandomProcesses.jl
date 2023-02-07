using Statistics
using Plots
using Printf

function rp1(M,N)
    a = 0.02;
    b = 5;
    Mc = ones(M,1)*b*sin.((1:N)*π/N)'
    Ac = a*ones(M,1)*vec(1:N)';
    return (rand(M,N).-0.5).*Mc + Ac
end

function rp2(M,N)
    Ar = rand(M,1)*ones(1,N);
    Mr = rand(M,1)*ones(1,N); 
    return ( rand(M,N) .- 0.5 ).*Mr + Ar;
end

function rp3(M,N)
    a = 0.5;
    m = 3;
    return ( rand(M,N) .- 0.5 ) .* m .+ a;
end

# a)
M = 4; N = 100
r1, r2, r3 = rp1(M,N), rp2(M,N), rp3(M,N)
plot(
    [r1', r2', r3'], layout = (3,1), 
    title=["rp1" "rp2" "rp3"], legend=false,
    background_color=:transparent,
    foreground_color=:white
)
xlabel!("N"); ylabel!("Value")
savefig("rp1.svg")

# b)
M = 80; N = 100
r1, r2, r3 = rp1(M,N), rp2(M,N), rp3(M,N)

means = [mean(r1, dims=1); mean(r2, dims=1);mean(r3, dims=1)]
stds = [std(r1, dims=1); std(r2, dims=1); std(r3, dims=1)]

plot(
    [means', stds'], layout = (2,1),
    label=["rp1" "rp1" "rp2" "rp2" "rp3" "rp3"],
    background_color=:transparent,
    foreground_color=:white,
    title=["Means" "STDs"]
)
savefig("ensemble.svg")

# c) 
M = 4; N = 1000
r1, r2, r3 = rp1(M,N), rp2(M,N), rp3(M,N)

@printf "rp1 | Time averages: [%5.2f, %5.2f, %5.2f, %5.2f]" mean(r1,dims=2)...
@printf "rp2 | Time averages: [%5.2f, %5.2f, %5.2f, %5.2f]" mean(r2,dims=2)...
@printf "rp3 | Time averages: [%5.2f, %5.2f, %5.2f, %5.2f]" mean(r3,dims=2)...

l = @layout [rp1 ; rp2 ; rp3]
h1 = heatmap(r1)
h2 = heatmap(r2)
h3 = heatmap(r3)
plot(
    h1, h2, h3, layout = l,
    title=["rp1" "rp2" "rp3"],
    background_color=:transparent,
    foreground_color=:white
)
savefig("images.svg")