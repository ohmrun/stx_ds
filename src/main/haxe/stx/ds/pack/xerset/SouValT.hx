package stx.ds.pack.xerset;

enum SouValT<K,V>{
  SouSet(key:K,val:XerSet<K,V>);
  SouSan(key:K,val:V);
}