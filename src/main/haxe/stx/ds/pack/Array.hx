package stx.ds.pack;

import haxe.Constraints.IMap;
import stx.ds.head.Arrays;

@:forward(iterator,join,length)abstract Array<T>(StdArray<T>) from StdArray<T>{
  public function new(self) this = self;

  @:arrayAccess public function get(v:Int) return this[v];

  public function snoc(v:T):Array<T>                                  return Arrays._.snoc(v,this);
  public function cons(v:T):Array<T>                                  return Arrays._.cons(v,this);
  public function head():Option<T>                                    return Arrays._.head(this);
  public function tail():Array<T>                                     return Arrays._.tail(this);
  public function concat(that:Array<T>):Array<T>                      return Arrays._.concat(that,this);

  public function map<U>(fn:T->U):Array<U>                            return Arrays._.map(fn,this);
  public function mapi<U>(fn:Int->T->U):Array<U>                      return Arrays._.mapi(fn,this);
  public function fmap<U>(fn:T->Iterable<U>):Array<U>                 return Arrays._.fmap(fn,this);

  public function lfold<U>(fn:T->U->U,memo:U):U                       return Arrays._.lfold(fn,memo,this);
  public function lfold1(fn:T->T->T):Option<T>                        return Arrays._.lfold1(fn,this);
  public function rfold<Z>(fn:T->Z->Z,z:Z):Z                          return Arrays._.rfold(fn,z,this);

  public function filter(fn:T->Bool):Array<T>                         return Arrays._.filter(fn,this);
  public function map_filter<U>(fn:T->Option<U>):Array<U>             return Arrays._.map_filter(fn,this);
  public function whilst(fn:T->Bool):Array<T>                         return Arrays._.whilst(fn,this);
  
  public function ltaken(n):Array<T>                                  return Arrays._.ltaken(n,this);
  public function ldropn(n):Array<T>                                  return Arrays._.ldropn(n,this);
  public function rdropn(n:Int):Array<T>                              return Arrays._.rdropn(n,this);
  


  public function is_defined():Bool                                   return Arrays._.is_defined(this);
  public function search(fn:T->Bool):Option<T>                        return Arrays._.search(fn,this);
  public function all(fn:T->Bool):Bool                                return Arrays._.all(fn,this);
  public function any(fn:T->Bool)                                     return Arrays._.any(fn,this);

  
  public function zip<U,Z>(that:Array<U>,fn:T->U->Z):Array<Z>         return Arrays._.zip(fn,that,this);
  public function cross<U>(that:Array<U>):Array<Tuple2<T,U>>          return Arrays._.cross(that,this);  

  public function snapshot():StdArray<T>                              return Arrays._.snapshot(this);
  public function reversed():Array<T>                                 return Arrays._.reversed(this);

  public function iterator():Iterator<T>                              return this.iterator();
  public function prj():StdArray<T>                                   return this;
  public function toList()                                            return Arrays._.toList(this);
  @:to public function toIterable():Iterable<T>                       return this;
}