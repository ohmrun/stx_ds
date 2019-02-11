package stx.ds.xset.head.data;

import stx.ds.xset.body.Nodes;
import stx.ds.xset.pack.Root in RootA;
import stx.ds.xset.pack.Node in NodeA;
import stx.ds.xset.pack.Branch in BranchA;

class Branch<S,T>{
  public function new(scope,value){
    this.scope = scope;
    this.value = value;
  }
  public var scope(default,null) : S;
  public var value(default,null) : RootA<S,T>; 

  public function map<U>(fn:T->U):BranchA<S,U>{
    return new Branch(scope,
      value.map(fn)
    );
  }
  public function union(that:BranchA<S,T>,with:With<S,T>):Root<S,T>{
    return if(with.S.eq(this.scope,that.scope)){
      [Scope(new Branch(this.scope,this.value.union(that.value,with)))];
    }else{
      [Scope(this),Scope(that)];
    }
  }
  public function keys(){
    return value.keys();
  }
  public function of(with:S->Bool):Root<S,T>{
    return with(scope) ? value : [];
  }
  public function eq(that:BranchA<S,T>,with:With<S,T>):Equaled{
    var out = true;
    return switch(with.S.eq(this.scope,that.scope)){
      case true   : this.value.eq(that.value,with);
      case false  : false;
    }
  }
}