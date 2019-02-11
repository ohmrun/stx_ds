package stx.ds.head.data;

import stx.ds.pack.KTree in KTreeA;
import stx.ds.pack.List in ListA;

enum KTree<T>{
 Empty;
 Branch(x:T,?xs:ListA<KTreeA<T>>);
}