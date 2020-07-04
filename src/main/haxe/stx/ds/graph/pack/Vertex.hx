package stx.ds.graph.pack;

typedef VertexDef = Int;

@:forward abstract Vertex(VertexDef) from VertexDef to VertexDef{
  static public var _(default,never) = VertexLift;
  static public function set():RedBlackSet<Vertex>{
    return RedBlackSet.make_with(Ord.Int(),Eq.Int());
  }  
  @:op(A==B)
  public function eq(r){
    return this == r;
  }
  @:op(A<B)
  public function lt(r){
    return this < r;
  }
}
class VertexLift{
  static public function product(l:RedBlackSet<Vertex>,r:RedBlackSet<Vertex>):RedBlackSet<Edge>{
    var all = cross(l,r);
    var out = all.fold(
      (n:Edge,m:RedBlackSet<Edge>) -> m.put(n),
      Edge.set()
    );
    return out;
  }
  /**
    taken from stx.Std. Not sure about pulling Iter into Nano, so reproduced here
  **/
  static public function cross<T,Ti>(self:Iterable<T>,that:Iterable<Ti>):Iterable<Couple<T,Ti>>{
    return { iterator : function(){
      var l_it  = self.iterator();
      var r_it  = that.iterator();
      var l_val = null;

      return{
        next : function rec(){
          if(l_val != null &&  l_it.hasNext()){
            l_val = l_it.next();
          } 
          return if(r_it.hasNext()){
            __.couple(l_val,r_it.next());
          }else{
            if(l_it.hasNext()){
              r_it = that.iterator();
            }
            l_val = null;
            rec();
          }
        },
        hasNext: function(){
          return (!l_it.hasNext()) ? r_it.hasNext() : false;
        }
      };
    }
  }}
}