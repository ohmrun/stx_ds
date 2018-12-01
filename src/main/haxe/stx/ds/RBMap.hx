package stx.ds;

import stx.types.Eq;

abstract RBMap<K,V>(MapT<K,V>) from MapT<K,V>{
  static public function create<T>(?eq:Eq<T>){
    return new RBMap(eq == null ? function(x,y) return x == y : eq );
  }
  public function new(comparator:Eq<K>){
    return { tree: Leaf, comparator: comparator };
  }
  public function set(k:K,v:V):RBMap<K,V>{
    return RBMaps.set(this,k,v);
  }
  public function get(k:K):Null<V>{
    return RBMaps.get(this,k);
  }
} 