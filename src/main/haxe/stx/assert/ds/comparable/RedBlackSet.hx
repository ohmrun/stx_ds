package stx.assert.ds.comparable;

import stx.ds.RedBlackSet as TRedBlackSet;

class RedBlackSet<T> extends ComparableCls<TRedBlackSet<T>>{
  final T : Comparable<T>;
  
  public function new(T:Comparable<T>){
    this.T = T;
  }
  public function eq(){
    return new stx.assert.ds.eq.RedBlackSet(T.eq());
  }
  public function lt(){
    return new stx.assert.ds.ord.RedBlackSet(T.lt());
  }
}