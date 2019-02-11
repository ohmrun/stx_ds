package stx.ds.body;

import haxe.ds.Option;
import stx.core.pack.Option;
import stx.ds.head.data.RBTree;
import stx.ds.head.data.RBColour;

class RBTrees{
  public static function balance<T>(tree: RBTree<T>): RBTree<T> {
    return switch (tree) {
      case  Node(Black, Node(Red, Node(Red, a, x, b), y, c), z, d)
          | Node(Black, Node(Red, a, x, Node(Red, b, y, c)), z, d)
          | Node(Black, a, x, Node(Red, Node(Red, b, y, c), z, d))
          | Node(Black, a, x, Node(Red, b, y, Node(Red, c, z, d))):
          Node(Red, Node(Black, a, x, b), y, Node(Black, c, z, d));
      case _:
          tree;
    }
  }
  static public function toString<V>(tree:RBTree<V>):String{
    function rec(tree:RBTree<V>,?ins="  "){
      var nins = '$ins  ';
      return switch (tree) {
        case Leaf: "";
        case Node(colour, left, label, right):
          var c = colour == Red ? "r" : "b";
          var l = rec(left,nins);
          var r = rec(right,nins);
          '(${c}:$label)\n${ins}<-:$l\n${ins}->:$r';
      }
    }
    return '\n'+rec(tree);
  }
  static public function iterator<V>(tree:RBTree<V>):Iterator<V>{
    function recurse(head:RBTree<V>,stack:Array<RBTree<V>>):Tuple2<Option<V>,LStream<V>>{
        //trace(head);
        return switch([head,stack]){
          case [Leaf,[]]            :
            tuple2(None,recurse.bind(Leaf,[]));
          case [Leaf,arr]           : 
            recurse(
              arr.head().prj(()->Leaf),
              arr.tail()
            );
          case [Node(_,l,v,r),arr]  :
            tuple2(Some(v),recurse.bind(l,arr.cons(r))); 

        }
    }
    var val = recurse(tree,[]);

    return {
      next : function(){
        var v : V = val.fst().prj(()->null);
        val = val.snd()();
        return v;
      },
      hasNext : function(){
        return val.fst().map((_)->true).prj(()->false);
      }
    }
  }
}