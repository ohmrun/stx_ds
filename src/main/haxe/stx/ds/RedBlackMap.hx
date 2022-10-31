package stx.ds;

typedef RedBlackMapDef<K, V>  = { 
  final data: RedBlackTree<KV<K,V>>;
  final with: Comparable<K>;
}

@:using(stx.ds.RedBlackMap.RedBlackMapLift)
@:forward abstract RedBlackMap<K,V>(RedBlackMapDef<K,V>) from RedBlackMapDef<K,V> to RedBlackMapDef<K,V>{
  public static var _(default,never) = RedBlackMapLift;

  private function new(self:RedBlackMapDef<K, V>) this = self;
  
  static public function string<V>():RedBlackMap<String,V>{
    return make(
      Comparable.String()
    );
  }
  @:noUsing static public function lift<K,V>(self:RedBlackMapDef<K, V> ){
    return new RedBlackMap(self);
  }
  @:noUsing static public function make<K,V>(with:Comparable<K>,?data:RedBlackTree<KV<K,V>>):RedBlackMap<K,V>{
    return lift({
      with : with,
      data : data == null ? Leaf : data
    });
  }
  @:noUsing static public function makeI<K, V>(ord: Ord<K>,eq:Eq<K>): RedBlackMap<K, V> {
    return { data: Leaf, with: new stx.assert.comparable.term.Base(eq,ord) };
  }
  @:noUsing static public function make_with<K, V>(ord: Ord<K>,eq:Eq<K>): RedBlackMap<K, V> {
    return { data: Leaf, with: new stx.assert.comparable.term.Base(eq,ord) };
  }

  public function set(k:K,v:V):RedBlackMap<K,V>                 return _.set(self,k,v);
  public function put(kv:KV<K,V>):RedBlackMap<K,V>              return set(kv.key,kv.val);
  public function get(k:K):Option<V>                            return _.get(self,k);
  public function has(k:K):Bool                                 return _.get(self,k).is_defined();
  public function rem(k:K):RedBlackMap<K,V>                     return _.rem(self,k);
  public function iterator():Iterator<V>                        return Iter.make(RedBlackTree._.iterator(this.data)).map((kv) -> kv.val).iterator();
  public function keyValueIterator(): KeyValueIterator<K,V>     return Iter.make(RedBlackTree._.iterator(this.data)).map((kv) -> { key : kv.key, value : kv.val }).prj().iterator();
  public function union(that:RedBlackMap<K,V>):RedBlackMap<K,V> return _.union(self,that);

  @:to public function toIter():Iter<V>                         return new Iter({ iterator : iterator });

  private var self(get,never):RedBlackMap<K,V>;
  private function get_self():RedBlackMap<K,V> return this;

  public function copy(?with,?data){
    return make(
      __.option(with).defv(this.with),
      __.option(data).defv(this.data)
    );
  }
  public function toString(){
    return this.data.toString();
  }
}

class RedBlackMapLift{
  static public inline function set<K, V>(self:RedBlackMapDef<K,V>,key: K, val: V): RedBlackMap<K, V> {
    //trace("______________________________");
    //trace('$key $val');
    function ins(tree: RedBlackTree<KV<K,V>>, comparator: Assertion<K,AssertFailure>): RedBlackTree<KV<K,V>> {
      //trace(tree);
      final result = switch (tree) {
        case Node(color, left, { key : k, val : x }, right) if( self.with.eq().comply(k,key).is_equal() ): 
          //trace('match key $key');
          Node(color,left,{key : key, val : val},right);
        case Leaf: 
          //trace('at leaf');
          Node(Red, Leaf, { key: key, val: val }, Leaf);
        case Node(color, left, label, right):
            if (comparator.comply(key, label.key).is_ok())
                RedBlackTree._.balance(Node(color, ins(left, comparator), label, right))
            else if (comparator.comply(label.key, key).is_ok())
                RedBlackTree._.balance(Node(color, left, label, ins(right, comparator)))
            else
                tree;
      }
      //trace(result);
      return result;
    };

    return switch (ins(self.data, self.with.lt())) {
      case Leaf:
          throw "Never reach here";
      case Node(_, left, label, right):
          { data: Node(Black, left, label, right), with: self.with };
    }
  }
  static public inline function get<K, V>(self:RedBlackMapDef<K,V>,key: K): Option<V> {
    function mem(tree: RedBlackTree<KV<K,V>>): Null<V> {
      return switch (tree) {
        case Leaf: null;
        case Node(_, left, label, right):
            if (self.with.lt().comply(key, label.key).is_ok())
                mem(left);
            else if (self.with.lt().comply(label.key, key).is_ok())
                mem(right);
            else
                label.val;
      }
    }
    return __.option(mem(self.data));
  }
  static public inline function rem<K,V>(self:RedBlackMapDef<K,V>,value:K): RedBlackMap<K,V>{
    var balance = RedBlackTree._.balance;
    var eq      = self.with.eq();
    var lt      = self.with.lt();

    function cons(data):RedBlackTree<KV<K,V>>{
      return data;
    }
    function s(v:RedBlackTree<KV<K,V>>){
      return RedBlackTree._.toString(v);
    }
    function merge(l:RedBlackTree<KV<K,V>>,r:RedBlackTree<KV<K,V>>){
      //trace('${s(l)}\n${s(r)}');
      return switch([l,r]){
        case [Leaf,v] : v;
        case [v,Leaf] : v;
        case [Node(c0,l0,v0,r0),Node(c1,l1,v1,r1)] if (lt.comply(v0.key,v1.key).is_ok()):
          balance(Node(c1,merge(l,l1),v1,r1));
        case [Node(c0,l0,v0,r0),Node(c1,l1,v1,r1)] if (lt.comply(v1.key,v0.key).is_ok()):
          balance(Node(c0,merge(l0,r),v0,r0));
        default : Leaf;
      }
    }
    function rec(data:RedBlackTree<KV<K,V>>):RedBlackTree<KV<K,V>>{
      return switch (data) {
        case Leaf                 : cons(Leaf);
        case Node(c,l,v,r):
        if(eq.comply(value,v.key).is_ok()){
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
        }else if(lt.comply(value,v.key).is_ok()){
          cons(Node(c,rec(l),v,r));
        }else if(lt.comply(v.key,value).is_ok()){
          cons(Node(c,l,v,rec(r)));
        }else{
          data;
        }
        default : data;            
      }
    }
    return RedBlackMap.make(self.with,rec(self.data));
  }
  static public function union<K,V>(self:RedBlackMapDef<K,V>,that:RedBlackMap<K,V>):RedBlackMap<K,V>{
    for(key => val in that){
      self = set(self,key,val);
    }
    return self;
  }
  static public function last<K,V>(self:RedBlackMapDef<K,V>):Option<KV<K,V>>{
    function rec(self:RedBlackTree<KV<K,V>>,def:Option<KV<K,V>>){
      return switch(self){
        case Leaf                     : def;
        case Node(_,_, label, right)  : rec(right,Some(label));
      }
    }
    return rec(self.data,None);
  }
  static public function size<K,V>(self:RedBlackMapDef<K,V>){
    return self.data.size();
  }
  static public function unit<K,V>(self:RedBlackMapDef<K,V>){
    return RedBlackMap.make(self.with);
  }

}