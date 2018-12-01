package stx.ds.pack;

@:using(stx.ds.body.Maps)
typedef MapT<K, V> = { tree: TreeT<{ key: K, value: V }>, comparator: Eq<K> };