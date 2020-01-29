package stx.ds.test;

using Lambda;
import stx.ds.pack.Set;

class SetTest extends utest.Test{
  static public var orig : Float = haxe.Timer.stamp();
  public function testSet(){
    function ts(){
      return haxe.Timer.stamp();
    }
    //var orig = ts();
    function next(){
      return ts() - orig;
    }
    //trace(next());
    var set:Set<Int> = Set.create(
      Ords.term.int(),
      Eqs.term.int()
    );
    var ipt = [1,9,20,3,12,66,100,900,4,2,5,8,6]; 
    set = ipt.fold(
      (n,m:Set<Int>) -> m.put(n),
      set
    );
    //trace(set.toArray());
    //trace(set.toArray().length);
    //trace(next());
    set = set.rem(5).rem(100).rem(8);
    trace(next());
    //trace(set);

    var all = [];
    for(v in set){
      all.push(v);
    }
    (ipt.length-3).equals(
      all.length
    );
    
    set = set.put(1);
    (ipt.length-3).equals(
      all.length
    );
    set = set.rem(100);
    (ipt.length-3).equals(
      all.length
    );
  }
}