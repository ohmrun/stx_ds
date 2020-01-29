package stx.ds.pack;

import stx.ds.pack.ktree.Zipper;

import tink.core.Noise;

import stx.ds.body.KTrees;

import stx.ds.head.data.KTree in KTreeT;

using Lambda;

/**
  Untagged immutable Kary Tree. use .zipper to navigate and edit stepwise.
*/
abstract KTree<T>(KTreeT<T>) from KTreeT<T>{
  @:noUsing inline static public function empty<A>() : KTree<A>{
    return Nought;
  }
  @:noUsing inline static public function pure<T>(v:T): KTree<T>{
    return Branch(v,Nil);
  }
  public function new(?self:KTreeT<T>){
    this = __.fault().exists().ordef(self,Nought);
  }
  public function df(){
    return KTrees.iterDF(this);
  }
  public function bf(){
    return KTrees.iterBF(this);
  }
  public function zipper():Zipper<T>{
    return new Zipper(Cons(this,Nil));
  }
  /**
    Returns the value of the node, and null otherwise
  */
  public function value(){
    return switch(this){
      case Branch(x,_) : x;
      default: null;
    }
  }
  /**
    Return list of children, or empty list
  */
  public function children():List<KTree<T>>{
    return switch(this){
      case Branch(_,ls) : ls == null ? Nil : ls;
      default : Nil;
    }
  }
  public function equals(that:KTree<T>):Bool{
    return equalsWith(that,function(l,r) return l == r);
  }
  public function equalsWith(that:KTree<T>,fn:T->T->Bool):Bool{
    function handler(ls0:Null<List<KTree<T>>>,ls1:Null<List<KTree<T>>>):Bool{
      return switch([ls0,ls1]){
        case [Cons(x,xs),Cons(y,ys)] :
          var l : KTree<T> = x;
          var r : KTree<T> = y;
          l.equals(r) && handler(xs,ys);
        case [Nil,Nil] : true;
        case [null,null] : true;
        default : false;
      }
    }
    return switch([this,that]){
      case [Branch(l,ls),Branch(r,rs)] :
        var o : Bool = fn(l,r);
        if(!o){
          o;
        }else{
          handler(ls,rs);
        }
      case [Nought,Nought] : true;
      default : false;
    }
  }
  public function toString():String{
    function rec(v:KTree<T>,int):String{
      return switch(v){
        case Nought          : "";
        case Branch(v,rst)  : 
          var arr = __.fault().exists().ordef(rst,Nil); 
          var out = arr.map((next) -> return rec(next,'$int '));
          var val = out.fold(
            (next,memo) -> '$memo\n$int$next'
            ,""
          );
          '$v:\n$val';
      }
    }
    var out = rec(this,"  ");
    return '\n$out';
  }
}

