package stx.ds.kary_tree;

/**
  Holds a path from the root to allow Tree navigation and
  immutable editing.
  of the form [root,[down,down],current]
*/
@:forward abstract KaryTreeZip<T>(LinkedList<KaryTree<T>>) from LinkedList<KaryTree<T>>{
  @:noUsing static public function lift<T>(self:LinkedList<KaryTree<T>>):KaryTreeZip<T>{
    return new KaryTreeZip(self);
  }
  public function new(self){
    this = self;
  }
  @:from static public function fromKaryTree<T>(v:KaryTree<T>):KaryTreeZip<T>{
    return new KaryTreeZip(Cons(v,Nil));
  }
  public function isRoot():Bool{
    return switch this {
      case Cons(x,Nil) : true;
      default : false;
    }
  }
  public function end():KaryTreeZip<T>{
    return lift(Cons(KaryTree.unit(),this));
  }
  /**
    moves to the right sibling
  */
  public function right():KaryTreeZip<T>{
    return switch this {
      case Cons(cursor,Cons(Branch(v,siblings),previous)):
        switch(find_head(siblings,cursor)){
          case Cons(_,Cons(right,_))  :
            var tree : KaryTree<T> = Branch(v,siblings);
            var o : KaryTreeZip<T> = new KaryTreeZip(Cons(right,Cons(tree,previous)));
            return o;
          default                     :
            var tree : KaryTree<T> = Branch(v,siblings);
            lift(Cons(KaryTree.unit(),Cons(tree,previous)));
        }
      default : end();
    }
  }
  /**
    moves to the left sibling
  */
  public function left():KaryTreeZip<T>{
    return switch(this){
      case Cons(cursor,Cons(Branch(v,siblings),previous)):
        switch(find_left(siblings,cursor)){
          case Cons(left,_) :
            var tree : KaryTree<T> = Branch(v,siblings);
            lift(Cons(left,Cons(tree,previous)));
          default :
            var tree : KaryTree<T> = Branch(v,siblings);
            lift(Cons(KaryTree.unit(),Cons(tree,previous)));
        }
      default : lift(Cons(KaryTree.unit(),this));
    }
  }
  /**
    moves to the parent.
  */
  public function up():KaryTreeZip<T>{
    var o : KaryTreeZip<T> = switch(this){
      case Cons(cursor,Cons(parent,rest)) : lift(Cons(parent,rest));
      default                             : this;
    }
    return o;
  }
  /**
    Select the first child of the node at cursor.
  */
  public function down():KaryTreeZip<T>{
    return switch this {
      case Cons(Branch(_,Cons(firstChild,_)),_): lift(Cons(firstChild,this));
      default: lift(Cons(KaryTree.unit(),this));
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
  public function children(){
    return toTree().children();
  }
  /**
    Resets navigation.
  */
  public function root():KaryTreeZip<T>{
    return lift(Cons(this.last(),Nil));
  }
  /**
    Produces the Tree
  */
  @:to public function toTree():KaryTree<T>{
    return this.last();
  }
  /**
    Adds a child value as a leaf to the selected node.
  */
  public function add_child(v:T):Couple<KaryTree<T>,KaryTreeZip<T>>{
    var new_tree : KaryTree<T> = Branch(v,Nil);
    return __.couple(new_tree,add_child_node(new_tree));
  }
  /**
    Adds a child value to the selected node.
  */
  public function add_child_node(v:KaryTree<T>):KaryTreeZip<T>{
    return switch(this){
      case Cons(Branch(node,children),rest) :
        var new_node = Branch(node,children.cons(v));
        update(new_node);
      default : lift(Cons(v,Nil));
    }
  }
  /**
    Removes a child node by identity.
  */
  public function rem_child_node(v:KaryTree<T>):KaryTreeZip<T>{
    return switch(this){
      case Cons(Branch(node,children),rest) if (children == null) : this;
      case Cons(Branch(node,children),rest) :
        //trace(Branch(node,children));
        children = children.fold(
          function(next,memo){
            //trace(tree_equals(v,next));
            return switch(next){
              case _  if(tree_equals(v,next)): memo;
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
  public function select_child(new_head:KaryTree<T>):KaryTreeZip<T>{
    return switch(this){
      case Cons(head,t) : lift(Cons(new_head,t));
      default : lift(Cons(new_head,Nil));
    }
  }
  public function update(replace:KaryTree<T>):KaryTreeZip<T>{
    return KaryTreeZips.update(this,replace);
  }
  /**
    Performs a depth first search for predicate FN, and
  */
  public function selectDF(fn:T->Bool):KaryTreeZip<T>{
    var head = this.head();
    var path : LinkedList<KaryTree<T>> = Nil;


    function handler(node:KaryTree<T>){

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
  function find_left(list:LinkedList<KaryTree<T>>,cursor:KaryTree<T>):LinkedList<KaryTree<T>>{
    function handler(ls,c):LinkedList<KaryTree<T>>{
      return switch(ls){
        case Cons(x,Cons(y,ys)) if (tree_equals(c,y)) : Cons(x,ys);
        case Cons(x,xs) : handler(xs,c);
        default : Nil;
      }
    }
    return handler(list,cursor);
  }
  /**
   * Finds the list of siblings including the cursor.
  */
  function find_head(list:LinkedList<KaryTree<T>>,cursor:KaryTree<T>):LinkedList<KaryTree<T>>{
    function handler(ls,c){
      return switch(ls){
        case Cons(x,xs) if (tree_equals(c,x)) : Cons(x,xs);
        case Cons(x,xs) : handler(xs,c);
        default : Nil;
      }
    }
    return handler(list,cursor);
  }
  /**
    compares nodes by reference.
  */
  static function tree_equals<T>(treel:KaryTree<T>,treer:KaryTree<T>):Bool{
    return treel == treer;
  }
}
class KaryTreeZips{
  /*
    Updates the currently focused node.
  */
  public static function update<T>(zip:KaryTreeZip<T>,replace:KaryTree<T>):KaryTreeZip<T>{
    /**
      goes from tip to root, updating the references, and producing a tuple
      of old_reterence,new_reference, the old being used for reference
      equality in the next step.
    */
    var changes : LinkedList<Couple<KaryTree<T>,KaryTree<T>>> = zip.fold(
      function(next:KaryTree<T>,memo:LinkedList<Couple<KaryTree<T>,KaryTree<T>>>):LinkedList<Couple<KaryTree<T>,KaryTree<T>>>{
        return switch([memo,next]){
          case [Nil,_]:
            var ls : LinkedList<Couple<KaryTree<T>,KaryTree<T>>> = LinkedList.unit().cons(__.couple(next,replace));
            ls;
          case [memo,Branch(v,rst)]:
            rst = (rst == null) ? Nil : rst;
            var leaves : LinkedList<KaryTree<T>> = rst.map(
                function(x:KaryTree<T>):KaryTree<T>{
                  var shouldChange = x == memo.head().fst();
                  return shouldChange ? memo.head().snd() : x;
                }
              );
            var branch : KaryTree<T>  = Branch(v,leaves);
            var o : LinkedList<Couple<KaryTree<T>,KaryTree<T>>> = memo.cons(__.couple(next,branch));
            o;
          case [_,Nought] :
            memo;
        }
      },Nil
    );
    /*
      Recursively rebuild the list, stripping out the old reference
    */
    function handler(next:LinkedList<Couple<KaryTree<T>,KaryTree<T>>>):LinkedList<KaryTree<T>>{
      return switch(next){
        case Cons(x,xs) :
          var ls = handler(xs);
          ls.concat(Cons(x.snd(),Nil));
        default : Nil;
      }
    }
    var o = handler(changes);
    return new KaryTreeZip(o);
  }
}
