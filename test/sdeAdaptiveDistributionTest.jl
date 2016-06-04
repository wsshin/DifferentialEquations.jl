using DifferentialEquations, Stats, Distributions, HypothesisTests
prob = linearSDEExample()
srand(200)
T = 1
N = 1000
M=10
ps = Vector{Float64}(M)


for j = 1:M
  Wends = Vector{Float64}(N)
  for i = 1:N
    println("$j $i")
    sol =solve(prob::SDEProblem,[0,T],Δt=1//2^(4),fullSave=true,alg="SRI",adaptive=true,abstol=1e-2,reltol=0,adaptiveAlg="RSwM1")
    Wends[i] = sol.WFull[end]
  end
  kssol = ApproximateOneSampleKSTest(Wends/sqrt(T), Normal())
  ps[j] = pvalue(kssol) #Should be not significant (most of the time)
end

bool1 = sum(ps .> 0.05) > length(ps)/2 ### Make sure more passes than fails

for j = 1:M
  Wends = Vector{Float64}(N)
  for i = 1:N
    println("$j $i")
    sol =solve(prob::SDEProblem,[0,T],Δt=1//2^(4),fullSave=true,alg="SRI",adaptive=true,abstol=1e-2,reltol=0,adaptiveAlg="RSwM2")
    Wends[i] = sol.WFull[end]
  end
  kssol = ApproximateOneSampleKSTest(Wends/sqrt(T), Normal())
  ps[j] = pvalue(kssol) #Should be not significant (most of the time)
end

bool2 = sum(ps .> 0.05) > length(ps)/2 ### Make sure more passes than fails

for j = 1:M
  Wends = Vector{Float64}(N)
  for i = 1:N
    println("$j $i")
    sol =solve(prob::SDEProblem,[0,T],Δt=1//2^(4),fullSave=true,alg="SRI",adaptive=true,abstol=1e-2,reltol=0,adaptiveAlg="RSwM3")
    Wends[i] = sol.WFull[end]
  end
  kssol = ApproximateOneSampleKSTest(Wends/sqrt(T), Normal())
  ps[j] = pvalue(kssol) #Should be not significant (most of the time)
end

bool3 = sum(ps .> 0.05) > length(ps)/2 ### Make sure more passes than fails















#println(ApproximateOneSampleKSTest(randn(N), Normal()))


Wends = Vector{Float64}(N)
for i = 1:N
  sol =solve(prob::SDEProblem,[0,T],Δt=1//2^(4),fullSave=true,alg="SRI",adaptive=true,abstol=1e-2,reltol=0,adaptiveAlg="RSwM3")
  Wends[i] = sol.WFull[end]
end

#Gadfly QQ-plot
using Gadfly
import Gadfly.ElementOrFunction
# First add a method to the basic Gadfly.plot function for QQPair types (generated by Distributions.qqbuild())
Gadfly.plot(qq::QQPair, elements::ElementOrFunction...) = Gadfly.plot(x=qq.qx, y=qq.qy, Geom.point, Theme(highlight_width=0px), elements...)

qqplot(x, y, elements::ElementOrFunction...) = Gadfly.plot(qqbuild(x, y), elements...)
qqnorm(x, elements::ElementOrFunction...) = qqplot(Normal(), x, Guide.xlabel("Theoretical Normal quantiles"), Guide.ylabel("Observed quantiles"), elements...)
qqplot(Wends/sqrt(T),randn(N))
kssol = ApproximateOneSampleKSTest(Wends/sqrt(T), Normal())
ps = pvalue(kssol) #Should be not significant (most of the time)
