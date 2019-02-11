package stx.ds.xset.pack;

import haxe.rtti.CType.TypeRoot;
import stx.ds.xset.body.Roots;
import stx.ds.xset.body.Nodes; 
import stx.ds.xset.head.data.Branch in BranchT;
import stx.ds.xset.head.data.Root in RootT;

abstract Root<S,T>(RootT<S,T>) from RootT<S,T> to RootT<S,T>{
  public function iterator(){
    return this.iterator();
  }
  public function new(self){
    this = self;
  }
  public function putcat(that:Root<S,T>,with):Root<S,T>{
    var next : Collection<Node<S,T>> = that.unwrap();
    return this.putcat(next,with);
  }
  public function map<U>(fn:T->U):Root<S,U>{
    return this.map(
      (node) -> node.map(fn)
    );
  }
  public function unwrap():RootT<S,T>{
    return this;
  }
  public function keys():Collection<S>{
    return this.fmap(
      (node) -> node.keys()
    );
  }
  public function of(with:S->Bool):Root<S,T>{
    return new Root(this.fmap(
      (node) -> node.of(with)
    ));
  }
  public function put(node:Node<S,T>,with:With<S,T>){
    return this.put(node,
      (l,r) -> Nodes.eq(with,l,r).toBool()
    );
  }
  public function eq(that:Root<S,T>,with:With<S,T>):Equaled{
    var out = Equaled.AreEqual;
    for(l in this){
      for(r in that){
        if(!l.eq(r,with)){
          out = Equaled.NotEqual;
          break;
        }
        if(!out){
          break;
        }
      }
    }
    return out;
  }
  public function union(that:Root<S,T>,with:With<S,T>):Root<S,T>{
    return this.putcat(that,
      (l,r) -> Nodes.eq(with,l,r)
    );
  }
  public function branch(s:S):Branch<S,T>{
    return new BranchT(s,this);
  }
  public function scope(s:S):Node<S,T>{
    return Scope(branch(s));
  }
}