package stx.ds.head.data;

import stx.ds.pack.BTree in BTreeA;

enum BTree<T>{
  Empty;
  Split(v:T,l:BTreeA<T>,r:BTreeA<T>);
} 