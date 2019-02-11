package stx.ds.body;

import stx.ds.head.data.KTree in KTreeT;

class KTrees{

  static function nothing<T>():Tuple2<Option<T>,LStream<T>>{
    return tuple2(None,nothing);
  }
  static function next<T>(t:List<KTree<T>>,concat:List<KTree<T>> -> List<KTree<T>> -> List<KTree<T>>):Tuple2<Option<T>,LStream<T>>{
    return switch t {
      case Cons(Branch(x,xs),rst):
        if(xs == null){ xs = Nil; }
        tuple2(Some(x),
          next.bind(
            concat(xs,rst),
            concat
          )
        );
      default:
        nothing();
      }
  }
  static function df_concat<T>(l:List<KTree<T>>,r:List<KTree<T>>):List<KTree<T>>{
    return l.concat(r);
  }
  static function bf_concat<T>(l:List<KTree<T>>,r:List<KTree<T>>):List<KTree<T>>{
    return r.concat(l);
  }
  static public function genDF<T>(node:KTree<T>){
    var vals : List<KTree<T>> = Cons(node,Nil);
    return next.bind(vals,df_concat);
  }
  /**
    Creates a depth first iterable from a KTree.
  */
  static public function iterDF<T>(node:KTree<T>): Iterable<T> return iter(genDF(node));
  static public function genBF<T>(node:KTree<T>){
    var vals : List<KTree<T>> = Cons(node,Nil);
    return next.bind(vals,bf_concat);
  }
  /**
    Creates a breadth first iterable from a KTree.
  */
  static public function iterBF<T>(node:KTree<T>):Iterable<T> return iter(genBF(node));
  static public function iter<T>(generator:LStream<T>):Iterable<T>{
    return {
      iterator : function(){
        var cursor = generator();
        return {
          next : function(){
            var out = switch(cursor.fst()){
              case Some(v)  : v;
              default       : null;
            }
            cursor = cursor.snd()();
            return out;
          },
          hasNext : function(){
            return cursor.fst().exists();
          }
        }
      }
    };
  }
}