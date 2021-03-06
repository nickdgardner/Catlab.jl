module TestBasicGraphs
using Test

import LightGraphs
using Catlab.Graphs.BasicGraphs

# Graphs
########

g = Graph()
@test keys(g.indices) == (:src,:tgt)
add_vertex!(g)
add_vertices!(g, 2)
@test nv(g) == 3
@test ne(g) == 0

add_edge!(g, 1, 2)
add_edge!(g, 2, 3)
@test ne(g) == 2
@test ne(g, 1, 2) == 1
@test has_edge(g, 1, 2)
@test !has_edge(g, 1, 3)
@test outneighbors(g, 2) == [3]
@test inneighbors(g, 2) == [1]
@test collect(all_neighbors(g, 2)) == [1,3]

add_edge!(g, 1, 2)
@test ne(g) == 3
@test ne(g, 1, 2) == 2
@test collect(edges(g, 1, 2)) == [1,3]
@test outneighbors(g, 1) == [2,2]
@test inneighbors(g, 1) == []
@test LightGraphs.DiGraph(g) == LightGraphs.path_digraph(3)

g = Graph(4)
add_edges!(g, [1,2,3], [2,3,4])
@test LightGraphs.DiGraph(g) == LightGraphs.path_digraph(4)

rem_edge!(g, 3, 4)
@test ne(g) == 2
@test src(g) == [1,2]
@test tgt(g) == [2,3]
rem_vertex!(g, 2)
@test nv(g) == 3
@test ne(g) == 0

# Symmetric graphs
##################

g = SymmetricGraph()
@test keys(g.indices) == (:src,)

add_vertices!(g, 3)
@test nv(g) == 3
@test ne(g) == 0

add_edge!(g, 1, 2)
add_edge!(g, 2, 3)
@test ne(g) == 4
@test collect(edges(g, 1, 2)) == [1]
@test neighbors(g, 1) == [2]
@test neighbors(g, 2) == [1,3]
@test neighbors(g, 3) == [2]
@test LightGraphs.Graph(g) == LightGraphs.path_graph(3)

g = SymmetricGraph(4)
add_edges!(g, [1,2,3], [2,3,4])
lg = LightGraphs.DiGraph(4)
map((src, tgt) -> add_edge!(lg, src, tgt), [1,2,3,2,3,4], [2,3,4,1,2,3])
@test LightGraphs.DiGraph(g) == lg

rem_edge!(g, 3, 4)
@test ne(g) == 4
@test neighbors(g, 3) == [2]
@test neighbors(g, 4) == []
rem_vertex!(g, 2)
@test nv(g) == 3
@test ne(g) == 0

# Reflexive graphs
##################

g = ReflexiveGraph()
add_vertex!(g)
add_vertices!(g, 2)
@test nv(g) == 3
@test ne(g) == 3
@test refl(g,1) == 1
@test refl(g) == [1,2,3]
@test src(g) == [1,2,3]
@test tgt(g) == [1,2,3]

add_edges!(g, [1,2], [2,3])
add_edge!(g, 1, 3)
@test ne(g) == 6
@test src(g, 4:6) == [1,2,1]
@test tgt(g, 4:6) == [2,3,3]

g = ReflexiveGraph(4)
add_edges!(g, [1,2,3], [2,3,4])
rem_edge!(g, 3, 4)
@test ne(g) == 6
@test src(g, 5:6) == [1,2]
@test tgt(g, 5:6) == [2,3]
rem_vertex!(g, 2)
@test nv(g) == 3
@test ne(g) == 3
@test refl(g) == [1,2,3]
@test src(g) == [1,2,3]
@test tgt(g) == [1,2,3]

# Symmetric reflexive graphs
############################

g = SymmetricReflexiveGraph()
add_vertex!(g)
add_vertices!(g, 2)
@test nv(g) == 3
@test refl(g) == [1,2,3]
@test inv(g) == [1,2,3]
@test src(g) == [1,2,3]
@test tgt(g) == [1,2,3]

add_edge!(g, 1, 3)
@test ne(g) == 5
@test src(g, 4:5) == [1,3]
@test tgt(g, 4:5) == [3,1]
@test inv(g, 4:5) == [5,4]

g = SymmetricReflexiveGraph(4)
add_edges!(g, [1,2,3], [2,3,4])
rem_edge!(g, 3, 4)
@test ne(g) == 8
rem_vertex!(g, 2)
@test nv(g) == 3
@test ne(g) == 3

# Half-edge graphs
##################

g = HalfEdgeGraph()
@test keys(g.indices) == (:vertex,)

add_vertices!(g, 2)
@test nv(g) == 2
@test isempty(half_edges(g))

add_edge!(g, 1, 2)
add_edge!(g, 2, 1)
@test collect(half_edges(g)) == [1,2,3,4]
@test vertex(g) == [1,2,2,1]
@test inv(g) == [2,1,4,3]
@test half_edges(g, 1) == [1,4]
@test half_edges(g, 2) == [2,3]

add_dangling_edge!(g, 1)
add_dangling_edges!(g, [2,2])
@test length(half_edges(g)) == 7
@test vertex(g, 5:7) == [1,2,2]
@test inv(g, 5:7) == [5,6,7]

g = HalfEdgeGraph(4)
add_edges!(g, [1,2,3], [2,3,4])
lg = LightGraphs.Graph(4)
map((src, tgt) -> add_edge!(lg, src, tgt), [1,2,3], [2,3,4])
@test LightGraphs.Graph(g) == lg

rem_edge!(g, 3, 4)
@test Set(zip(vertex(g), vertex(g,inv(g)))) == Set([(1,2),(2,1),(2,3),(3,2)])
add_edge!(g, 3, 4)
rem_edge!(g, last(half_edges(g)))
@test Set(zip(vertex(g), vertex(g,inv(g)))) == Set([(1,2),(2,1),(2,3),(3,2)])
rem_vertex!(g, 2)
@test nv(g) == 3
@test isempty(half_edges(g))

end
