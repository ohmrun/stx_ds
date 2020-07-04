package stx.ds.graph.pack;

typedef EdgeDef = Couple<Vertex,Vertex>;

@:forward abstract Edge(EdgeDef) from EdgeDef to EdgeDef{
  static public function set():RedBlackSet<Edge>{
    return RedBlackSet.make_with(
      Ord.Anon(
        (l:Edge,r:Edge) -> switch([l.tup(),r.tup()]){
          case [tuple2(a0,b0),tuple2(a1,b1)] : 
            (a0 < a1 || b0 < b1) || (a0 < a1 && b0 < b1);
        }
      ),
      Eq.Anon(
        (l:Edge,r:Edge) -> switch([l.tup(),r.tup()]){
          case [tuple2(a0,b0),tuple2(a1,b1)] : a0 == b0 && a1 == b1;
        }
      )
    );
  }  
}
