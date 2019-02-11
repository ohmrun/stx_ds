package stx.ds.head.data;

import stx.core.pack.Option;
import tink.core.Noise;
import stx.ds.pack.LStream in LStreamA;

typedef LStream<O> = Void -> Tuple2<Option<O>,LStreamA<O>>;