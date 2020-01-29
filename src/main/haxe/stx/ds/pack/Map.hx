package stx.ds.pack;

import stx.ds.body.RBTrees;
import stx.ds.head.Maps;
import stx.ds.head.data.Map in MapT;

@:forward abstract Map<K,V>(MapT<K,V>) from MapT<K,V>{
  private function new(self) this = self;
  
  public function set(k:K,v:V):Map<K,V>             return Maps._.set(k,v,this);
  public function put(kv:KV<K,V>):Map<K,V>          return set(kv.key,kv.val);
  public function get(k:K):Option<V>                return __.option(Maps._.get(k,this));
  public function has(k:K):Bool                     return __.option(Maps._.get(k,this)).is_defined();
  public function rem(k:K):Map<K,V>                 return Maps._.rem(k,this);
  public function iterator():Iterator<KV<K,V>>      return RBTrees.iterator(this.data);
  public function keyValIterator()                  return RBTrees.iterator(this.data);
  public function union(that:Map<K,V>):Map<K,V>     return Maps._.union(that,this);

  @:to public function toIter():Iter<KV<K,V>>            return new Iter({ iterator : iterator });
}