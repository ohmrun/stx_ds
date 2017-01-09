package ah;

import stx.Order;


using stx.Tuple;
import stx.types.Ord;

class Sort{
  @:noUsing static public inline function keys<K,V>(fn:Ord<K>):Ord<Tuple2<K,V>>{
    return function(l:Tuple2<K,V>,r:Tuple2<K,V>){
      return fn(l.fst(),r.fst());
    }
  }
  @:noUsing static public inline function vals<K,V>(fn:Ord<V>):Ord<Tuple2<K,V>>{
    return function(l:Tuple2<K,V>,r:Tuple2<K,V>){
      return fn(l.snd(),r.snd());
    }
  }
  @:noUsing static public inline function start<T>(getter:Void->Ord<T>, setter:Ord<T>->Void){
    return function(x,y) {
      var sorter = getter();
      if(sorter == null){
        sorter = Order.getOrderFor(x);
        setter(sorter);
      }
      return sorter(x,y);
    }
  }
}
