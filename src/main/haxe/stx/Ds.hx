package stx;

using stx.Pico;
using stx.Nano;
using stx.Assert;

import haxe.ds.Map in StdMap;

enum RedBlackSum { Red; Black; }

typedef RedBlackMapDef<K, V>          = stx.ds.RedBlackMap.RedBlackMapDef<K, V>;
typedef RedBlackMap<K,V>              = stx.ds.RedBlackMap<K,V>;

typedef RedBlackClusterMapDef<K, V>   = stx.ds.RedBlackClusterMap.RedBlackClusterMapDef<K, V>;
typedef RedBlackClusterMap<K,V>       = stx.ds.RedBlackClusterMap<K,V>;

typedef RedBlackSetDef<T>             = stx.ds.RedBlackSet.RedBlackSetDef<T>;
typedef RedBlackSet<T>                = stx.ds.RedBlackSet<T>;

typedef RedBlackTreeSum<T>            = stx.ds.RedBlackTree.RedBlackTreeSum<T>;
typedef RedBlackTree<T>               = stx.ds.RedBlackTree<T>;

typedef LinkedListSum<T>              = stx.ds.LinkedList.LinkedListSum<T>;
typedef LinkedList<T>                 = stx.ds.LinkedList<T>;

typedef BinaryTreeSum<T>              = stx.ds.BinaryTree.BinaryTreeSum<T>;
typedef BinaryTree<T>                 = stx.ds.BinaryTree<T>;

typedef LazyBinaryTreeSum<T>  = stx.ds.LazyBinaryTree.LazyBinaryTreeSum<T>;
typedef LazyBinaryTree<T>     = stx.ds.LazyBinaryTree<T>;

typedef NelSum<T>             = stx.ds.Nel.NelSum<T>;
typedef Nel<T>                = stx.ds.Nel<T>;

typedef KaryTreeSum<T>        = stx.ds.KaryTree.KaryTreeSum<T>;  
typedef KaryTree<T>           = stx.ds.KaryTree<T>; 
typedef KaryTreeZipper<T>     = stx.ds.kary_tree.KaryTreeZip<T>;  

class LiftLinkedList{
  static public function ds<T>(ls:LinkedListSum<T>):LinkedList<T>{
    return ls;
  }
}
class LiftArrayToLinkedList{
  static public function toLinkedList<T>(array:Array<T>):LinkedList<T>{
    return array.rfold(
      (next,memo:LinkedList<T>) -> memo.cons(next),
      LinkedList.unit()
    );
  }
}
class LiftClusterToLinkedList{
  static public function toLinkedList<T>(array:Cluster<T>):LinkedList<T>{
    return array.rfold(
      (next,memo:LinkedList<T>) -> memo.cons(next),
      LinkedList.unit()
    );
  }
}
class LiftStringMap{
  static public function ds<T>(m:StdMap<String,T>):RedBlackMap<String,T>{
    var nm = RedBlackMap.make(
      Comparable.String()
    );
    for( key => val in m){
      nm = nm.set(key,val);
    }
    return nm;
  }
}