package stx.ds.body;

import stx.ds.head.data.RBTree;
import stx.ds.head.data.RBColour;
import stx.ds.head.data.Map;
import stx.ds.pack.Map;
import stx.ds.pack.RBTree;

class Maps{
    static public function make<K,V>(with:Comparable<K>,?data:RBTree<KV<K,V>>){
      return {
        with : with,
        data : data == null ? Leaf : data
      };
    }
    public static function set<K, V>(map: Map<K, V>, key: K, val: V): Map<K, V> {
      function ins(tree: RBTree<KV<K,V>>, comparator: Assertion<K>): RBTree<KV<K,V>> {
        return switch (tree) {
          case Leaf: Node(Red, Leaf, { key: key, val: val }, Leaf);
          case Node(color, left, label, right):
              if (comparator(key, label.key))
                  RBTrees.balance(Node(color, ins(left, comparator), label, right))
              else if (comparator(label.key, key))
                  RBTrees.balance(Node(color, left, label, ins(right, comparator)))
              else
                  tree;
        }
      };

      return switch (ins(map.data, map.with.lt)) {
        case Leaf:
            throw "Never reach here";
        case Node(_, left, label, right):
            { data: Node(Black, left, label, right), with: map.with };
      }
    }
    public static function create<K, V>(ord: Ord<K>,eq:Eq<K>): Map<K, V> {
      return { data: Leaf, with: { lt : ord, eq : eq } };
    }
    public static function get<K, V>(map: Map<K, V>, key: K): Null<V> {
      function mem(tree: RBTree<KV<K,V>>): Null<V> {
        return switch (tree) {
          case Leaf: null;
          case Node(_, left, label, right):
              if (map.with.lt(key, label.key).ok())
                  mem(left);
              else if (map.with.lt(label.key, key).ok())
                  mem(right);
              else
                  label.val;
        }
      }
      return mem(map.data);
    }
  static public function rem<K,V>(map:Map<K,V>, value:K): Map<K,V>{
    var balance = RBTrees.balance;
    var eq      = map.with.eq;
    var lt      = map.with.lt;

    function cons(data):RBTree<KV<K,V>>{
      return data;
    }
    function s(v:RBTree<KV<K,V>>){
      return RBTrees.toString(v);
    }
    function merge(l:RBTree<KV<K,V>>,r:RBTree<KV<K,V>>){
      //trace('${s(l)}\n${s(r)}');
      return switch([l,r]){
        case [Leaf,v] : v;
        case [v,Leaf] : v;
        case [Node(c0,l0,v0,r0),Node(c1,l1,v1,r1)] if (lt(v0.key,v1.key).ok()):
          balance(Node(c1,merge(l,l1),v1,r1));
        case [Node(c0,l0,v0,r0),Node(c1,l1,v1,r1)] if (lt(v1.key,v0.key).ok()):
          balance(Node(c0,merge(l0,r),v0,r0));
        default : Leaf;
      }
    }
    function rec(data:RBTree<KV<K,V>>):RBTree<KV<K,V>>{
      return switch (data) {
        case Leaf                 : cons(Leaf);
        case Node(c,l,v,r):
        if(eq(value,v.key)){
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
        }else if(lt(value,v.key).ok()){
          cons(Node(c,rec(l),v,r));
        }else if(lt(v.key,value).ok()){
          cons(Node(c,l,v,rec(r)));
        }else{
          data;
        }
        default : data;            
      }
    }
    return Map.make(map.with,rec(map.data));
  }
}