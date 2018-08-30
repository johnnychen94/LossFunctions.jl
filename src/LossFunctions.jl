module LossFunctions

using RecipesBase

import Base.*
using Base.Cartesian
using Markdown, SparseArrays, InteractiveUtils

using LearnBase
import LearnBase: value, value!, deriv, deriv2, deriv!, scaled, value_deriv,
    isminimizable,
    isdifferentiable,
    istwicedifferentiable,
    isconvex,
    isstrictlyconvex,
    isstronglyconvex,
    isnemitski,
    isunivfishercons,
    isfishercons,
    islipschitzcont,
    islocallylipschitzcont,
    islipschitzcont_deriv, # maybe overkill
    isclipable,
    ismarginbased,
    isclasscalibrated,
    isdistancebased,
    issymmetric
# Reexport LearnBase
eval(Expr(:toplevel, Expr(:export, setdiff(names(LearnBase), [:LearnBase])...)))

export

    deriv2!,
    value_fun,
    deriv_fun,
    deriv2_fun,
    value_deriv_fun,

    LogitMarginLoss,
    PerceptronLoss,
    HingeLoss,
    L1HingeLoss,
    L2HingeLoss,
    SmoothedL1HingeLoss,
    ModifiedHuberLoss,
    L2MarginLoss,
    ExpLoss,
    SigmoidLoss,
    DWDMarginLoss,

    LPDistLoss,
    L1DistLoss,
    L2DistLoss,
    PeriodicLoss,
    HuberLoss,
    EpsilonInsLoss,
    L1EpsilonInsLoss,
    L2EpsilonInsLoss,
    LogitDistLoss,
    QuantileLoss,
    PinballLoss,

    PoissonLoss,
    LogitProbLoss,
    CrossentropyLoss,
    ZeroOneLoss,

    OrdinalMarginLoss,
    OrdinalHingeLoss,

    weightedloss,

    AvgMode

include("common.jl")
include("averagemode.jl")

include("supervised/supervised.jl")
include("supervised/sparse.jl")
include("supervised/distance.jl")
include("supervised/margin.jl")
include("supervised/scaledloss.jl")
include("supervised/weightedbinary.jl")
include("supervised/other.jl")
include("supervised/ordinal.jl")
include("supervised/io.jl")

# allow using some special losses as function
(loss::ScaledSupervisedLoss)(args...) = value(loss, args...)
(loss::WeightedBinaryLoss)(args...)   = value(loss, args...)

# allow using SupervisedLoss as function
for T in filter(isconcretetype, subtypes(SupervisedLoss))
    @eval (loss::$T)(args...) = value(loss, args...)
end

# allow using MarginLoss and DistanceLoss as function
for T in union(subtypes(DistanceLoss), subtypes(MarginLoss))
    @eval (loss::$T)(args...) = value(loss, args...)
end

end # module
