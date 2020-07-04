package hx.ds.symbol;

import hx.ds.impl.Symbol in CSymbol;

class Packet<T> extends CSymbol{
  public var payload(default,null) : T;
  public function new(payload:T){
    super();
    this.payload = payload;
  }
}
