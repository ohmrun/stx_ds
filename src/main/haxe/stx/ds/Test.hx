package stx.ds;

using stx.Test;

import stx.ds.test.*;

class Test{
  static public function main(){
    __.test().run([
      new RedBlackMapTest(),
    ],[]);
  }
}
class RedBlackMapTest extends TestCase{
  public function test(){
    var map = stx.ds.RedBlackMap.make(Comparable.String());
        map = map.set("a",1).set("a",2).set("b",1000);
    trace(map.get("b"));
  }
}