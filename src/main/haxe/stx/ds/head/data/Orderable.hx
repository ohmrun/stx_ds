package stx.ds.head.data;

interface Orderable<T>{
  public function lt(l:T,r:T):Bool;
}