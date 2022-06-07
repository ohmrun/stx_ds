package stx.assert.ds.comparable;

import stx.ds.RedBlackMap as TRedBlackMap;

class RedBlackMap<K,V> extends ComparableCls<TRedBlackMap<K,V>>{
  final K : Comparable<K>;
  final V : Comparable<V>;
  public function new(K,V){
    this.K = K;
    this.V = V;
  }
  public function eq(){
    return new stx.assert.ds.eq.RedBlackMap(K.eq(),V.eq());
  }
  public function lt(){
    return new stx.assert.ds.ord.RedBlackMap(K.lt(),V.lt());
  }
}