package stx.ds.xset.pack;

import stx.ds.xset.head.data.Branch in BranchT;
import stx.ds.xset.body.Branchs;

@:forward abstract Branch<S,T>(BranchT<S,T>) from BranchT<S,T>{
  public function new(self){
    this = self;
  }
} 