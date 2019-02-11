package stx.ds.pack;

import stx.ds.head.data.Nel in NelT;

abstract Nel<T>(NelT<T>) from NelT<T>{
  public function new(self) this = self;

  public function cons(v:T){
    return switch(this){
      case InitNel(x)         : ConsNel(v,this);
      case ConsNel(x, xs)     : ConsNel(v,this);
    }
  }
}