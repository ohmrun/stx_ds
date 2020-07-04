package stx.graph.body;

import stx.graph.head.Data.GraphData;

@:forward abstract Graph(GraphData) from GraphData to GraphData{
    static public function unit():Graph{
        return new Graph();
    }
    public function new(?self:GraphData){
        if (self == null){
            self = Graphs.empty();
        }
        this = self;
    }
    @:from static public function fromVertex(v:Vertex):Graph{
        return {
            vertices : RedBlackSets.pure(v,Vertex.ord),
            edges    : RedBlackSets.unit()
        };
    }
    public function connect(that:Graph){
        return Graphs.connect(this,that);
    }
    public function overlay(that:Graph){
        return Graphs.overlay(this,that);
    }
}