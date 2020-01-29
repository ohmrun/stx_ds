package stx.ds;

#if (test=="stx_ds")
  import stx.ds.test.*;
#end

class Package{
  #if (test=="stx_ds")
    static public function tests():Array<utest.Test>{
      return [
        new SetTest()
      ];
    }
  #end
}

typedef Array<T>      = stx.ds.pack.Array<T>; 
typedef Set<T>        = stx.ds.pack.Set<T>;

typedef List<T>       = stx.ds.pack.List<T>;

typedef BTree<T>      = stx.ds.pack.BTree<T>;
typedef LBTree<T>     = stx.ds.pack.LBTree<T>;

typedef Nel<T>        = stx.ds.pack.Nel<T>;
typedef KTree<T>      = stx.ds.pack.KTree<T>;  
typedef Map<K,V>      = stx.ds.pack.Map<K,V>;

typedef Maps          = stx.ds.head.Maps;