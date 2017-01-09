package stx.ds;

import stx.types.Eq;

private enum Color { Red; Black; }

private enum TreeT<T> {
  Leaf;
  Node(color: Color, left: TreeT<T>, label: T, right: TreeT<T>);
}

typedef MapT<K, V> = { tree: TreeT<{ key: K, value: V }>, comparator: Eq<K> };

abstract RBMap<K,V>(MapT<K,V>) from MapT<K,V>{
  static public function create<T>(?eq:Eq<T>){
    return new RBMap(eq == null ? function(x,y) return x == y : eq );
  }
  public function new(comparator:Eq<K>){
    return { tree: Leaf, comparator: comparator };
  }
  public function set(k:K,v:V):RBMap<K,V>{
    return RBMaps.set(this,k,v);
  }
  public function get(k:K):Null<V>{
    return RBMaps.get(this,k);
  }
} 
class RBMaps{
    private static function balance<T>(tree: TreeT<T>): TreeT<T> {
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
    public static function set<K, V>(map: MapT<K, V>, key: K, value: V): MapT<K, V> {
      function ins(tree: TreeT<{ key: K, value: V}>, comparator: K -> K -> Bool): TreeT<{ key: K, value: V}> {
        return switch (tree) {
          case Leaf: Node(Red, Leaf, { key: key, value: value }, Leaf);
          case Node(color, left, label, right):
              if (comparator(key, label.key))
                  balance(Node(color, ins(left, comparator), label, right))
              else if (comparator(label.key, key))
                  balance(Node(color, left, label, ins(right, comparator)))
              else
                  tree;
        }
      };

      return switch (ins(map.tree, map.comparator)) {
        case Leaf:
            throw "Never reach here";
        case Node(_, left, label, right):
            { tree: Node(Black, left, label, right), comparator: map.comparator };
      }
    }
    public static function create<K, V>(comparator: K -> K -> Bool): MapT<K, V> {
      return { tree: Leaf, comparator: comparator };
    }
    public static function get<K, V>(map: MapT<K, V>, key: K): Null<V> {
      function mem(tree: TreeT<{ key: K, value: V}>): Null<V> {
        return switch (tree) {
          case Leaf: null;
          case Node(_, left, label, right):
              if (map.comparator(key, label.key))
                  mem(left);
              else if (map.comparator(label.key, key))
                  mem(right);
              else
                  label.value;
        }
      }
      return mem(map.tree);
    }
    public static function del<K,V>(map:MapT<K,V>,key:String):MapT<K,V>{
      function mem(tree0:TreeT<{ key: K, value: V },tree1:TreeT<{key: K, value: V}){
        switch (tree0){
          Leaf                               : tree1;
          Node(_, left, label, right)        : tree1.set(label.key,label.value)
        }
      }
    }
    public static function append<K,V>(map0:MapT<K,V>,map1:MapT<K,V>){

    }
}