package stx.ds.xset.head.data;

import stx.ds.xset.pack.Root      in RootA;
import stx.ds.xset.pack.Collection  in CollectionA;
import stx.ds.xset.pack.Branch  in BranchA;

enum Node<S,T>{
  Value(value:T);
  Scope(scope:BranchA<S,T>);
}