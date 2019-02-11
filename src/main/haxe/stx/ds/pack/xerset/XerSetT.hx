package stx.ds.pack.xerset;

typedef XerSetT<K,V> = {
  with : XerSetWith<K,V>,
  data : Set<SouVal<K,V>>,
}