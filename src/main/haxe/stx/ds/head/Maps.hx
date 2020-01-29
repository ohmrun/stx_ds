package stx.ds.head;

class Maps{
  static public var _(default,null) = new stx.ds.body.Maps();

  static public function string<V>():Map<String,V>{
    return make(
      Comparables.term.string()
    );
  }
  static public function make<K,V>(with:Comparable<K>,?data:RBTree<KV<K,V>>):Map<K,V>{
    return {
      with : with,
      data : data == null ? Leaf : data
    };
  }
  public static function create<K, V>(ord: Ord<K>,eq:Eq<K>): Map<K, V> {
    return { data: Leaf, with: new stx.assert.body.comparable.term.BaseComparable(eq,ord) };
  }
}