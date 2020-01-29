package stx.ds.pack.ktree;

import stx.ds.head.data.KTree in KTreeT;
import stx.ds.pack.KTree;
import stx.ds.head.data.List in ListT;

/**
  Holds a path from the root to allow Tree navigation and
  immutable editing.
  of the form [root,[down,down],current]
*/
@:forward abstract Zipper<T>(List<KTree<T>>) from List<KTree<T>>{
  public function new(self){
    this = self;
  }
  @:from static public function fromKTree<T>(v:KTree<T>):Zipper<T>{
    return new Zipper(Cons(v,Nil));
  }
  public function isRoot():Bool{
    return switch this {
      case Cons(x,Nil) : true;
      default : false;
    }
  }
  public function end():Zipper<T>{
    return Cons(KTree.empty(),this);
  }
  /**
    moves to the right sibling
  */
  public function right():Zipper<T>{
    return switch this {
      case Cons(cursor,Cons(Branch(v,siblings),previous)):
        switch(findHead(siblings,cursor)){
          case Cons(_,Cons(right,_))  :
            var tree : KTree<T> = Branch(v,siblings);
            var o : Zipper<T> = new Zipper(Cons(right,Cons(tree,previous)));
            return o;
          default                     :
            var tree : KTree<T> = Branch(v,siblings);
            Cons(KTree.empty(),Cons(tree,previous));
        }
      default : end();
    }
  }
  /**
    moves to the left sibling
  */
  public function left():Zipper<T>{
    return switch(this){
      case Cons(cursor,Cons(Branch(v,siblings),previous)):
        switch(findLeft(siblings,cursor)){
          case Cons(left,_) :
            var tree : KTree<T> = Branch(v,siblings);
            Cons(left,Cons(tree,previous));
          default :
            var tree : KTree<T> = Branch(v,siblings);
            Cons(KTree.empty(),Cons(tree,previous));
        }
      default : Cons(KTree.empty(),this);
    }
  }
  /**
    moves to the parent.
  */
  public function up():Zipper<T>{
    var o : Zipper<T> = switch(this){
      case Cons(cursor,Cons(parent,rest)) : Cons(parent,rest);
      default                             : this;
    }
    return o;
  }
  /**
    Select the first child of the node at cursor.
  */
  public function down():Zipper<T>{
    return switch this {
      case Cons(Branch(_,Cons(firstChild,_)),_): Cons(firstChild,this);
      default: Cons(KTree.empty(),this);
    }

  }
  /*
    Produces the value of the head node.
  */
  public function value(){
    return switch(this){
      case Cons(Branch(v,_),_): v;
      default : null;
    }
  }
  /**
    Resets navigation.
  */
  public function root():Zipper<T>{
    return Cons(this.last(),Nil);
  }
  /**
    Produces the Tree
  */
  @:to public function toTree():KTree<T>{
    return this.last();
  }
  /**
    Adds a child value as a leaf to the selected node.
  */
  public function addChild(v:T):Tuple2<KTree<T>,Zipper<T>>{
    var new_tree : KTree<T> = Branch(v,Nil);
    return tuple2(new_tree,addChildNode(new_tree));
  }
  /**
    Adds a child value to the selected node.
  */
  public function addChildNode(v:KTree<T>):Zipper<T>{
    return switch(this){
      case Cons(Branch(node,children),rest) :
        var new_node = Branch(node,children.cons(v));
        update(new_node);
      default : Cons(v,Nil);
    }
  }
  /**
    Removes a child node by identity.
  */
  public function remChildNode(v:KTree<T>):Zipper<T>{
    return switch(this){
      case Cons(Branch(node,children),rest) if (children == null) : this;
      case Cons(Branch(node,children),rest) :
        //trace(Branch(node,children));
        children = children.fold(
          function(next,memo){
            //trace(treeEquals(v,next));
            return switch(next){
              case _  if(treeEquals(v,next)): memo;
              default : Cons(next,memo);
            }
          },
          Nil
        );
        var new_node = Branch(node,children);
        update(new_node);
      default : this;
    }
  }
  public function selectChild(new_head:KTree<T>):Zipper<T>{
    return switch(this){
      case Cons(head,t) : Cons(new_head,t);
      default : Cons(new_head,Nil);
    }
  }
  public function update(replace:KTree<T>):Zipper<T>{
    return Zippers.update(this,replace);
  }
/**
  Performs a depth first search for predicate FN, and
*/
  public function selectDF(fn:T->Bool):Zipper<T>{
    var head = this.head();
    var path : List<KTree<T>> = Nil;


    function handler(node:KTree<T>){

      if(node == null){
        return false;
      }
      path = path.cons(node);
      switch node {
        case Nought: return false;
        default:
      }

      if(fn(node.value())){
        return true;
      }else{
        var children = node.children();
        for(node in children){
          if(!handler(node)){
            path = path.tail();
          }else{
            return true;
          }
        }
        return false;
      }
    }
    handler(head);
    return if(path == Nil){
      this.concat(path.cons(Nought));
    }else{
      this.tail().concat(path);
    }
  }
  /**
    finds the left sibling of the cursor.
  */
  function findLeft(list:List<KTree<T>>,cursor:KTree<T>):List<KTree<T>>{
    function handler(ls,c):List<KTree<T>>{
      return switch(ls){
        case Cons(x,Cons(y,ys)) if (treeEquals(c,y)) : Cons(x,ys);
        case Cons(x,xs) : handler(xs,c);
        default : Nil;
      }
    }
    return handler(list,cursor);
  }
  /**
    finds the list of siblings including the cursor.
  */
  function findHead(list:List<KTree<T>>,cursor:KTree<T>):List<KTree<T>>{
    function handler(ls,c){
      return switch(ls){
        case Cons(x,xs) if (treeEquals(c,x)) : Cons(x,xs);
        case Cons(x,xs) : handler(xs,c);
        default : Nil;
      }
    }
    return handler(list,cursor);
  }
  /**
    compares nodes by reference.
  */
  static function treeEquals<T>(treel:KTree<T>,treer:KTree<T>):Bool{
    return treel == treer;
  }
}
class Zippers{
  /*
    Updates the currently focused node.
  */
  public static function update<T>(zip:Zipper<T>,replace:KTree<T>):Zipper<T>{
    /**
      goes from tip to root, updating the references, and producing a tuple
      of old_reterence,new_reference, the old being used for reference
      equality in the next step.
    */
    var changes : List<Tuple2<KTree<T>,KTree<T>>> = zip.fold(
      function(next:KTree<T>,memo:List<Tuple2<KTree<T>,KTree<T>>>):List<Tuple2<KTree<T>,KTree<T>>>{
        return switch([memo,next]){
          case [Nil,_]:
            var ls : List<Tuple2<KTree<T>,KTree<T>>> = List.unit().cons(tuple2(next,replace));
            ls;
          case [memo,Branch(v,rst)]:
            rst = (rst == null) ? Nil : rst;
            var leaves : List<KTree<T>> = rst.map(
                function(x:KTree<T>):KTree<T>{
                  var shouldChange = x == memo.head().fst();
                  return shouldChange ? memo.head().snd() : x;
                }
              );
            var branch : KTree<T>  = Branch(v,leaves);
            var o : List<Tuple2<KTree<T>,KTree<T>>> = memo.cons(tuple2(next,branch));
            o;
          case [_,Nought] :
            memo;
        }
      },Nil
    );
    /*
      Recursively rebuild the list, stripping out the old reference
    */
    function handler(next:List<Tuple2<KTree<T>,KTree<T>>>):List<KTree<T>>{
      return switch(next){
        case Cons(x,xs) :
          var ls = handler(xs);
          ls.concat(Cons(x.snd(),Nil));
        default : Nil;
      }
    }
    var o = handler(changes);
    return new Zipper(o);
  }
}
