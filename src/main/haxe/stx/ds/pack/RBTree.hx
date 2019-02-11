package stx.ds.pack;

import stx.ds.head.data.RBTree in RBTreeT;

@:forward abstract RBTree<T>(RBTreeT<T>) from RBTreeT<T> to RBTreeT<T>{
  public function new(self){
    this = self;
  }
}