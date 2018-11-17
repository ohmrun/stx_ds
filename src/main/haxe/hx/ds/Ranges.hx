package;

using stx.Arrays;

class Ranges{
  static public inline function fold<T,U>(r:Range<T>,fn:U->T->U,init:U):U{
    var memo = init;
    while(!r.done())
      memo = fn(memo,r.data());
      r.move();
    }
    return memo;
  } 
  static public function map<T,U>(r:Range<T>,fn:T->U):Range<U>{
    return fold(
      r,
      function(memo,next:T){
        return Arrays.add(memo,fn(next));
      }
      ,[]
    );
  }
  static public function each<T>(r:Range<T>,fn:T->Void):Range<T>{
    return map(r,
      function(x){
        fn(x);
        return x;
      }
    );
  }
}