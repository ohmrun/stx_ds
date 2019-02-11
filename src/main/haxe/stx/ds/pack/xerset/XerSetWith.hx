package stx.ds.pack.xerset;

class XerSetWith<K,V>{
  var state   : XerSetWithState;  
  var with    : With<K,V>;

  public function new(with,?state){
    this.state  = state == null ? CKeyVal : state;
    this.with   = with;
  }
  public function as(state:XerSetWithState){
    return new XerSetWith(this.with,state);
  }
  public function eq(l:SouVal<K,V>,r:SouVal<K,V>):Equaled{
    return switch(state){
      case CKey     : key(with.K).eq(l,r);
      case CVal     : val(with.V).eq(l,r);
      case CKeyVal  : kv(with).eq(l,r);
    }
  }
  public function lt(l:SouVal<K,V>,r:SouVal<K,V>):Ordered{
    return switch(state){
      case CKey     : key(with.K).lt(l,r);
      case CVal     : val(with.V).lt(l,r);
      case CKeyVal  : kv(with).lt(l,r);
    }
  }
  public function prj():Comparable<SouVal<K,V>>{
    return {
      eq : eq,
      lt : lt
    }
  }
  public function keyspace(){
    return as(CKey);
  }
  public function valspace(){
    return as(CVal);
  }
  public function setspace(){
    return as(CKeyVal);
  }
  static public function key<K,V>(c:Comparable<K>):Comparable<SouVal<K,V>>{
    return {
      eq : function(l:SouVal<K,V>,r:SouVal<K,V>) {
        return switch([l,r]){
          case [SouSet(k,_),SouSet(k0,_)] :
            c.eq(k,k0);
          case [SouSan(k,_),SouSan(k0,_)] :
            c.eq(k,k0);
          case [SouSan(k,_),SouSet(k0,_)] : 
            c.eq(k,k0);
          case [SouSet(k,_),SouSan(k0,_)] :
            c.eq(k,k0);
          default : false;
        }
      },
      lt : function(l,r) {
        return switch([l,r]){
          case [SouSan(k,v),SouSan(k0,v0)]  : 
            c.lt(k,k0);
          case [SouSet(k,v),SouSet(k0,v0)]  : 
            c.lt(k,k0);
          case [SouSan(k,_),SouSet(k0,_)]        : 
            c.lt(k,k0);
          case [SouSet(k,_),SouSan(k0,_)]        : 
            c.lt(k,k0);
        }
      }
    }
  }
  static public function val<K,V>(c:Comparable<V>):Comparable<SouVal<K,V>>{
    return {
      eq : function(l:SouVal<K,V>,r:SouVal<K,V>) {
        return switch([l,r]){
          case [SouSet(k,v),SouSet(k0,v0)] :
            v.eqx(v0,val(c));
          case [SouSan(k,v),SouSan(k0,v0)] :
            c.eq(v,v0);
          default : false;
        }
      },
      lt : function(l,r) {
        return switch([l,r]){
          case [SouSan(k,v),SouSan(k0,v0)]  : 
            c.lt(v,v0);
          case [SouSet(k,v),SouSet(k0,v0)]  : 
            v.ltx(v0,val(c));
          case [SouSan(_),SouSet(_)]        : 
            LessThan;
          case [SouSet(_),SouSan(_)]        : 
            NotLessThan;
        }
      }
    }
  }
  static public function kv<K,V>(with:With<K,V>):Comparable<SouVal<K,V>>{
    return {
      eq : function(l:SouVal<K,V>,r:SouVal<K,V>) {
        return switch([l,r]){
          case [SouSet(k,v),SouSet(k0,v0)] :
            with.K.eq(k,k0) && v.eqx(v0,kv(with));
          case [SouSan(k,v),SouSan(k0,v0)] :
            with.K.eq(k,k0) && with.V.eq(v,v0);
          default : false;
        }
      },
      lt : function(l,r) {
        return switch([l,r]){
          case [SouSan(k,v),SouSan(k0,v0)]  : 
            with.K.lt(k,k0) || with.V.lt(v,v0);
          case [SouSet(k,v),SouSet(k0,v0)]  : 
            with.K.lt(k,k0) || v.ltx(v0,kv(with));
          case [SouSan(_),SouSet(_)]        : 
            LessThan;
          case [SouSet(_),SouSan(_)]        : 
            NotLessThan;
        }
      }
    }
  }
}
