package stx.ds;

typedef Errors        = stx.ds.body.Errors;

class Lift{}

class LiftArray{
  static public function ds<T>(arr:StdArray<T>):stx.ds.pack.Array<T>{
    return arr;
  }
}
class LiftList{
  static public function ds<T>(ls:stx.ds.head.data.List<T>):stx.ds.pack.List<T>{
    return ls;
  }
}
class LiftReadonlyArray{
  static public function ds<T>(arr:haxe.ds.ReadOnlyArray<T>):stx.ds.pack.Array<T>{
    return new stx.ds.pack.Array(cast arr);
  }
}
class LiftStringMap{
  static public function ds<T>(m:StdMap<String,T>):stx.ds.pack.Map<String,T>{
    var nm = Maps.make(
      Comparables.term.string()
    );
    for( key => val in m){
      nm = nm.set(key,val);
    }
    return nm;
  }
}