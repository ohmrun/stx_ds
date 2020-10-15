package stx.ds;

enum RedBlackTreeSum<T> {
  Leaf;
  Node(color: RedBlackSum, left: RedBlackTreeSum<T>, label: T, right: RedBlackTreeSum<T>);
}

@:forward abstract RedBlackTree<T>(RedBlackTreeSum<T>) from RedBlackTreeSum<T> to RedBlackTreeSum<T>{
  static public var _(default,never) = RedBlackTreeLift;

  public function new(self){
    this = self;
  }
}
class RedBlackTreeLift{
  public static function balance<T>(tree: RedBlackTree<T>): RedBlackTree<T> {
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
  static public function toString<V>(tree:RedBlackTree<V>):String{
    function rec(tree:RedBlackTree<V>,?ins="  "){
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
  static public function iterator<V>(tree:RedBlackTree<V>):Iterator<V>{
    function recurse(head:RedBlackTree<V>,stack:Array<RedBlackTree<V>>):LazyStream<V>{
        //trace(head);
        return switch([head,stack]){
          case [Leaf,[]]            :
            LazyStream.make(recurse.bind(Leaf,[]),None);
          case [Leaf,arr]           : 
            recurse(
              arr.head().def(()->Leaf),
              arr.tail()
            );
          case [Node(_,l,v,r),arr]  :
            LazyStream.make(recurse.bind(l,arr.cons(r)),Some(v)); 

        }
    }
    var val = recurse(tree,[]);

    return {
      next : function(){
        var res = val.reply();
        var v : V = res.fst().def(()->null);
        val = res.snd().next();
        return v;
      },
      hasNext : function(){
        var res = val.reply();
        return res.fst().map((_)->true).def(()->false);
      }
    }
  }
}