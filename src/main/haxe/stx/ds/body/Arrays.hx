package stx.ds.body;

class Arrays extends Clazz{
  public inline function random<T>(arr:Array<T>):Null<T>{
    var len = arr.length;
    var ind = Math.round( Math.random() * (len - 1));
    return arr[ind];
  }
  public inline function bind_fold<R,A,B,M>(pure:B->M,init:B,bind:M->(B->M)->M,fold:A->B->B,arr:Array<A>){
    return lfold(
      function(next:A,memo:M){
        return bind(memo,
          function(b:B){
            return pure(fold(next,b));
          }
        );
      },
      pure(init),
      arr
    );
  }
  public inline function reduce<A,Z>(zero:Void->Z,unit:A->Z,plus:Z->Z->Z,arr:Array<A>):Z{
    return arr.lfold(
      function(next,memo){
        return plus(memo,unit(next));
      },
      zero()
    );
  }
  /**
		Call f on each element in a, returning a collection where f(e) = true.
	**/
  public inline function filter<T>(f: T -> Bool,a: Array<T>): Array<T> {
    var n: StdArray<T> = [];

    for (e in a)
      if (f(e)) n.push(e);

    return n;
  }
  public inline function map_filter<T,U>(f: T-> Option<U>,arr:Array<T>) : Array<U>{
    return lfold(
      (next,memo:Array<U>) -> switch(f(next)){
        case Some(v)  : memo.snoc(v);
        default       : memo;
      },
      [].ds(),
      arr
    );
  }
  /**
		Return true if length is greater than 1.
	**/
  public inline function is_defined<T>(a:Array<T>):Bool{
    return a.length > 0;
  }
  /**
		Applies function f to each element in a, returning the results.
	**/
  public inline function map<T, S>(f: T -> S,a: Array<T>): Array<S> {
    var n: StdArray<S> = [];

    for (e in a) n.push(f(e));

    return n;
  }
  public inline function mapi<T, S>(f: Int -> T -> S,a: Array<T>): Array<S> {
    var n: StdArray<S> = [];
    var e           = null;
    for (i in 0...a.length){
      e = a[i];
      n.push(f(i,e));
    };

    return n;
  }
  /**

    Using starting var z, run f on each element, storing the result, and passing that result
    into the next call:

        [1,2,3,4,5].lfold( function(next,memo) return init + v ));//(((((100 + 1) + 2) + 3) + 4) + 5)

	**/
  public inline function lfold<T, Z>(f: T -> Z -> Z,z:Z,a: Array<T>): Z {
    var r = z;

    for (e in a) { r = f(e,r); }

    return r;
  }
  /**
		set `v` at index `i` of `arr`.
	**/
  public inline function set<A>(i:Int,v:A,arr:Array<A>):Array<A>{
    var arr0 : StdArray<A>     = arr.prj().copy();
    arr0[i]  = v;
    return arr0;
  }
  /**
		return element of `arr` at index `i`
	**/
  public inline function get<A>(i:Int,arr:Array<A>):A{
    return arr[i];
  }
  /**
    return element of `arr` at index `i`
  **/
  public inline function at<A>(i:Int,arr:Array<A>):A{
    return arr[i];
  }
  /**
		Performs a `lfold`, using the first value of `arr` as the `memo` value.
	**/
   public inline function lfold1<T>(mapper: T -> T -> T,arr: Array<T>): Option<T> {
    var folded = arr.head();
    var tail   = arr.tail();
    return folded.map(
      (memo) -> {
        for(item in tail){
          memo = mapper(memo, item);
        };
        return memo;
      }
    );
  }
  /**
		Produces a `Tuple2` containing two `Array`, the left being elements where `f(e) == true`, the rest in the right.
	**/
  @params('The array to partition','A predicate')
  public inline function partition<T>(f: T -> Bool,arr: Array<T>): Tuple2<Array<T>, Array<T>> {
    return arr.lfold(function(b,a:Tuple2<Array<T>,Array<T>>) {
      if(f(b))
        a.fst().prj().push(b);
      else
        a.snd().prj().push(b);
      return a;
    },tuple2([], []));
  }

  /**

    Applies function f to each element in a, concating and returning the results.

	**/
  public inline function fmap<T, S>(f:T->Iterable<S>,a:Array<T>):Array<S> {
    var n: StdArray<S> = [];

    for (e1 in a) {
      for (e2 in f(e1)) n.push(e2);
    }

    return n;
  }
  /**

    Counts some property of the elements of `arr` using a predicate. For the size of the Array @see `size()`

	**/
  public inline function count<T>(f: T -> Bool,arr: Array<T>): Int {
    return arr.lfold(function(b,a) {
      return a + (if (f(b)) 1 else 0);
    },0);
  }
  /**

    Takes an initial value which is passed to function `f` along with each element
    one by one, accumulating the results.
    f(next,memo)

	**/
  public inline function scanl<T>(f: T -> T -> T,init: T,arr:Array<T>): Array<T> {
    var accum   = init;
    var result  = [init];

    for (e in arr)
      result.push(f(e, accum));

    return result;
  }
  /**
		As `scanl` but from the end of the Array.
	**/
  public inline function rscan<T>(init: T, f: T -> T -> T,arr:Array<T>): Array<T> {
    var a = arr.snapshot();
    a.reverse();
    return scanl(f,init,a);
  }
  /**
		As scanl, but using the first element as the second parameter of `f`
	**/
  public inline function lscan1<T>(f: T -> T -> T,arr:Array<T>): Array<T> {
    var result = [];
    if(0 == arr.length)
      return result;
    var accum = arr[0];
    result.push(accum);
    for(i in 1...arr.length)
      result.push(f(arr[i], accum));

    return result;
  }
  /**
		As scanr, but using the first element as the second parameter of `f`
	**/
  public inline function rscan1<T>(f: T -> T -> T,arr:Array<T>): Array<T> {
    var a = arr.snapshot();
    a.reverse();
    return lscan1(f,a);
  }
  /**
		Returns the Array cast as an Iterable.
	**/
  public inline function elements<T>(arr: Array<T>): Iterable<T> {
    return arr.snapshot();
  }
  /**
		concats the elements of `i` to `arr`
	**/
  public inline function concat<T>(i: Iterable<T>,arr: Array<T>): Array<T> {
    var acc = arr.snapshot();

    for (e in i)
      acc.push(e);

    return acc;
  }
  /**
		Produces `true` if the Array is empty, `false` otherwise
	**/
  public inline function containsValues<T>(arr: Array<T>): Bool {
    return arr.length > 0;
  }
  /**

    Produces an `Option.Some(element)` the first time the predicate returns `true`,
    `None` otherwise.

	**/
  public inline function search<T>(f: T -> Bool,arr: Array<T>): Option<T>{
    return arr.lfold(
      function(b,a:Option<T>) {
        return switch (a) {
            case None   : Options.create(b).filter(f);
            case Some(v): Some(v);
          }
      },
      None
    );
  }
  /**
		Returns an `Option.Some(index)` if an object reference is contained in `arr`, `None` otherwise.
	**/
  public inline function owns<T>(arr: Array<T>, obj: T): Option<Int> {
   var index = arr.prj().indexOf(obj);
   return if (index == -1) None else Some(index);
  }

  /**
   Returns an Array that contains all elements from a which are not elements of b.
    If a contains duplicates, the resulting Array contains duplicates.
	**/
  public inline function difference<T>(eq:T->T->Bool, a:Array<T>, b:Array<T>){
    var res = [];
    for (e in a) {
      if (!any(function (x) return eq(x, e),b)) res.push(e);
    }
    return res;
  }
  public inline function shuffle <T>(arr: Array<T>): Array<T>{
    var res = [];
    var cp = arr.prj().copy();
    while (cp.length > 0) {
      var randIndex = Math.floor(Math.random()*cp.length);
      res.push(cp.splice(randIndex,1)[0]);
    }
    return res;
  }
  /**

    Returns an Array that contains all elements from a which are also elements of b.
    If a contains duplicates, so will the result.

	**/
  public inline function union<T>(eq:T->T->Bool, a:Array<T>, b:Array<T>){
    var res = [];
    for(e in a){
      res.push(e);
    }
    for (e in b) {
      if (!any( function (x) return eq(x, e),res)) res.push(e);
    }
    return res;
  }

  public inline function unique<T>(eq:T->T->Bool,x:Array<T>):Array<T>{
    var eq : T -> T -> Bool = null;
    var r = [];
      for (e in x){
        var exists  = has(eq.bind(e),r);
        var val     = search(eq.bind(e),r);
        //trace('$exists $e in $r $val');
        if (!exists){
          r.push(e);
        } // you can inline exists yourself if you care much about speed. But then you should consider using hash tables or such

      }
    return r;
  }
  /**
		Produces `true` if the predicate returns `true` for all elements, `false` otherwise.
	**/
  public inline function all<T>(f: T -> Bool,arr: Array<T>): Bool {
    return arr.lfold(function(b,a) {
      return switch (a) {
        case true:  f(b);
        case false: false;
      }
    },true);
  }
  /**
		Produces `true` if the predicate returns `true` for *any* element, `false` otherwise.
	**/
  public inline function any<T>(f: T -> Bool,arr: Array<T>): Bool {
    return arr.lfold(function(b,a) {
      return switch (a) {
        case false: f(b);
        case true:  true;
      }
    },false);
  }
  /**
		Determines if a value is contained in `arr` using a predicate.
	**/
  public inline function has<T>(f: T -> Bool,arr: Array<T>): Bool {
    return switch (search(f,arr)) {
      case Some(_): true;
      case None:    false;
    }
  }
  /**
		Produces an Array with no duplicate elements. Equality of the elements is determined by `f`.
	**/
  public inline function nub<T>(f: T -> T -> Bool,arr:Array<T>): Array<T> {
    return arr.lfold(
      function(b: T,a: Array<T>): Array<T> {
        return if (has(f.bind(b), a)) {
          a;
        }
        else {
          a.snoc(b);
        }
      },
      []
    );
  }
  /**
		Intersects two Arrays, determining equality by `f`.
	**/
  public inline function intersect<T>(f: T -> T -> Bool, arr1: Array<T>, arr2: Array<T>): Array<T> {
    return arr1.lfold(
      (next:T, memo:Array<T>) -> switch(has(f.bind(next),arr2)){
        case true : memo.snoc(next);
        default   : memo;
      },
      [].ds()
    );
  }

  /**
		Produces the index of element `t`. For a function producing an `Option`, see `findIndexOf`.
	**/
  public inline function index<T>(a: Array<T>, t: T->Bool): Int {
    var index = 0;

    for (e in a) {
      if (t(e)) return index;

      ++index;
    }

    return -1;
  }
  /**
		As with `lfold` but working from the right hand side.
	**/
  public inline function rfold<T, Z>(f: T -> Z -> Z,z: Z,a: Array<T>): Z {
    var r = z;

    for (i in 0...a.length) {
      var e = a[a.length - 1 - i];

      r = f(e, r);
    }

    return r;
  }
  /**
		Produces an `Array` of `Tuple2` where `Tuple2.t2(a[n],b[n]).`
	**/
  public inline function zip<A, B,C>(f:A -> B -> C,b: Array<B>,a: Array<A>): Array<C> {
    var next  = [];
    var lower = Std.int(Math.min(a.length,b.length));
    for(i in 0...lower){
      next.push(f(a[i],b[i]));
    }
    return next;
  }
  public inline function snoc<T>(t: T,a: Array<T>): Array<T> {
    var copy = snapshot(a);

    copy.push(t);

    return copy;
  }
  /**
		Adds a single elements to the beginning if the Array.
	**/
  public inline function cons<T>(t: T,a: Array<T>): Array<T> {
    var copy = snapshot(a);

    copy.unshift(t);

    return copy;
  }
  /**
		Produces the first element of `a` as an `Option`, `Option.None` if the `Array` is empty.
	**/
  public inline function head<T>(a: Array<T>): Option<T> {
    return if (a.length == 0) None; else Some(a[0]);
  }
  /**
		Produces the first element of `a` as an `Option`, `Option.None` if the `Array` is empty.
	**/
  public inline function tail<T>(a: Array<T>): Array<T> {
    return a.prj().slice(1);
  }
  /**
		Produces the last element of Array `a`
	**/
  public inline function last<T>(a: Array<T>): Option<T> {
    return __.option(a[a.length - 1]);
  }
  /**
		Produces an `Array` from `a[0]` to `a[n]`
	**/
  public inline function ltaken<T>(n: Int,a: Array<T>): Array<T> {
    return a.prj().slice(0, Std.int(Math.min(n,a.length)));
  }
  /**
	
  /**
		Produces an Array from `a[0]` while predicate `p` returns `true`
	**/
  public inline function whilst<T>(p: T -> Bool,a: Array<T>): Array<T> {
    var r = [];


    for (e in a) {
      if (p(e)) r.push(e); else break;
    }

    return r;
  }
  /**
		Produces an Array from `a[n]` to the last element of `a`.
	**/
  public inline function ldropn<T>(n: Int,a: Array<T>): Array<T> {
    return if (n >= a.length) [] else a.prj().slice(n);
  }
  /**
		Produces an Array from `a[0]` to a[a.length-n].
	**/
  public inline function rdropn<T>(n: Int,a: Array<T>): Array<T> {
    return if (n >= a.length) [] else a.prj().slice(0,a.length - n);
  }
  /**
		Drops values from Array `a` while the predicate returns true.
	**/
  public inline function drop<T>(a: Array<T>, p: T -> Bool): Array<T> {
    var r = [].concat(a.prj());

    for (e in a) {
      if (p(e)) r.shift(); else break;
    }

    return r;
  }
  /**
		Produces an Array with the elements in reversed order
	**/
  public inline function reversed<T>(arr: Array<T>): Array<T> {
    return arr.lfold(function(b,a:StdArray<T>) {
      a.unshift(b);

      return a;
    },[]);
  }
  /**
		Produces an Array of arrays of size `sizeSrc`
	**/
  public inline function chunk<T>(srcArr : Array<T>, sizeSrc : Array<Int>) : Array<Array<T>> return {
    var slices = [];
    var restIndex = 0;
    for (size in sizeSrc) {
      var newRestIndex = restIndex + size;
      var slice = srcArr.prj().slice(restIndex, newRestIndex);
      slices.push(slice);
      restIndex = newRestIndex;
    }
    slices;
  }
  /**
		Produces a map
	**/
  public inline function toMap<V>(arr:Array<Tuple2<String,V>>):StdMap<String,V>{
    var mp = new haxe.ds.StringMap();
    for(tp in arr){
      __.into2(
        function(l,r){mp.set(l,r);}
      )(tp);
    }
    return mp;
  }
  /**
		Pads out to len, ignores if len is less than Array length.
	**/
  public inline function pad<T>(len:Int,?val:T,arr:Array<T>):Array<T>{
    var len0 = len - arr.length;
    var arr0 = [];
    for (i in 0...len0){
      arr0.push(val);
    }
    return arr.concat(arr0);
  }
  /**
		Fills `null` values in `arr` with `def`.
	**/
  public inline function fill<T>(def:T,arr:Array<T>):Array<T>{
    return arr.map(
      function(x){
        return x == null ? def : x;
      }
    );
  }
  public inline function and<A>(eq:A->A->Bool,arr1:Array<A>,arr0:Array<A>):Bool{
    return arr0.zip(arr1,tuple2).lfold(
      function(next:Tuple2<A,A>,memo:Bool){
        return memo ? eq(next.fst(),next.snd()) && eq(next.fst(),next.snd()) : memo;
      },true
    );
  }
  public inline function rotate<A>(num:Int,arr0:Array<A>):Array<A>{
    num = num%arr0.length;
    var l = arr0.ltaken(num);
    var r = arr0.ldropn(num);
    return if(num < 0){
      r.concat(l);
    }else if(num > 1){
      r.concat(l);
    }else{
      arr0;
    }
  }
  /**
		Returns the size of a
	**/
  public inline function size<T>(a: Array<T>): Int {
    return a.length;
  }
  /**
		Returns a mutable copy of a.
	**/
  public inline function snapshot<T>(a: Array<T>): StdArray<T> {
    return [].concat(a.prj());
  }
  /**
    from thx.core
    It returns the cross product between two arrays.
    ```haxe
    var r = [1,2,3].cross([4,5,6]);
    trace(r); // [[1,4],[1,5],[1,6],[2,4],[2,5],[2,6],[3,4],[3,5],[3,6]]
    ```
  **/
  public inline function cross<T,U>(b : Array<U>,a : Array<T>):Array<Tuple2<T,U>> {
    var r = [];
    for (va in a)
      for (vb in b)
        r.push(tuple2(va, vb));
    return r;
  }
  public inline function toList<T>(arr:Array<T>){
    return rfold(
      Cons,
      Nil.ds(),
      arr
    ).ds();
  }
}
