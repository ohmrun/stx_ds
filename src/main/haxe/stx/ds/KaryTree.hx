package stx.ds;

import stx.ds.kary_tree.*;

@:using(stx.ds.KaryTree.KaryTreeLift)
enum KaryTreeSum<T>{
  Nought;
  Branch(x:T,xs:LinkedList<KaryTree<T>>);
}

/**
 * Immutable Kary Tree. use .zipper to navigate and edit stepwise.
 */
@:using(stx.ds.KaryTree.KaryTreeLift)
abstract KaryTree<T>(KaryTreeSum<T>) from KaryTreeSum<T> to KaryTreeSum<T>{
  static public var _(default,never) = KaryTreeLift;
  static inline public var ZERO:KaryTree<Dynamic> = Nought;
  @:noUsing inline static public function unit<A>():KaryTree<A>    return Nought;
  @:noUsing inline static public function pure<T>(v:T):KaryTree<T> return Branch(v,Nil);
  
  public function new(?self:KaryTreeSum<T>){
    this = __.that().exists().ordef(self,Nought);
  }
  public function df(){
    return KaryTreeLift.iterDF(this);
  }
  public function bf(){
    return KaryTreeLift.iterBF(this);
  }
  public function zipper():KaryTreeZip<T>{
    return new KaryTreeZipper(Cons(this,Nil));
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
  public function children():LinkedList<KaryTree<T>>{
    return switch(this){
      case Branch(_,ls) : ls == null ? Nil : ls;
      default : Nil;
    }
  }
  public function equals(that:KaryTree<T>):Bool{
    return equals_with(that,function(l,r) return l == r);
  }
  public function equals_with(that:KaryTree<T>,fn:T->T->Bool):Bool{
    function handler(ls0:Null<LinkedList<KaryTree<T>>>,ls1:Null<LinkedList<KaryTree<T>>>):Bool{
      return switch([ls0,ls1]){
        case [Cons(x,xs),Cons(y,ys)] :
          var l : KaryTree<T> = x;
          var r : KaryTree<T> = y;
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
}

class KaryTreeLift{
  static public function search_child<T>(self:KaryTree<T>,fn:T->Bool):Option<KaryTree<T>>{
    return switch(self){
      case Branch(x,xs) : __.option(xs).def(LinkedList.unit).search(
        (tree:KaryTree<T>) -> __.option(tree).map(_ -> _.value()).map(fn).defv(false)
      );
      default : None;
    }
  }
  static public function toString<T>(self:KaryTreeSum<T>):String{
    function rec(v:Null<KaryTree<T>>,int):String{
      return switch(v){
        case Nought          : "";
        case Branch(v,rst)  : 
          var arr = __.that().exists().ordef(rst,Nil); 
          var out = arr.map((next) -> return rec(next,'$int '));
          var val = out.fold(
            (next,memo) -> '$memo\n$int$next'
            ,""
          );
          '$v:\n$val';
        case null           : "";
      }
    }
    var out = rec(self,"  ");
    return '\n$out';
  }
  static function next<T>(t:LinkedList<KaryTree<T>>,concat:LinkedList<KaryTree<T>> -> LinkedList<KaryTree<T>> -> LinkedList<KaryTree<T>>):LazyStream<T>{
    return switch t {
      case Cons(Branch(x,xs),rst):
        if(xs == null){ xs = Nil; }
        LazyStream.make(
          next.bind(
            concat(xs,rst),
            concat
          )
        ,Some(x));
      default:
        LazyStream.unit();
      }
  }
  static function df_concat<T>(l:LinkedList<KaryTree<T>>,r:LinkedList<KaryTree<T>>):LinkedList<KaryTree<T>>{
    return l.concat(r);
  }
  static function bf_concat<T>(l:LinkedList<KaryTree<T>>,r:LinkedList<KaryTree<T>>):LinkedList<KaryTree<T>>{
    return r.concat(l);
  }
  static public function genDF<T>(node:KaryTree<T>){
    var vals : LinkedList<KaryTree<T>> = Cons(node,Nil);
    return next.bind(vals,df_concat);
  }
  /**
    Creates a depth first iterable from a KaryTree.
  */
  static public function iterDF<T>(node:KaryTree<T>): Iterable<T> return iter(genDF(node));
  static public function genBF<T>(node:KaryTree<T>){
    var vals : LinkedList<KaryTree<T>> = Cons(node,Nil);
    return next.bind(vals,bf_concat);
  }
  /**
    Creates a breadth first iterable from a KaryTree.
  */
  static public function iterBF<T>(node:KaryTree<T>):Iterable<T> return iter(genBF(node));
  static public function iter<T>(generator:LazyStreamTrigger<T>):Iterable<T>{
    return {
      iterator : function(){
        var cursor = generator.next().reply();
        return {
          next : function(){
            var out = switch(cursor.fst()){
              case Some(v)  : v;
              default       : null;
            }
            cursor = cursor.snd().next().reply();
            return out;
          },
          hasNext : function(){
            return __.option(cursor.fst()).map(ok -> ok.is_defined()).defv(false);
          }
        }
      }
    };
  }
}