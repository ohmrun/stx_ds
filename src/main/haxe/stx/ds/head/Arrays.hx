package stx.ds.head;

class Arrays{
  static public var _(default,null) = new stx.ds.body.Arrays();
  static public var ZERO(default,null) : Array<Dynamic> = [];
  /**
		create an empty Array.
	**/
  @:noUsing static public function create<A>():Array<A>{
    return [];
  }
  /**
		unit function.
	**/
  static public function unit<A>():Array<A>{
    return [];
  }
  /**
		create an Array with the element `v`.
	**/
  @:noUsing static public function one<A>(v:A):Array<A>{
    return [v];
  }
  /**
		create an Array with the element `v`.
	**/
  @:noUsing static public function pure<A>(v:A):Array<A>{
    return [v];
  }
  /**
		Produces an Array from an Array of Arrays.
	**/
  static public function flatten<T>(arrs: Array<Array<T>>): Array<T> {
    var res : StdArray<T> = [];
    for (arr in arrs) {
      for (e in arr) {
        res.push(e);
      }
    }
    return res;
  }

  /**

   Weaves an `Array` of arrays so that `[ array0[0] , array1[0] ... arrayn[0] , array0[1], array1[1] ... ]`
   Continues to operate to the length of the shortest array, and drops the rest of the elements.

	**/
  static public function interleave<T>(alls: Array<Array<T>>): Array<T> {
    var res = [];
    if (alls.length > 0) {
      var length = {
        var minLength = alls[0].length;
        for (e in alls)
          minLength = Std.int(Math.min(minLength, e.length));
        minLength;
      }
      var i = 0;
      while (i < length) {
        for (arr in alls)
          res.push(arr[i]);
        i++;
      }
    }
    return res;
  }
}