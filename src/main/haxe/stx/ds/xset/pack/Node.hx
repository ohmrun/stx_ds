package stx.ds.xset.pack;

import stx.ds.xset.body.Nodes;
import stx.ds.xset.head.data.Node in NodeT;

abstract Node<S,T>(NodeT<S,T>) from NodeT<S,T>{
  public function new(self){
    this = self;
  }
  static public function pure<S,T>(v:T):Node<S,T>{
    return Value(v);
  }
  public function keys():Array<S>{
    return switch(this){
      case Value(_)   : [];
      case Scope(xs)  : [xs.scope];    
    }
  }
  public function map<U>(fn:T->U):Node<S,U>{
    return Nodes.map(this,fn);
  }
  public function of(with:S->Bool):Root<S,T>{
    return switch(this){
      case Scope(xs)  : xs.of(with);
      default         : [];
    }
  }
  public function eq(that:Node<S,T>,with:With<S,T>):Equaled{
    return Nodes.eq(with,this,that);
  }
  public function toRoot():Root<S,T>{
    return [this];
  }
}