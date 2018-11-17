package ranges;

import hx.ds.ifs.Range;

class IteratorRange<T> implements Range<T>{
  private var iterator  : Iterator<T>; 
  private var previous  : Null<T>;
  private var started   : Bool;

  public function new(iterator:Iterator<T>){
    this.iterator = iterator;
    this.started  = false;
  }
  public function move():Void{
    previous = iterator.next();
  }
  public function done():Bool{
    return !iterator.hasNext();
  }
  public function data():T{
    if(!started){
      previous = iterator.next();
      started = true;
    }
    return previous;
  }
}