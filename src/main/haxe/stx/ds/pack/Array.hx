package stx.ds.pack;

import haxe.Constraints.IMap;


@:forward(iterator,join,length)abstract Array<T>(StdArray<T>) from StdArray<T>{
  @:arrayAccess public function get(v:Int){
    return this[v];
  }
  
  public function new(self) this = self;

  public function map<U>(fn:T->U):Array<U>{
    var out = [];
    for(val in this){
      out.push(fn(val));
    }
    return new Array(out);
  }
  public function snoc(v:T):Array<T>{
    var out = this.copy();
        out.push(v);
    return out;
  }
  public function cons(v:T):Array<T>{
    var out = this.copy();
        out.unshift(v);
    return out;
  }
  public function fmap<U>(fn:T->Array<U>):Array<U>{
    var out = [];
    for (arr in map(fn)){
      for(v in arr){
        out.push(v);
      }
    }
    return out;
  }
  public function fold<U>(fn:T->U->U,memo:U):U{
    return this.fold(fn,memo);
  }
  public function filter(fn:T->Bool):Array<T>{
    return this.filter(fn);
  }
  public function whilst(fn:T->Bool):Array<T>{
    var out = [];
    for(val in this){
      if(fn(val)){
        out.push(val);
      }else{
        break;
      }
    }
    return out;
  }
  public function prj():StdArray<T>{
    return this;
  }
  public function concat(that:Array<T>):Array<T>{
    return this.concat(that.prj());
  }
  public function cross<U>(that:Array<U>):Array<Tuple2<T,U>>{
    var out = [];
    for(i in this){
      for(j in that){
        out.push(tuple2(i,j));
      }
    }
    return out;
  }
  public function empty():Bool{
    return this.length == 0;
  }
  public function zip<U>(that:Array<U>):Array<Tuple2<T,U>>{
    var out = [];
    for(i in 0...this.length){
      out.push(tuple2(this[i],that[i]));
    }
    return out;
  }
  public function all(fn:T->Bool):Bool{
    var ok = true;
    for(v in this){
      ok = fn(v);
      if(!ok){
        break;
      }
    }
    return ok;
  }
  public function any(fn:T->Bool){
    var ok = false;
    for(v in this){
      if(ok){
        break;
      }else{
        ok = fn(v);
      }
    }
    return ok;
  }
  public function reversed():Array<T>{
    var out = [];
    var i   = this.length-1; 
    while(i > -1){
      out.push(this[i]);
      i--;
    }
    return out;
  }
  public function head():Option<T>{
    return __.core().option(this[0]);
  }
  public function tail():Array<T>{
    return this.slice(1);
  }
}