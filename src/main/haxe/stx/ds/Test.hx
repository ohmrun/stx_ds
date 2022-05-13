package stx.ds;

using stx.Test;

import stx.ds.test.*;

class Test{
  static public function main(){
    __.test([
      new RedBlackSetTest(),
    ],[]);
  }
}
class RedBlackSetTest extends TestCase{
  public function test(){
    var set = RedBlackSet.make(Comparable.Int());
        set = set.concat([1,2,3,4,6,10,55,90,10000,5,458,29]);
    //trace(set);
    var v   = set.split(6);
    trace(v.fst());
    trace(v.snd());
  }
}