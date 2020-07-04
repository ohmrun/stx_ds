package hx.ds;

class Edge<T> extends hx.ds.impl.Symbol{
  public function new(from,to){
    super();
    this.from   = from;
    this.to     = to;
  }
  public var from : T;
  public var to   : T;
}
