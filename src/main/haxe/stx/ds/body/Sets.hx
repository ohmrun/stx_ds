package stx.ds.body;

import stx.ds.head.data.RBTree;
import stx.ds.head.data.*;
import stx.ds.pack.Set;

class Sets{
  public static function balance<V>(set:Set<V>):Set<V>{
    return { data : RBTrees.balance(set.data), with : set.with};
  }
  public static function put<V>(set: Set<V>, val: V): Set<V> {
    function ins(tree: RBTree<V>, comparator: Assertion<V>): RBTree<V> {
      return switch (tree) {
        case Leaf: 
          Node(Red, Leaf, val, Leaf);
        case Node(color, left, v, right):
            if (comparator(val, v))
                RBTrees.balance(Node(color, ins(left, comparator), v, right))
            else if (comparator(v, val))
                RBTrees.balance(Node(color, left, v, ins(right, comparator)))
            else
                Node(color,left, val, right);//HMMM
      }
    };
    return switch (ins(set.data, set.with.lt)) {
      case Leaf:
          throw "Never reach here";
      case Node(_, left, label, right):
          { data: Node(Black, left, label, right), with: set.with };
    }
  }
  static public function toString<V>(set:Set<V>):String{
    return RBTrees.toString(set.data);
  }
  static public function rem<V>(set:Set<V>, value:V): Set<V>{
    var balance = RBTrees.balance;
    var eq      = set.with.eq;
    var lt      = set.with.lt;

    function cons(data):RBTree<V>{
      return data;
    }
    function s(v:RBTree<V>){
      return RBTrees.toString(v);
    }
    function merge(l:RBTree<V>,r:RBTree<V>){
      //trace('${s(l)}\n${s(r)}');
      return switch([l,r]){
        case [Leaf,v] : v;
        case [v,Leaf] : v;
        case [Node(c0,l0,v0,r0),Node(c1,l1,v1,r1)] if (lt(v0,v1).ok()):
          balance(Node(c1,merge(l,l1),v1,r1));
        case [Node(c0,l0,v0,r0),Node(c1,l1,v1,r1)] if (lt(v1,v0).ok()):
          balance(Node(c0,merge(l0,r),v0,r0));
        default : Leaf;
      }
    }
    function rec(data:RBTree<V>):RBTree<V>{
      return switch (data) {
        case Leaf                 : cons(Leaf);
        case Node(c,l,v,r):
        if(eq(value,v)){
          switch([l,r]){
            case [Leaf,v] : 
              cons(v);
            case [v,Leaf] : 
              cons(v);
            case [Node(c0,l0,v0,r0),Node(c1,l1,v1,r1)] :
              var out = merge(l,r);
              //trace(RBTrees.toString(r));
              out;
          }
        }else if(lt(value,v).ok()){
          cons(Node(c,rec(l),v,r));
        }else if(lt(v,value).ok()){
          cons(Node(c,l,v,rec(r)));
        }else{
          data;
        }
        default : data;            
      }
    }
    return Set.make(set.with,rec(set.data));
  }
  static public function has<V>(set:Set<V>,val):Bool{
    function hs(tree: RBTree<V>, with: Comparable<V>): Bool {
      return switch (tree) {
        case Leaf: 
          false;
        case Node(color, left, v, right):
          if(with.eq(val,v)){
            true;
          }else if(with.lt(val, v).ok()){
            hs(left, with);
          }else if (with.lt(v, val).ok()){
            hs(right,with);
          }else{
            false;
          }
      }
    };
    return hs(set.data,set.with);
  }
}