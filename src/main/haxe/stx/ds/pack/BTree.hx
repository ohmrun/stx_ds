package stx.ds.pack;

using tink.CoreApi;
using stx.fn.Package;

enum BTreeNode<T>{
  Empty;
  Leaf(v:T,l:BTreeNode<T>,r:BTreeNode<T>);
}
abstract BTree<T>(BTreeNode<T>) from BTreeNode<T>{
  public function new(self){
    this = self;
  }
  public function value():Null<T>{
    return switch(this){
      case Empty        : null;
      case Leaf(v,_,_)  : v;
    }
  }
  public function head():BTree<T>{
    return switch(this){
      case Leaf(null,l,_) : l;
      case Leaf(v,_,_)    : Leaf(v,Empty,Empty);
      case Empty          : Empty;
    }
  }
  public function tail():BTree<T>{
    return switch(this){
      case Leaf(_,_,r) : r;
      case Empty       : Empty;
    }
  }
  public function df<Z>(fn:T->Z->Z,z:Z):Z{
    return BTrees.df(this,fn,z);
  }
  public function isEnd():Bool{
    return switch(this){
      case Empty  : true;
      default     : false;
    }
  }
}
class BTrees{
  static public function df<T,Z>(btree:BTree<T>,fn:T->Z->Z,z:Z):Z{
    return switch(btree){
      case Empty        : z;
      case Leaf(v,l,r)  : 
        var a = fn(v,z);
        var b = df(l,fn,a);
        var c = df(r,fn,b);
        c;
    }
  }
  static public function hdf<T,Z>(btree:BTree<T>,fn:T->Z->Either<Z,Z>,z:Z):Z{
    return switch(btree){
      case Empty  : z;
      case Leaf(v,l,r) : 
        var o = fn(v,z);
        switch(o){
          case Right(o)    : o;
          case Left(o)   : 
            var b = hdf(l,fn,o);
            var c = hdf(r,fn,b);
            c;
        }
    }
  }
}
