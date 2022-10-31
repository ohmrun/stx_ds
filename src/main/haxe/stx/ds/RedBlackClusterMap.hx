package stx.ds;

typedef RedBlackClusterMapDef<K,V> = RedBlackMapDef<K,Cluster<V>>;

@:using(stx.ds.RedBlackClusterMap.RedBlackClusterMapLift)
@:using(stx.ds.RedBlackMap.RedBlackMapLift)
@:forward abstract RedBlackClusterMap<K,V>(RedBlackClusterMapDef<K,V>) from RedBlackClusterMapDef<K,V> to RedBlackClusterMapDef<K,V>{
  static public var _(default,never) = RedBlackClusterMapLift;
  public inline function new(self:RedBlackClusterMapDef<K,V>) this = self;
  @:noUsing static public function make<K,V>(with:Comparable<K>,?data:RedBlackTree<KV<K,Cluster<V>>>):RedBlackClusterMap<K,V>{
    return new RedBlackClusterMap({
      with : with,
      data : data == null ? Leaf : data
    });
  }
  @:noUsing static inline public function lift<K,V>(self:RedBlackClusterMapDef<K,V>):RedBlackClusterMap<K,V> return new RedBlackClusterMap(self);

  public function prj():RedBlackClusterMapDef<K,V> return this;
  private var self(get,never):RedBlackClusterMap<K,V>;
  private function get_self():RedBlackClusterMap<K,V> return lift(this);

  public function keyValueIterator() : KeyValueIterator<K,Cluster<V>> { return RedBlackMap.lift(this).keyValueIterator(); }

  @:to public function toRedBlackMapDef():RedBlackMapDef<K,Cluster<V>>{
    return this;
  }
}
class RedBlackClusterMapLift{
  static public inline function lift<K,V>(self:RedBlackClusterMapDef<K,V>):RedBlackClusterMap<K,V>{
    return RedBlackClusterMap.lift(self);
  }
  static public function mod<K,V>(self:RedBlackClusterMapDef<K,V>,key:K,fn:Cluster<V>->Cluster<V>):RedBlackClusterMap<K,V>{
    final val = RedBlackMap._.get(self,key).map(fn).defv(fn([].imm()));
    trace(val);
    return lift(RedBlackMap._.set(self,key,val));
  }
}