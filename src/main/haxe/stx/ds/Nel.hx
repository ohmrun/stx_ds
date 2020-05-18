package stx.ds;

enum NelSum<A>{
  InitNel(x: A);
  ConsNel(x: A, xs: Nel<A>);
}

abstract Nel<T>(NelSum<T>) from NelSum<T>{
  public function new(self) this = self;

  public function cons(v:T){
    return switch(this){
      case InitNel(x)         : ConsNel(v,this);
      case ConsNel(x, xs)     : ConsNel(v,this);
    }
  }
}