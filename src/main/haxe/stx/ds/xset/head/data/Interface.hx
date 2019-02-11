package stx.ds.xset.head.data;

interface Interface<S,T>{
  public function put(v:T):Interface<S,T>;
  public function rem(v:T):Interface<S,T>;
}