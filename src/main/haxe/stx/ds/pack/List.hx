package stx.ds.pack;

import stx.ds.head.data.List in ListT;

abstract List<T>(ListT<T>) from ListT<T> to ListT<T>{
  @:from static public function fromArray<T>(arr:StdArray<T>):List<T>{
    var self = unit();
    var i   = arr.length - 1; 
    while(i >= 0){
      self = self.cons(arr[--i]);
    }
    return self;
  }
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
  public function find(fn:T->Bool){
    return fold(
      (next,memo:Option<T>) -> memo.or(
        () -> fn(next) ? Some(next) : None
      )
    ,None);
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
  public function mapFilter<B>(f : T -> Option<B>) : List<B>{
    return switch this{
      case Nil          : Nil;
      case Cons(x, xs)  :
        var nxt = f(x);
        switch(nxt){
          case Some(v) : Cons(v,xs.mapFilter(f));
          default      : xs.mapFilter(f);
        }
    };
  }
  static public function monoid<T>():Monoid<List<T>>{
    return {
      batch : (l:List<T>,r:List<T>) -> l.concat(r),
      prior : () -> List.unit()
    }
  }
  public function elemWith(v:T,with:T->T->Bool){
    return switch (this){
      case Cons(x,_) : with(v,x);
      default : false;
    }
  }
  public function zipWith<U>(that:Iterable<U>,with){
    var it = that.iterator();

    return map(
      (x) -> if(it.hasNext()){
        with(x,it.next());
      }else{
        __.fault().unexpected_iter_exhaustion().throwSelf();
        null;
      }
    );
  };
  public function foldr<Z>(fn:T->Z->Z,z:Z):Z{
    function rec(next:List<T>,memo:Z):Z{
      return switch(next){
        case Nil        : memo;
        case Cons(x,xs) :
          var nx = rec(xs,memo);
          var lx = fn(x,nx);
          lx;
      }
    }
    return rec(this,z);
  }

  public function zip<U>(that){
    return zipWith(that,tuple2);
  }
  public function size(){
    return fold(
      (n,m) -> m++,0
    );
  }
  public function defined(){
    return switch(this){
      case Nil  : false;
      default   : true;
    };
  }
}