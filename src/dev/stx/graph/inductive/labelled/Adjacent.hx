package stx;

import stx.pico.Nada;
using stx.Tuple;


import stx.data.Adjacent in TAdjacent;

@:forward abstract Adjacent<T>(TAdjacent<T>) from TAdjacent<T> to TAdjacent<T>{
  @:from static public function fromArrayOfTuples<A>(arr:Array<Couple<A,Int>>):Adjacent<A>{
    var out = arr.map(
      function(l,r){
        var l0 : A    = l;
        var r0 : Node = r;
        return new Edge(tuple2(l,r));
      }.tupled()
    );
    return new Adjacent(out);
  }
  @:from static public function fromArrayOfNodes<A>(arr:ReadonlyArray<Node>):Adjacent<Nada>{
    var out = arr.map(
      function(n):Edge<Nada>{
        var edge : Edge<Nada> = n;
        return n;
      }
    );
    return new Adjacent(out);
  }
  @:from static public function fromEdge<A>(e:Edge<A>):Adjacent<A>{
    return [e];
  }
  public function new(?self){
    this = self;
    if(this == null){
      this = [];
    }
  }
  public function snoc(key:Node,val:T):Adjacent<T>{
    return this.append(tuple2(val,key));
  }
  public function and(adjacent:Adjacent<T>):Adjacent<T>{
    return this.concat(adjacent);
  }
  public function to<U>(n:Node):Context<T,U>{
    return new Context().withNode(n).withIncoming(this);
  }
  public function from<U>(n:Node):Context<T,U>{
    return new Context().withNode(n).withOutgoing(this);
  }
}
