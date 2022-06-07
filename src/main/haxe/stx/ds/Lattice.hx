package stx.ds;

class LatticeSetLift{
  
}
typedef LatticeElem = {
  final id : Int;
}
typedef BlockHeader = {
  final id : Int;
}
enum LatticeItem<T>{
  TOP;
  NODE(v:T);
  BOTTOM;
}
