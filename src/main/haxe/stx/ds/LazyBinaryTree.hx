package stx.ds;

enum LazyBinaryTreeSum<T>{
  LazyEmpty;
  LazySplit(v:T,l:Thunk<LazyBinaryTreeSum<T>>,r:Thunk<LazyBinaryTreeSum<T>>);
}

abstract LazyBinaryTree<T>(LazyBinaryTreeSum<T>) from LazyBinaryTreeSum<T>{
  public function new(self){
    this = self;
  }
  public function value():Null<T>{
    return switch(this){
      case LazyEmpty          : null;
      case LazySplit(v,_,_)   : v;
    }
  }
  public function head():LazyBinaryTree<T>{
    return switch(this){
      case LazySplit(null,l,_)  : l();
      case LazySplit(v,_,_)     : LazySplit(v,() -> LazyEmpty,() -> LazyEmpty);
      case LazyEmpty            : LazyEmpty;
    }
  }
  public function tail():LazyBinaryTree<T>{
    return switch(this){
      case LazySplit(_,_,r) : r();
      case LazyEmpty       : LazyEmpty;
    }
  }
  public function df<Z>(fn:T->Z->Z,z:Z):Z{
    return LazyBinaryTrees.df(this,fn,z);
  }
  public function isEnd():Bool{
    return switch(this){
      case LazyEmpty  : true;
      default     : false;
    }
  }
}
class LazyBinaryTrees{
  static public function df<T,Z>(btree:LazyBinaryTree<T>,fn:T->Z->Z,z:Z):Z{
    return switch(btree){
      case LazyEmpty        : z;
      case LazySplit(v,l,r)  : 
        var a = fn(v,z);
        var b = df(l(),fn,a);
        var c = df(r(),fn,b);
        c;
    }
  }
  static public function hdf<T,Z>(btree:LazyBinaryTree<T>,fn:T->Z->Either<Z,Z>,z:Z):Z{
    return switch(btree){
      case LazyEmpty  : z;
      case LazySplit(v,l,r) : 
        var o = fn(v,z);
        switch(o){
          case Right(o)    : o;
          case Left(o)   : 
            var b = hdf(l(),fn,o);
            var c = hdf(r(),fn,b);
            c;
        }
    }
  }
}
