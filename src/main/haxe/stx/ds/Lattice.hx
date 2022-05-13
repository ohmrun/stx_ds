package stx.ds;

class LatticeSetLift{
  static public function downset<T>(set:RedBlackSet<T>,t:T):RedBlackSet<T>{
    final next = set.unit();
    //TODO, prove I can break after `==`
    for(i in set){
      if(set.with.lt().comply(i,t).is_ok() || set.with.eq().comply(i,t).is_ok()){
        next.put(i);
      }
    }
    return next;
  }
  static public function upset<T>(set:RedBlackSet<T>,t:T):RedBlackSet<T>{
    final next = set.unit();
    for(i in set){
      if(!set.with.lt().comply(i,t).is_ok() && !set.with.eq().comply(i,t).is_ok()){
        next.put(i);
      }
    }
    return next;
  }
}
typedef LatticeElem = {
  final id : Int;
}
typedef BlockHeader = {
  final id : Int;
} 