package stx.ds.head.data;

interface Set<T> extends T{
  public function add(v:T):Set<T>;
  public function rem(v:T):Set<T>;
  public function has(v:T):Set<T>;
}