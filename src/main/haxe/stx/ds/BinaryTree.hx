package stx.ds;

enum BinaryTreeSum<T>{
  Empty;
  Split(v:T,l:BinaryTree<T>,r:BinaryTree<T>);
}

abstract BinaryTree<T>(BinaryTreeSum<T>) from BinaryTreeSum<T>{
  public function new(self){
    this = self;
  }
  public function value():Null<T>{
    return switch(this){
      case Empty        : null;
      case Split(v,_,_)  : v;
    }
  }
  public function head():BinaryTree<T>{
    return switch(this){
      case Split(null,l,_) : l;
      case Split(v,_,_)    : Split(v,Empty,Empty);
      case Empty          : Empty;
    }
  }
  public function tail():BinaryTree<T>{
    return switch(this){
      case Split(_,_,r) : r;
      case Empty       : Empty;
    }
  }
  public function df<Z>(fn:T->Z->Z,z:Z):Z{
    return BinaryTrees.df(this,fn,z);
  }
  public function isEnd():Bool{
    return switch(this){
      case Empty  : true;
      default     : false;
    }
  }
}
class BinaryTrees{
  static public function df<T,Z>(btree:BinaryTree<T>,fn:T->Z->Z,z:Z):Z{
    return switch(btree){
      case Empty        : z;
      case Split(v,l,r)  : 
        var a = fn(v,z);
        var b = df(l,fn,a);
        var c = df(r,fn,b);
        c;
    }
  }
  static public function hdf<T,Z>(btree:BinaryTree<T>,fn:T->Z->Either<Z,Z>,z:Z):Z{
    return switch(btree){
      case Empty  : z;
      case Split(v,l,r) : 
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