package hx.ds;

import haxe.ds.Option;
import ah.Sort;

using stx.Tuple;
import stx.Options.option;
import stx.Compare.*;

import stx.types.*;
import stx.Order;
import stx.Show;
import stx.Hasher;

using stx.Iterables;
using stx.Iterators;
using stx.Order;
using stx.Options;
using stx.Pointwise;

import stx.Hasher;

class OrderedMap<K,V>{
  private var __key_sort__  : Ord<K>;
  private var __val_sort__  : Ord<V>;
  private var __val_equal__ : Eq<V>;

  private var __key_hash__  : K->Int;

  private var impl          : OrderedHashMap<Tuple2<K,V>>;

  public function new(){
    impl = new OrderedHashMap();
  }
  public function set(key:K,val:V){
    var v : Tuple2<K,V> = tuple2(key,val);
    impl.set(encode(key),v);
  }
  public function has(key:K){
    return impl.has(encode(key));
  }
  public function at(i:Int):V{
    return option(impl.at(i)).map(Tuples2.snd).valOrC(null);
  }
  public function get(key:K):V{
    return option(impl.get(encode(key))).map(Tuples2.snd).valOrC(null);
  }
  public function del(key:K){
    return impl.del(encode(key));
  }
  public function rem(val:V){
    var found = false;
  }
  public function sort(){
    impl.impl = ArrayOrder.sort(impl.impl);
  }
  public function sortWith(fn:Ord<Tuple2<K,V>>){
    impl.sortWith(Sort.vals(fn));
  }
  public function iterator():Iterator<Tuple2<K,V>>{
    return impl.map(Tuples2.snd).iterator();
  }
  public function lookup(key:K):Option<Tuple2<K,V>>{
    return untyped impl.lookup(encode(key));
  }
  private function encode(key:K):Int{
    if(__key_hash__ == null){
      this.__key_hash__ = Hasher.getHashFor(key);
    }
    return __key_hash__(key);
  }
  public function size(){
    throw "Unimplemented method 'size'";
  }
  public function toString():String{
    return impl.toString();
  }
}
