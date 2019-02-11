package stx.ds.xset.head.data;

import stx.ds.xset.pack.Root in RootA;
import stx.ds.xset.pack.XSet in XSetA;

class XSet<S,T>{
  public var with(default,null) : With<S,T>;
  public var data(default,null) : RootA<S,T>;

  public function new(with,data){
    this.with = with;
    this.data = data;
  }
  function next(r:RootA<S,T>):XSetA<S,T>{
    return new XSet(with,r);
  }
  public function union(that:XSetA<S,T>):XSetA<S,T>{
    return next(this.data.union(that.data,with));
  }
}