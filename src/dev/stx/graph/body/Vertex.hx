package stx.graph.body;

import stx.graph.head.data.Vertex in VertexT;

abstract Vertex(VertexT) from VertexT{
    static var counter : Int;
    static public function unit():Vertex{
        if(counter == null){
            counter = 0;
        }
        var id = counter;
        counter++;

        return id;
    }
    function new(self){
        this = self;
    }
    public function unbox():Int{
        return this;
    }
    static public function ord(l:Vertex,r:Vertex):Ordering{
        return l.unbox() > r.unbox() ? GT : (l.unbox() == r.unbox()) ? EQ : LT;
    }
    static public function union(l:RedBlackSet<Vertex>,r:RedBlackSet<Vertex>):RedBlackSet<Vertex>{
        return l.foldLeft(
            r,
            function(memo,next){
                return memo.insert(next,ord);
            }
        );
    }
    static public function product(l:RedBlackSet<Vertex>,r:RedBlackSet<Vertex>):RedBlackSet<Edge>{
        var out =  l.toList().cross(r.toList()).map(
            function(arr):Edge{
                return tuple2(arr[0].unbox(),arr[1].unbox());
            }
        ).foldLeft(
            (Tip:RedBlackSet<Edge>),
            function(memo,next){
                return memo.insert(next,Edge.ord);
            }
        );
        return out;
    }
}