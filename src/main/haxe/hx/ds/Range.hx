package;

import ranges.*;
import ifs.Range in IRange;

@:forward abstract Range<T>(IRange<T>) from IRange<T> to IRange<T>{
  public function new(v){
    this = v; 
  }
  @:from static public function fromIterable<T>(v:Array<T>):Range<T>{
    return new IteratorRange(v.iterator());
  }
  @:from static public function fromIterator<T>(v:Iterator<T>):Range<T>{
    return new IteratorRange(v);
  }
  @:from static public function fromPrimitive<T>(v:T):Range<T>{
    return new ranges.SingleItemRange(v);
  }
}