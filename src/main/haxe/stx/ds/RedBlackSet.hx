package stx.ds;

typedef RedBlackSetDef<T> = { data : RedBlackTreeSum<T>, with : Comparable<T> }; 

@:using(stx.ds.RedBlackSet.RedBlackSetLift)
@:forward abstract RedBlackSet<T>(RedBlackSetDef<T>) from RedBlackSetDef<T>{
  static public var _(default,never) = RedBlackSetLift;

  private function new(self){
    this = self;
  }
  static public function make<T>(with:Comparable<T>,?data:RedBlackTree<T>):RedBlackSet<T>{
    return new RedBlackSet({
      with : with,
      data : data == null ? Leaf : data
    });
  }
  static public function make_with<T>(ord:Ord<T>,eq:Eq<T>,?data:RedBlackTree<T>):RedBlackSet<T>{
    var with : Comparable<T> = new stx.assert.comparable.term.Base(eq,ord);
    return make(with,data);
  }
  @:to public function toIterable():Iterable<T>{
    return {
      iterator : iterator
    };
  }
  public function iterator(){
    return RedBlackTree._.iterator(this.data);
  }
  public function difference(that:RedBlackSet<T>):RedBlackSet<T>{
    return _.filter(self,(v) -> !(that.uses(self.with).has(v)));
  }
  public function has(v:T):Bool{
    return RedBlackSet._.has(this,v);

  }
  public function equals(that:RedBlackSet<T>):Equaled{
    return _.union(self,that).fold(
      (next,memo:Equaled) -> memo && (has(next) ? AreEqual : NotEqual), 
      AreEqual
    );
  }
  public function uses(with:Comparable<T>):RedBlackSet<T>{
    return { data : this.data, with : with };
  }
  public function lt(that:RedBlackSet<T>):Ordered{
    return that.difference(this).fold((next,memo)-> memo++,0) > 0 ? LessThan : NotLessThan;    
  }
  private var self(get,never):RedBlackSet<T>;
  private function get_self():RedBlackSet<T> return this;

  public function toString(){
    return _.toString(this);
  }
}

class RedBlackSetLift{

  static public function balance<V>(set:RedBlackSet<V>):RedBlackSet<V>{
    return { data : RedBlackTree._.balance(set.data), with : set.with };
  }
  static public function put<V>(set: RedBlackSet<V>, val: V): RedBlackSet<V> {
    function ins(tree: RedBlackTree<V>, comparator: Assertion<V,AssertFailure>): RedBlackTree<V> {
      return switch (tree) {
        case Leaf: 
          Node(Red, Leaf, val, Leaf);
        case Node(color, left, v, right):
            if (comparator.comply(val, v).ok())
                RedBlackTree._.balance(Node(color, ins(left, comparator), v, right))
            else if (comparator.comply(v, val).ok())
                RedBlackTree._.balance(Node(color, left, v, ins(right, comparator)))
            else
                Node(color,left, val, right);//HMMM
      }
    };
    return switch (ins(set.data, set.with.lt())) {
      case Leaf:
          throw "Never reach here";
      case Node(_, left, label, right):
          { data: Node(Black, left, label, right), with: set.with };
    }
  }
  static public function concat<V>(set:RedBlackSet<V>,xs:Iterable<V>):RedBlackSet<V>{
    for(x in xs){
      set = set.put(x);
    }
    return set;
  }
  static public function toString<V>(set:RedBlackSet<V>):String{
    return RedBlackTree._.toString(set.data);
  }
  static public function rem<V>(set:RedBlackSet<V>, value:V): RedBlackSet<V>{
    var balance = RedBlackTree._.balance;
    var eq      = set.with.eq;
    var lt      = set.with.lt;

    function cons(data):RedBlackTree<V>{
      return data;
    }
    function s(v:RedBlackTree<V>){
      return RedBlackTree._.toString(v);
    }
    function merge(l:RedBlackTree<V>,r:RedBlackTree<V>){
      //trace('${s(l)}\n${s(r)}');
      return switch([l,r]){
        case [Leaf,v] : v;
        case [v,Leaf] : v;
        case [Node(c0,l0,v0,r0),Node(c1,l1,v1,r1)] if (lt().comply(v0,v1).ok()):
          balance(Node(c1,merge(l,l1),v1,r1));
        case [Node(c0,l0,v0,r0),Node(c1,l1,v1,r1)] if (lt().comply(v1,v0).ok()):
          balance(Node(c0,merge(l0,r),v0,r0));
        default : Leaf;
      }
    }
    function rec(data:RedBlackTree<V>):RedBlackTree<V>{
      return switch (data) {
        case Leaf                 : cons(Leaf);
        case Node(c,l,v,r):
        if(eq().comply(value,v).ok()){
          switch([l,r]){
            case [Leaf,v] : 
              cons(v);
            case [v,Leaf] : 
              cons(v);
            case [Node(c0,l0,v0,r0),Node(c1,l1,v1,r1)] :
              var out = merge(l,r);
              //trace(RedBlackTree._.toString(r));
              out;
          }
        }else if(lt().comply(value,v).ok()){
          cons(Node(c,rec(l),v,r));
        }else if(lt().comply(v,value).ok()){
          cons(Node(c,l,v,rec(r)));
        }else{
          data;
        }
        default : data;            
      }
    }
    return RedBlackSet.make(set.with,rec(set.data));
  }
  static public function has<V>(set:RedBlackSet<V>,val):Bool{
    function hs(tree: RedBlackTree<V>, with: Comparable<V>): Bool {
      return switch (tree) {
        case Leaf: 
          false;
        case Node(color, left, v, right):
          if(with.eq().comply(val,v).ok()){
            true;
          }else if(with.lt().comply(val, v).ok()){
            hs(left, with);
          }else if (with.lt().comply(v, val).ok()){
            hs(right,with);
          }else{
            false;
          }
      }
    };
    return hs(set.data,set.with);
  }
  static public function fold<T,U>(self:RedBlackSet<T>,fn:T->U->U,z:U):U{
    var memo = z;
    for(next in self){
      memo = fn(next,memo);
    }
    return memo;
  }
  static public function toArray<T>(self:RedBlackSet<T>):Array<T>{
    var itr = self.iterator();
    var out = [];
    while(itr.hasNext()){
      out.push(itr.next());
    }
    return out;
  }
  static public function union<T>(self:RedBlackSet<T>,that:RedBlackSet<T>):RedBlackSet<T>{
    for(val in that){
      self = self.put(val);
    }
    return self;
  }
  static public function difference<T>(self:RedBlackSet<T>,that:RedBlackSet<T>):RedBlackSet<T>{
    for(val in that){
      trace(val);
      self = self.rem(val);
    }
    return self;
  }
  static public function symmetric_difference<T>(self:RedBlackSet<T>,that:RedBlackSet<T>):RedBlackSet<T>{
    var a = self.difference(that);
    var b = that.difference(self);
    return a.union(b);
  }
  static public function filter<T>(self:RedBlackSet<T>,fn:T->Bool):RedBlackSet<T>{
    var next = RedBlackSet.make(self.with);
    for(val in self){
      if(fn(val)){
        next = next.put(val);
      }
    }
    return next;
  }
  static public function equals<T>(self:RedBlackSet<T>,that:RedBlackSet<T>):Equaled{
    return union(self,that).fold(
      (next,memo:Equaled) -> memo && (has(self,next) ? AreEqual : NotEqual), 
      AreEqual
    );
  }
  static public function is_defined<T>(self:RedBlackSet<T>):Bool{
    return !(self.data == Leaf);
  }
}