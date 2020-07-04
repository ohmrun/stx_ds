package hx.ds;

import hx.ds.ifs.Symbol in ISymbol;
import hx.ds.impl.Symbol in CSymbol;
import hx.ds.symbol.Packet;

@:forward abstract Symbol(ISymbol) to ISymbol{
  public function new(self){
    this = self;
  }
  @:from static public function fromT<T>(v:T){
    return new Packet(v);
  }
}