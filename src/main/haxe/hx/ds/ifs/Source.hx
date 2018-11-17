package hx.ds.ifs;

interface Source<T>{
  public function peek():T;
  public function done():Bool;
}