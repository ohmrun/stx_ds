package stx.assert.ds.eq;

import stx.ds.RedBlackMap in TRedBlackMap;

class RedBlackMap<K,V> extends EqCls<TRedBlackMap<K,V>>{
  final K : Eq<K>;
  final V : Eq<V>;

  public function new(K,V){
    this.K = K;
    this.V = V;
  }
  public function comply(lhs:TRedBlackMap<K,V>,rhs:TRedBlackMap<K,V>){
    var eq      = AreEqual;
    var liter   = lhs.keyValueIterator();
    var riter   = rhs.keyValueIterator();
    final keys  = RedBlackSet.make(lhs.with);
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
      eq = NotEqual;
    }
    if(eq.is_equal()){
      for (key in keys){
        final l = lhs.get(key);
        final r = rhs.get(key);
        switch([l,r]){
          case [Some(a),Some(b)] : 
            eq = V.comply(a,b);
          default : 
            eq = NotEqual;
        }
        if(eq.is_not_equal()){
          break;
        }
      }
    }
    return eq;
  } 
}