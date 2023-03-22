package stx.ds.test;

class RedBlackSetTest extends TestCase{
  public function _test(){
    var set = RedBlackSet.make(Comparable.Int());
        set = set.concat([1,2,3,4,6,10,55,90,10000,5,458,29]);
    //trace(set);
    var v   = set.split(6);
    trace(v.fst());
    trace(v.snd());
  }
  public function test1(){

  } 
}