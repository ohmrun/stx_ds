package stx.ds.xset.head.data;

import stx.ds.xset.pack.Branch in BranchA;

class Namespace<S,T>{
  private var with              : With<S,T>;
  public var data(default,null) : BranchA<S,T>;
  public function new(with,data){
    this.with = with;
    this.data = data;
  }
}