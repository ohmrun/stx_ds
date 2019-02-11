package stx.ds.xset.body;

class Nodes{
  static public function map<S,T,U>(self:Node<S,T>,fn:T->U):Node<S,U>{
    return switch(self){
      case Value(value)  : Value(fn(value));
      case Scope(scope)  : Scope(scope.map(fn));
    }
  }
  static public function eq<S,T>(with:With<S,T>,self:Node<S,T>,that:Node<S,T>):Equaled{
    return switch([self,that]){
      case [Value(l),Value(r)]  : with.T.eq(l,r);
      case [Scope(l),Scope(r)]  : l.eq(r,with);
      default                   : false;
    }
  }
}