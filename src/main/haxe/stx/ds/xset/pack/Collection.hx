package stx.ds.xset.pack;

import stx.ds.xset.head.data.Collection in CollectionT;

@:allow(stx.ds.xset.pack.Collection)abstract Collection<T>(CollectionT<T>) from CollectionT<T>{
  public function new(self){
    this = self;
  }
  @:from static public function fromIterator<T>(it:Iterator<T>):Collection<T>{
    var out = [];
    while(it.hasNext()){
      out.push(it.next());
    }
    return out;
  }
  public function iterator(){
    return this.iterator();
  }
  @:arrayAccess inline function get(i:Int)      return this[i];

  public function eq(that:Collection<T>,with:T->T->Bool){
    var result  = true;
    var idx     = 0;
    while(result == true){
      result = with(this[idx],that[idx]);
      idx++;
    }
    return result;
  }
  public function has(element:T,eq:T->T->Bool){
    var it = iterator();
    while(it.hasNext()){
      if(eq(it.next(), element)){
        return true;
      }
    }
    return false;
  }
  public function put(v:T,with:T->T->Bool):Collection<T>{
    return if(!has(v,with)){
      return this.concat([v]);
    }else{
      this;
    }
  }
  public function putcat(that:Collection<T>,with:T->T->Bool):Collection<T>{
    return fold(
      (next:T,memo:Collection<T>) -> memo.put(next,with) 
      ,that
    );
  }
  public function map<U>(fn:T->U):Collection<U>{
    return this.map(fn);
  }
  public function fmap<U>(fn:T->Collection<U>):Collection<U>{
    return this.fmap(
      (x) -> fn(x).unwrap() 
    );
  }
  public function fold<R>(fn:T->R->R,r):R{
    return this.fold(
      fn,
      r
    );
  }
  function unwrap():Array<T>{
    return this;
  }
} 