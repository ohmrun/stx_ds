package stx.ds;


import stx.ds.head.data.Map in MapT;
import stx.ds.body.Maps;

abstract Map<K,V>(MapT<K,V>) from MapT<K,V>{
  static public function create<T>(ord:Orderable<T>){
    return new Map(ord);
  }
  public function new(comparator:Orderable<K>){
    return { data: Leaf, with: comparator};
  }
  public function set(k:K,v:V):Map<K,V>{
    return Maps.set(this,k,v);
  }
  public function get(k:K):Null<V>{
    return Maps.get(this,k);
  }
} 