package stx.ds.pack;

using stx.core.Lift;
using stx.assert.Lift;

import haxe.ds.Option;
import stx.ds.head.data.Nel in NelT;

import stx.ds.pack.Nel;
import stx.ds.pack.BTree;
import stx.ds.head.data.BTree in BTreeT;

abstract RoseTree<T>(BTreeT<T>) from BTreeT<T> to BTreeT<T>{
  public function new(?self){
    this = __.exists().ordef(self,Empty); 
  }
}

class RoseTrees{
  static public function siblings<T>(t:RoseTree<T>):Array<RoseTree<T>>{
    function rec(t:RoseTree<T>,arr:Array<RoseTree<T>>){
      return switch (t) {
        case Empty          : [];
        case Split(v,l,r)   : rec(l,arr.concat([l]));
      }
    }
    return rec(t,[]);
  }
  static public function children<T>(t:RoseTree<T>):Array<RoseTree<T>>{
    function rec(t,arr:Array<RoseTree<T>>){
      return switch(t){
        case Empty        : [];
        case Split(_,_,r)  : rec(r,arr.concat([r]));
      }
    }
    return rec(t,[]);
  }
}
class RoseTreeZips{
  static public function down<T>(zip:RoseTreeZip<T>):RoseTreeZip<T>{
    function rec(zip:RoseTreeZip<T>){
      return switch(zip){
        case InitNel(tuple2(_,Split(_,_,r)))       : zip.cons(tuple2(Down,r));
      //  case ConsNel(_,tuple2(_,Split(_,_,r)))   : zip.cons(tuple2(Down,r));          : 
        default                                 : zip;
      }
    }
    return rec(zip);
  }
  static public function up<T>(zip:RoseTreeZip<T>){
    function rec(zip:RoseTreeZip<T>){
      return switch(zip){
        case InitNel(v)                   : zip;
        case ConsNel(tuple2(Down,_),nxt)  : nxt;
        case ConsNel(tuple2(_,_),nxt)     : rec(nxt);
      }
    }
    return rec(zip);
  }
  static public function next<T>(zip:RoseTreeZip<T>){
    return switch(zip){
      case InitNel(tuple2(_,Split(_,l,_)))     : zip.cons(tuple2(Next,l));
      case ConsNel(tuple2(_,Split(_,l,_)),_)   : zip.cons(tuple2(Next,l));
      default                                 : zip;
    }
  }
  static public function prev<T>(zip:RoseTreeZip<T>){
    function rec(zip:RoseTreeZip<T>){
      return switch(zip){
        case InitNel(v)                   : zip;
        case ConsNel(tuple2(Down,_),nxt)  : zip;
        case ConsNel(tuple2(_,_),nxt)     : rec(nxt);
      }
    }
    return rec(zip);
  }
}
@:forward abstract RoseTreeZip<T>(RoseTreeZipT<T>) from RoseTreeZipT<T>{
  public function new(self){
    this = self;
  }
}
abstract RoseTreeZipCommand<T>(RoseTreeZipCommandT<T>) from RoseTreeZipCommandT<T>{
  public function new(self){
    this = self;
  }
  public function isView(){
    return switch(this){
      case View(_) : true;
      default : false;
    }
  }
  public function view():Option<RoseTreeZipNav>{
    return switch(this){
      case View(v) : Some(v);
      default : None; 
    }
  }
}
enum RoseTreeZipCommandT<T>{
  View(nav:RoseTreeZipNav);
  Edit(val:RoseTreeZipNavEdit<T>);
}
enum RoseTreeZipNav{
  Root;
  Down;
  Next;
}
enum RoseTreeZipNavEdit<T>{
  Change(v:T);
  Delete;
  Append(v:T);
  Rebase(next:RoseTree<T>);
}
typedef RoseTreeZipT<T> = stx.ds.pack.Nel<Tuple2<RoseTreeZipNav,RoseTree<T>>>;