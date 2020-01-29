package stx.ds.pack;

import stx.assert.head.data.Equaled in EqualedT;
import stx.assert.head.data.Ordered in OrderedT;
import stx.ds.body.RBTrees;
import stx.ds.body.Sets;
import stx.ds.head.data.Set in SetT;
import stx.ds.head.data.RBTree;

@:forward abstract Set<T>(SetT<T>) from SetT<T>{
  private function new(self){
    this = self;
  }
  static public function make<T>(with:Comparable<T>,?data:RBTree<T>):Set<T>{
    return new Set({
      with : with,
      data : data == null ? Leaf : data
    });
  }
  static public function create<T>(ord:Ord<T>,eq:Eq<T>,?data:RBTree<T>):Set<T>{
    var with : Comparable<T> = new stx.assert.body.comparable.term.BaseComparable(eq,ord);
    return make(with,data);
  }
  public function put(v:T):Set<T>{
    return Sets.put(this,v);
  }
  public function toString(){
    return Sets.toString(this);
  }
  public function balance():Set<T>{
    return Sets.balance(this);
  }
  public function rem(v:T):Set<T>{
    return Sets.rem(this,v);
  }
  public function fold<U>(fn:T->U->U,z:U):U{
    var memo = z;
    for(next in new Set(this)){
      memo = fn(next,memo);
    }
    return memo;
  }
  public function iterator():Iterator<T>{
    return RBTrees.iterator(this.data);
  }
  public function toArray():Array<T>{
    var itr = iterator();
    var out = [];
    while(itr.hasNext()){
      out.push(itr.next());
    }
    return out;
  }
  public function union(that:Set<T>):Set<T>{
    var self = new Set(this);
    for(val in that){
      self = put(val);
    }
    return self;
  }
  public function filter(fn:T->Bool):Set<T>{
    var next = Set.make(this.with);
    for(val in new Set(this)){
      if(fn(val)){
        next = next.put(val);
      }
    }
    return next;
  }
  @:to public function toIterable():Iterable<T>{
    return {
      iterator : iterator
    };
  }
  public function difference(that:Set<T>):Set<T>{
    return filter((v) -> !(that.uses(this.with).has(v)));
  }
  public function has(v:T):Bool{
    return Sets.has(this,v);
  }
  public function eq(that:Set<T>):Equaled{
    return union(that).fold(
      (next,memo:Equaled) -> memo && (has(next) ? AreEqual : NotEqual), 
      AreEqual
    );
  }
  public function uses(with:Comparable<T>):Set<T>{
    return { data : this.data, with : with };
  }
  public function lt(that:Set<T>):Ordered{
    return that.difference(this).fold((next,memo)-> memo++,0) > 0 ? LessThan : NotLessThan;    
  }
}