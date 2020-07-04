package stx.graph.ifs;

import stx.graph.body.Graph in GraphA;

import stx.graph.Package;

interface Graph<T>{
    public function empty():GraphA;
    public function vertex(x:T):Vertex;
    public function connect(l:GraphA,r:GraphA):GraphA;
    public function overlay(l:GraphA,r:GraphA):GraphA;
}