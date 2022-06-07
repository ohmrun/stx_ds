package stx.assert.ds.ord;

import stx.ds.RedBlackSet in TRedBlackSet;

class RedBlackSet<T> extends OrdCls<TRedBlackSet<T>>{
  final T : Ord<T>;

  public function new(T){
    this.T = T;
  }
  public function comply(lhs:TRedBlackSet<T>,rhs:TRedBlackSet<T>):Ordered{
    return lhs.copy(lhs.with.copy(this.T)).less_than(rhs.copy(rhs.with.copy(this.T)));
  }
}