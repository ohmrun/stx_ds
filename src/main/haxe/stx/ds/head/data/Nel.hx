package stx.ds.head.data;

import stx.ds.pack.Nel in NelA;

enum Nel<A>{
  InitNel(x: A);
  ConsNel(x: A, xs: NelA<A>);
}