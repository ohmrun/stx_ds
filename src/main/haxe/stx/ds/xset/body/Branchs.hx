package stx.ds.xset.body;

class Branchs{
  static public function map<S,T,U>(self:Branch<S,T>,fn:T->U):Branch<S,U>{
    return self.map(fn);
  }
  static public function union<S,T>(lhs:Branch<S,T>,rhs:Branch<S,T>):Branch<S,T>{
    return null;
  } 
}