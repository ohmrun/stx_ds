package hx.ds.impl;

import hx.ds.ifs.Symbol in ISymbol;

import haxe.ds.HashMap;

class Symbol implements ISymbol{
  public function new(){
    this.id = thx.Uuid.create();
  }
  @:isVar public var id(get,set) : String;
  private function get_id():String{
    return id;
  }
  private function set_id(str:String):String{
    return this.id = str;
  }
  public function equals(d:Dynamic):Bool{
    return this.id == Reflect.field(d,'id') && this.id != null;
  }
}