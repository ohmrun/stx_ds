package stx.ds.pack;

import haxe.ds.Either;

import stx.ds.pack.xerset.*;

@:forward abstract XerSet<K,V>(XerSetT<K,V>) from XerSetT<K,V> to XerSetT<K,V> {
  static public function makeKV<K,V>(key:Comparable<K>,val:Comparable<V>,?data:RBTree<SouVal<K,V>>){
    var with = new XerSetWith(
      {
        K : key,
        V : val
      }
    );
    return XerSet.create(with,Set.make(with.prj(),data));
  }
  static public function make<K,V>(with:With<K,V>,?data:RBTree<SouVal<K,V>>){
    var with = new XerSetWith(with);
    return new XerSet({ with : with , data : Set.make(with.prj(),data) });
  }
  static public function create<K,V>(with:XerSetWith<K,V>,data:Set<SouVal<K,V>>){
    return new XerSet({ with : with, data : data});
  }
  private function new(self){
    this = self;
  }
  public function ltx(that:XerSet<K,V>,with:Comparable<SouVal<K,V>>):Ordered{
    var current = this.data.with;
    var self    = uses(with);
    return self.lt(that);
  }
  function next(data):XerSet<K,V>{
    return create(this.with,data);
  }
  public function uses(with:Comparable<SouVal<K,V>>):XerSet<K,V>{
    return next(this.data.uses(with));
  }
  public function whilst(with:Comparable<SouVal<K,V>>,fn:XerSet<K,V>->XerSet<K,V>):XerSet<K,V>{
    var current = this.data.with;
    var next    = uses(with);
    var last    = fn(next).uses(current);
    return last;
  }
  public function lt(that:XerSet<K,V>):Ordered{
    return this.data.lt(that.data);
  }
  public function eq(that:XerSet<K,V>):Equaled{
    return this.data.eq(that.data);
  }
  public function eqx(that:XerSet<K,V>,with:Comparable<SouVal<K,V>>):Equaled{
    var current = this.with;
    var self    = uses(with);
    return self.eq(that);
  }
  public function put(v:SouVal<K,V>){
    return next(this.data.put(v));
  }
  public function set(k:K,v:Either<XerSet<K,V>,V>):XerSet<K,V>{
    return switch(v){
      case Left(v)  : put(SouSet(k,v));
      case Right(v) : put(SouSan(k,v));
    }
  }
  public function setVal(k:K,v:V){
    return set(k,Right(v));
  }
  public function setSet(k:K,v:XerSet<K,V>){
    return set(k,Left(v));
  }
  public function keyspace():XerSet<K,V>{
    return uses(this.with.keyspace().prj());
  }
  public function valspace():XerSet<K,V>{
    return uses(this.with.valspace().prj());
  }
  public function setspace():XerSet<K,V>{
    return uses(this.with.setspace().prj());
  }
  public function has(v){
    return this.data.has(v);
  }
  public function hasKey(k:K){
    return keyspace().has(
      SouSan(k,null)
    );
  }
  public function hasNode(v:XerSet<K,V>){
    return valspace().has(
      SouSet(null,v)
    );
  }
  public function hasLeaf(v:V){
    return valspace().has(
      SouSan(null,v)
    );
  }
  public function filter(fn){
    return next(this.data.filter(fn));
  }
  public function restrict(itr:Array<K>){
    return filter(
      (item) -> keyspace().has(item)
    );
  }
  public function union(that:XerSet<K,V>){
    return next(this.data.union(that.data));
  }
  public function difference(that:XerSet<K,V>){
    return next(this.data.difference(that.data));
  }
  public function toString(){
    return this.data.toString();
  }
}