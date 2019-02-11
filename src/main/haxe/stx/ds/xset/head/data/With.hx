package stx.ds.xset.head.data;

import stx.assert.pack.Comparable;

typedef With<S,T> = {
  var S :  Comparable<S>;
  var T :  Comparable<T>;
} 