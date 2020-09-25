package stx.ds;

typedef RedBlackMapDef<K, V>  = { data: RedBlackTree<KV<K,V>>, with: Comparable<K> };

@:forward abstract RedBlackMap<K,V>(RedBlackMapDef<K,V>) from RedBlackMapDef<K,V>{
  public static var _(default,never) = RedBlackMapLift;

  private function new(self) this = self;
  
  static public function string<V>():RedBlackMap<String,V>{
    return make(
      Comparable.String()
    );
  }
  static public function make<K,V>(with:Comparable<K>,?data:RedBlackTree<KV<K,V>>):RedBlackMap<K,V>{
    return {
      with : with,
      data : data == null ? Leaf : data
    };
  }
  public static function make_with<K, V>(ord: Ord<K>,eq:Eq<K>): RedBlackMap<K, V> {
    return { data: Leaf, with: new stx.assert.comparable.term.Base(eq,ord) };
  }

  public function set(k:K,v:V):RedBlackMap<K,V>                 return _.set(self,k,v);
  public function put(kv:KV<K,V>):RedBlackMap<K,V>              return set(kv.key,kv.val);
  public function get(k:K):Option<V>                            return __.option(_.get(self,k));
  public function has(k:K):Bool                                 return __.option(_.get(self,k)).is_defined();
  public function rem(k:K):RedBlackMap<K,V>                     return _.rem(self,k);
  public function iterator():Iterator<KV<K,V>>                  return RedBlackTree._.iterator(this.data);
  public function keyValIterator()                              return RedBlackTree._.iterator(this.data);
  public function union(that:RedBlackMap<K,V>):RedBlackMap<K,V> return _.union(self,that);

  @:to public function toIter():Iter<KV<K,V>>                   return new Iter({ iterator : iterator });

  private var self(get,never):RedBlackMap<K,V>;
  private function get_self():RedBlackMap<K,V> return this;
}

class RedBlackMapLift{
  static public inline function set<K, V>(self:RedBlackMap<K,V>,key: K, val: V): RedBlackMap<K, V> {
    function ins(tree: RedBlackTree<KV<K,V>>, comparator: Assertion<K,AssertFailure>): RedBlackTree<KV<K,V>> {
      return switch (tree) {
        case Leaf: Node(Red, Leaf, { key: key, val: val }, Leaf);
        case Node(color, left, label, right):
            if (comparator.ok(key, label.key))
                RedBlackTree._.balance(Node(color, ins(left, comparator), label, right))
            else if (comparator.ok(label.key, key))
                RedBlackTree._.balance(Node(color, left, label, ins(right, comparator)))
            else
                tree;
      }
    };

    return switch (ins(self.data, self.with.lt())) {
      case Leaf:
          throw "Never reach here";
      case Node(_, left, label, right):
          { data: Node(Black, left, label, right), with: self.with };
    }
  }
  static public inline function get<K, V>(self:RedBlackMap<K,V>,key: K): Null<V> {
    function mem(tree: RedBlackTree<KV<K,V>>): Null<V> {
      return switch (tree) {
        case Leaf: null;
        case Node(_, left, label, right):
            if (self.with.lt().applyII(key, label.key).ok())
                mem(left);
            else if (self.with.lt().applyII(label.key, key).ok())
                mem(right);
            else
                label.val;
      }
    }
    return mem(self.data);
  }
  static public inline function rem<K,V>(self:RedBlackMap<K,V>,value:K): RedBlackMap<K,V>{
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
        case [Node(c0,l0,v0,r0),Node(c1,l1,v1,r1)] if (lt.applyII(v0.key,v1.key).ok()):
          balance(Node(c1,merge(l,l1),v1,r1));
        case [Node(c0,l0,v0,r0),Node(c1,l1,v1,r1)] if (lt.applyII(v1.key,v0.key).ok()):
          balance(Node(c0,merge(l0,r),v0,r0));
        default : Leaf;
      }
    }
    function rec(data:RedBlackTree<KV<K,V>>):RedBlackTree<KV<K,V>>{
      return switch (data) {
        case Leaf                 : cons(Leaf);
        case Node(c,l,v,r):
        if(eq.applyII(value,v.key).ok()){
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
        }else if(lt.applyII(value,v.key).ok()){
          cons(Node(c,rec(l),v,r));
        }else if(lt.applyII(v.key,value).ok()){
          cons(Node(c,l,v,rec(r)));
        }else{
          data;
        }
        default : data;            
      }
    }
    return RedBlackMap.make(self.with,rec(self.data));
  }
  static public function union<K,V>(self:RedBlackMap<K,V>,that:RedBlackMap<K,V>):RedBlackMap<K,V>{
    for(item in that){
      self = set(self,item.key,item.val);
    }
    return self;
  }
}