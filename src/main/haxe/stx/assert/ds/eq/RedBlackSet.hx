package stx.assert.ds.eq;

import stx.ds.RedBlackSet in TRedBlackSet;

class RedBlackSet<T> extends EqCls<TRedBlackSet<T>>{
  final T : Eq<T>;

  public function new(T){
    this.T = T;
  }
  public function comply(lhs:TRedBlackSet<T>,rhs:TRedBlackSet<T>):Equaled{
    return lhs.copy(lhs.with.copy(this.T)).equals(rhs.copy(rhs.with.copy(this.T)));
  }
}