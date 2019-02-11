package stx.ds.pack;

import stx.ds.body.RBTrees;
import stx.ds.body.Maps;
import stx.ds.head.data.Map in MapT;

@:forward abstract Map<K,V>(MapT<K,V>) from MapT<K,V>{
  private function new(self) this = self;
  static public function make<K,V>(with:Comparable<K>,?data:RBTree<KV<K,V>>):Map<K,V>{
    return Maps.make(with,data);
  }
  public function set(k:K,v:V):Map<K,V>{
    return Maps.set(this,k,v);
  }
  public function put(kv:KV<K,V>):Map<K,V>{
    return set(kv.key,kv.val);
  }
  public function get(k:K):Option<V>{
    return __.core().option(Maps.get(this,k));
  }
  public function rem(k:K):Map<K,V>{
    return Maps.rem(this,k);
  }
  public function iterator():Iterator<KV<K,V>>{
    return RBTrees.iterator(this.data);
  }
  public function union(that:Map<K,V>):Map<K,V>{
    var self = new Map(this);
    for(item in that){
      self = Maps.set(self,item.key,item.val);
    }
    return self;
  }
}