package stx.graph.body;

import stx.graph.head.Data.GraphData;

class Graphs{
    static public function empty():GraphData{
        return {
            vertices : Tip,
            edges    : Tip
        };
    }
    static public function GraphData(g:Graph,list:List<Vertex>):Graph{
        return switch(list){
            case Cons(x,xs) : path(g,List.singleton(x).concat(xs).concat(List.singleton(x)));
            default         : g;
        }
    }
    static public function fromEdgeList(g:GraphData,arr:List<Couple<Vertex,Vertex>>):GraphData{
        var edge = function(l:Vertex,r:Vertex){
            return connect((l:Graph),(r:Graph));
        }.tupled();
        return arr.foldLeft(
            g,
            function(memo:GraphData,next:Couple<Vertex,Vertex>){
                return overlay(
                    memo,
                    overlay(Graph.unit(),edge(next))
                );
            }
        );
    }
    static public function path(g:GraphData,list:List<Vertex>):GraphData{
        return switch(list){
            case Nil                : g;
            case Cons(x,Nil)        : (x:Graph);
            case _         :
                fromEdgeList(
                    g,
                    list.zip(list.tail()).map(
                        function(tp){
                            return tuple2(tp._0,tp._1);
                        }
                    )
                );
        }
    }
    static public function overlay(l:GraphData,r:GraphData):GraphData{
        var next_vertices   = Vertex.union(l.vertices,r.vertices);
        var next_edges      = Edge.union(l.edges,r.edges);
        return {
            vertices    : next_vertices,
            edges       : next_edges
        };
    }
    static public function connect(l:GraphData,r:GraphData):GraphData{
        var next_vertices   = Vertex.union(l.vertices,r.vertices);
        var next_edges      = 
            Edge.union(
                Edge.union(l.edges,r.edges),
                Vertex.product(l.vertices,r.vertices)
            );
            
        return {
            vertices : next_vertices,
            edges    : next_edges     
        };
    }
    static public function biconnect(l:GraphData,r:GraphData):GraphData{
        return overlay(connect(l,r),connect(r,l));
    }
    /*
    static public function vertices(l:Graph,b:Iterable<Vertex>){
        return b.foldRight(
            l,
            function(memo,next){
                return 
            }
        );
    }*/
}