package stx.ds.head.data;

import stx.ds.pack.RBTree in RBTreeA;

typedef Map<K, V> = { data: RBTreeA<KV<K,V>>, with: Comparable<K> };