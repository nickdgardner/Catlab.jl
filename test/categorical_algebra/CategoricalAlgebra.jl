module TestCategoricalAlgebra

using Test

@testset "FreeDiagrams" begin
  include("FreeDiagrams.jl")
end

@testset "Limits" begin
  include("Limits.jl")
end

@testset "Matrices" begin
  include("Matrices.jl")
end

@testset "FinSets" begin
  include("FinSets.jl")
end

@testset "FinRelations" begin
  include("FinRelations.jl")
end

@testset "Permutations" begin
  include("Permutations.jl")
end

@testset "PredicatedSets" begin
  include("PredicatedSets.jl")
end

@testset "CSets" begin
  include("CSetDataStructures.jl")
  include("CSets.jl")
end

@testset "StructuredCospans" begin
  include("StructuredCospans.jl")
end

@testset "Squares" begin
  include("Squares.jl")
end

end
