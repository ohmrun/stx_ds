package stx.ds;

enum LinkedListSum<T>{
  Nil;
  Cons(head:T,tail:LinkedList<T>);
}

abstract LinkedList<T>(LinkedListSum<T>) from LinkedListSum<T> to LinkedListSum<T>{
  // @:from static public function fromIndex<T>(arr:StdArray<T>):LinkedList<T>{
  //   var self   = unit();
  //   var i     = arr.length - 1; 
  //   while(i >= 0){
  //     self = self.cons(arr[--i]);
  //   }
  //   return self;
  // }
  static public function unit<T>():LinkedList<T>{
    return Nil;
  }
  static public function pure<T>(v:T):LinkedList<T>{
    return Cons(v,Nil);
  }
  public function new(self:LinkedListSum<T>){
    this = self;
  }
  public function tail():LinkedList<T>{
    return switch(this){
      case Nil : Nil;
      case Cons(_,next): next;
    }
  }
  public function cons(v:T):LinkedList<T>{
    return new LinkedList(Cons(v,this));
  }
  public function snoc(v:T):LinkedList<T>{
    function rec(ls:LinkedListSum<T>){
      return switch ls {
        case Nil              : Cons(v,Nil);
        case Cons(head, tail) : Cons(head,rec(tail));
      }
    }
    return rec(this);
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
  public function concat(that : LinkedList<T>) : LinkedList<T>{
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
  public function find(fn:T->Bool):Option<T>{
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
  @:to public function toIterable():Iterable<T>{
    return {
      iterator : iterator
    };
  }
  public function iterator():Iterator<T>{
    var cursor : Null<LinkedList<T>> = this;
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
          case Nil   : false;
          default    : true;
        }
      }
    }
  }
  public function map<B>(f : T -> B) : LinkedList<B>{
    return switch this {
      case Nil          : Nil;
      case Cons(x, xs)  : Cons(f(x), xs.map(f));
    };
  }
  public function map_filter<B>(f : T -> Option<B>) : LinkedList<B>{
    return switch this{
      case Nil          : Nil;
      case Cons(x, xs)  :
        var nxt = f(x);
        switch(nxt){
          case Some(v) : Cons(v,xs.map_filter(f));
          default      : xs.map_filter(f);
        }
    };
  }
  // static public function monoid<T>():Monoid<LinkedList<T>>{
  //   return {
  //     batch : (l:LinkedList<T>,r:LinkedList<T>) -> l.concat(r),
  //     prior : () -> LinkedList.unit()
  //   }
  // }
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
        throw __.fault().of(ERR_OF(E_IteratorExhaustedUnexpectedly));
      }
    );
  };
  public function rfold<Z>(fn:T->Z->Z,z:Z):Z{
    function rec(next:LinkedList<T>,memo:Z):Z{
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
  public function lfold<Z>(fn:T->Z->Z,z:Z):Z{
    function rec(next:LinkedList<T>,memo:Z):Z{
      return switch(next){
        case Nil        : memo;
        case Cons(x,xs) :
          //trace(x);
          //trace(xs);
          var lx = fn(x,memo);
          var nl = xs.lfold(fn,lx);
          nl;
      }
    }
    return rec(this,z);
  }
  public function join(str):String{
    return map(Std.string).lfold(
      (n,m:String) -> switch(m.length){
        case 0  : '$n';
        default : '$m$str$n';
      },
      ""
    );
  }
  public function zip<U>(that){
    return zipWith(that,__.couple);
  }
  public function size(){
    return fold(
      (n,m) -> m++,0
    );
  }
  public function is_defined(){
    return switch(this){
      case Nil  : false;
      default   : true;
    };
  }
  public function has(v:T){
    var nxt = null;
    return (nxt = (ls:LinkedList<T>) -> switch(ls){
      case Cons(x,xs) : 
        if(x == v){
          true;
        }else{
          nxt(xs);
        };
      default : false;
    })(this);
  }
  public function filter(fn:T->Bool):LinkedList<T>{
    return rfold(
      (next:T,memo:LinkedList<T>) -> switch(fn(next)){
        case false : memo;
        case true  : memo.cons(next);
      },
      unit()
    );
  }
  public function toArray():Array<T>{
    return lfold(
      (n,m:Array<T>) -> m.snoc(n),
      []     
    );
  }
}