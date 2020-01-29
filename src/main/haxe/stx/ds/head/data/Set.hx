package stx.ds.head.data;

import stx.assert.pack.Comparable;

typedef Set<T> = { data : RBTree<T>, with : Comparable<T> }; 