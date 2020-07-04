package stx;

using stx.Tuple;
import tink.core.Noise;

import stx.data.Edge in TEdge;

@:forward abstract Edge<T>(TEdge<T>) from TEdge<T> to TEdge<T>{
  static public function create<T>(label:T,node:Node){
    return new Edge(tuple2(label,node));
  }
  @:from static public function fromNode(n:Node):Edge<Noise>{
    return new Edge(tuple2(Noise,n));
  }
  public function new(self){
    this = self;
  }
  public var key(get,never):Node;

  private function get_key():Node{
    return this.snd();
  }

  public var val(get,never):T;

  private function get_val():T{
    return this.fst();
  }
}
