package stx.ds.pack;

import stx.ds.head.data.List in ListT;

abstract List<T>(ListT<T>) from ListT<T> to ListT<T>{
  static public function unit<T>():List<T>{
    return Nil;
  }
  static public function pure<T>(v:T):List<T>{
    return Cons(v,Nil);
  }
  public function new(self){
    this = self;
  }
  public function tail():List<T>{
    return switch(this){
      case Nil : Nil;
      case Cons(_,next): next;
    }
  }
  public function cons(v):List<T>{
    return Cons(v,this);
  }
  public function last(){
    var crs = this;
    var val = null;
    while(true){
      switch crs {
        case Cons(x,xs):
          val = x;
          crs = xs;
        default: break;
      }
    }
    return val;
  }
  public function concat(that : List<T>) : List<T>{
    return switch [this, that] {
      case [Nil, Nil]: Nil;
      case [Nil, l]
         | [l, Nil]: l;
      case [Cons(x, Nil), _]:
        Cons(x, that);
      case [Cons(x, xs), _]:
        Cons(x, xs.concat(that));
    };
  }
  public function fold<B>(f : T -> B -> B, b : B) : B{
    return switch this {
      case Nil: b;
      case Cons(x, xs): xs.fold(f,f(x, b));
    }
  }
  public function head():Null<T>{
    return switch(this){
      case Cons(x,xs) : x;
      default         : null;
    }
  }
  public function iterator():Iterator<T>{
    var cursor : Null<List<T>> = this;
    return {
      next : function(){
        var value = null;
        switch(cursor){
          case Cons(x,xs) :
            value  = x;
            cursor = xs;
          default : cursor = Nil;
        }
        return value;
      },
      hasNext : function(){
        return switch cursor {
          case Nil : false;
          default : true;
        }
      }
    }
  }
  public function map<B>(f : T -> B) : List<B>{
    return switch this {
      case Nil: Nil;
      case Cons(x, xs): Cons(f(x), xs.map(f));
    };
  }
}