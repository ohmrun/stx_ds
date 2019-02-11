package stx.ds.xset.pack;

import stx.ds.xset.head.data.XSet in XSetT;

@:forward abstract XSet<S,T>(XSetT<S,T>) from XSetT<S,T>{
  public function new(self){
    this = self;
  }
}