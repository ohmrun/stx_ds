package stx.ds;

class Lift{}

class LiftArray{
  static public function ds<T>(arr:StdArray<T>):stx.ds.pack.Array<T>{
    return arr;
  }
}
