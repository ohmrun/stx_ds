package stx.ds.head.data;

import stx.ds.pack.List in ListA;

enum List<T>{
  Nil;
  Cons(head:T,tail:ListA<T>);
}