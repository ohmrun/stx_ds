package stx.assert.ds.ord;

import stx.ds.RedBlackMap in TRedBlackMap;

class RedBlackMap<K,V> extends OrdCls<TRedBlackMap<K,V>>{
  final K : Ord<K>;
  final V : Ord<V>;
  public function new(K,V){
    this.K = K;
    this.V = V;
  }
  public function comply(lhs:TRedBlackMap<K,V>,rhs:TRedBlackMap<K,V>){
    var ord     = NotLessThan;
    var liter   = lhs.keyValueIterator();
    var riter   = rhs.keyValueIterator();
    final keys  = stx.ds.RedBlackSet.make(lhs.with);
    var lsize   = 0;
    var rsize   = 0;

    var ldone   = false;
    var rdone   = false;

    while(true){
      if(liter.hasNext()){
        lsize = lsize + 1;
        keys.put(liter.next().key);
      }else{
        ldone = true;
      }
      if(riter.hasNext()){
        rsize = rsize + 1;
        keys.put(riter.next().key);
      }else{
        rdone = true;
      } 
      if(ldone && rdone){
        break;
      }
    }
    if(lsize<rsize){
      ord = LessThan;
    }
    if(ord.is_not_less_than()){
      for (key in keys){
        final l = lhs.get(key);
        final r = rhs.get(key);
        switch([l,r]){
          case [None,Some(_)] : 
            ord = LessThan;
          case [Some(a),Some(b)] : 
            ord = V.comply(a,b);
          default : 
        }
        if(ord.is_less_than()){
          break;
        }
      }
    }
    return ord;
  } 
}