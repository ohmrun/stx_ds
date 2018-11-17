package ranges;

import ifs.Range in IRange;

class SingleItemRange<T> implements IRange<T>{
  private var value : T;
  private var used  : Bool;
  public function new(value){
    this.used   = false;
    this.value  = value;
  }
  public function move():Void{
    this.used = true;
  }
  public function done():Bool{
    return this.used;
  }
  public function data():T{
    return value;
  }
}