package stx.graph.body;


import stx.graph.head.data.GraphData;

class Context<T> implements stx.graph.ifs.Graph<T>{
    var map     : Map<Int,T>;
    var eq      : T->T->Bool;

    public function new(eq,?map){
        this.eq     = eq;
        this.map    = map == null ? Map.empty() : map;
    }
    public function empty():GraphData{
        return Graphs.empty();
    }
    public function copier(?map){
        return new Context(this.eq,map == null ? this.map : map);
    }
    public function vertex(val:T):Vertex{
        var vertex  : Vertex = this.map.foldLeftAll(
            None,
            function(b,k,v){
                return switch(b){
                    case None       : if(eq(val,v)){
                        Some(k);
                    }else{
                        None;
                    }
                    case Some(v)    : Some(v);
                }
            }
        ).get();

        if(vertex == null){
            vertex = Vertex.unit();
        }
        return vertex;
    }
    public function put(v:T):Context<T>{
        var vert = vertex(v);
        return copier(map.set(vert.unbox(),v));
    }
    public function get(v:Vertex):Option<T>{
        return map.get(v.unbox());
    }
    public function connect(l:GraphData,r:GraphData):GraphData{
        return Graphs.connect(l,r);
    }
    public function overlay(l:GraphData,r:GraphData):GraphData{
        return Graphs.overlay(l,r);
    }
}