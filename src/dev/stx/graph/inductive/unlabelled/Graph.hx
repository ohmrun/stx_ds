package stx;

import haxe.ds.Option;
using stx.Tuple;

import stx.graph.Errors;
import stx.data.Graph in TGraph;

abstract Graph<T,U>(TGraph<T,U>) from TGraph<T,U> to TGraph<T,U>{
  public function new(?self){
    this = self;
    if(this == null){
      this = TGraph.Empty;
    }
  }
  @:from static public function fromContext<A,B>(ctx:Context<A,B>):Graph<A,B>{
    return pure(ctx);
  }
  @:noUsing static public function unit<A,B>():Graph<A,B>{
    return Empty;
  }
  @:noUsing static public function pure<A,B>(ctx:Context<A,B>):Graph<A,B>{
    return TGraph.Graph(ctx,TGraph.Empty);
  }
  public function contexts(){
    return Graphs.contexts(this);
  }
  public function gpred(node){
    return Graphs.gpred(this,node);
  }
  public function with(ctx:Context<T,U>):Graph<T,U>{
    return Graphs.with(this,ctx);
  }
  public function ufold<V>(v:V,fn:Context<T,U>->V->V):V{
    return Graphs.ufold(this,v,fn);
  }
  public function adjs(){
    return Graphs.adjs(this);
  }
  public function nodes(){
    return Graphs.nodes(this);
  }
  public function snip(nd:Node):Couple<Option<Context<T,U>>,Graph<T,U>>{
    return Graphs.snip(this,nd);
  }
  public function gsuc(n:Node):ReadonlyArray<Node>{
    return Graphs.gsuc(this,n);
  }
  public function grev():Graph<T,U>{
    return Graphs.grev(this);
  }
  public function gmap<C,D>(fn:Context<T,U>->Context<C,D>):Graph<C,D>{
    return Graphs.gmap(this,fn);
  }
public function dfs(nodes):ReadonlyArray<Node>{
    return Graphs.dfs(this,nodes);
  }
  public function bfs(nodes):ReadonlyArray<Node>{
    return Graphs.bfs(this,nodes);
  }
  public function hasElements(){
    return switch(this) {
      case Empty : false;
      default : true;
    };
  }
  public var previous(get,never) : Option<Graph<T,U>>;

  private function get_previous(){
    return switch(this){
      case Empty : None;
      case Graph(_,g) : Some(g);
    }
  }
}
class Graphs{
  static public function snip<A,B>(g:Graph<A,B>,nd:Node):Couple<Option<Context<A,B>>,Graph<A,B>>{
    var log   = new stx.Log().use(stx.Show.show).levelled(stx.log.Level.INFO).close();
    log(g);
    log(g.contexts());
    var ctx = g.contexts();//.reversed();
    log.trace(ctx);
    var pre_post = ctx.toArray().partitionWhile(
      function(x){
        return x.key!=nd;
      }
    );
    log(pre_post);
    var pre   = pre_post.fst();
    var post  = pre_post.snd();
    log.trace('pre: $pre');
    log.trace('post: $post');

    if(!post.hasElements()){
      return tuple2(None,g);
    }
    var base  = pre.foldLeft(
      new Graph(),
      function(memo:Graph<A,B>,next:Context<A,B>){
        return memo.with(next);
      }
    );
    log.trace(base);
    var the_ctx  = post[0];
    log.debug(the_ctx);
    var grp0  = base;

    for(ctx in post.dropLeft(1)){
      var ptsI =
        ctx.incoming.toArray().partition(
          function(x:Edge<A>){
            return x.key != nd;
          }
        );
      var ptsO =
        ctx.outgoing.toArray().partition(
          function(x:Edge<A>){
            return x.key != nd;
          }
        );

      log.debug(ptsI);
      log.debug(ptsO);

      var new_ctx = Context.create(
        ptsI.fst(),
        ctx.key,
        ctx.val,
        ptsO.fst()
      );
      log.trace(new_ctx);
      grp0 = grp0.with(new_ctx);

      var new_ins : ReadonlyArray<Edge<A>> = ptsI.snd().map(
        function(e:Edge<A>):Edge<A>{
          return tuple2(e.fst(),ctx.key);
        }
      );
      var new_outs : ReadonlyArray<Edge<A>> = ptsO.snd().map(
        function(e:Edge<A>):Edge<A>{
          return tuple2(e.fst(),ctx.key);
        }
      );
      the_ctx = Context.create(new_ins.concat(the_ctx.incoming),the_ctx.key,the_ctx.val,new_outs.concat(the_ctx.outgoing));
    }

    return tuple2(Some(the_ctx),grp0);
  }
  static public function adjs<A,B>(g0:Graph<A,B>):Adjacent<A>{
    return ufold(
      g0,
      new Adjacent(),
      function(memo:Context<A,B>,next:Adjacent<A>):Adjacent<A>{
        return new Adj(next.and(memo.edges()));
      }
    );
  }
  static public function with<A,B>(g0:Graph<A,B>,ctx:Context<A,B>):Graph<A,B>{
    var log   = new stx.Log().use(stx.Show.show).close();
    //var ctxs  = contexts(g0);
    var nodes = nodes(g0);
    log(nodes);
    var adjs  = ctx.edges();

    adjs.each(
      function(edge:Edge<A>){
        if(nodes.length == 0){
          return;
        }
        var out = nodes.any(
          function(node){
            var o = edge.snd() == node;
            return o;
          }
        );
        if(!out){
          var node = edge.snd();
          throw new Error('node ($node) not found.');
        }
      }
    );

    return TGraph.Graph(ctx,g0);
  }
  static public function ufold<A,B,C>(graph:Graph<A,B>,arg:C,fn:Context<A,B>->C->C):C{
    return switch(graph){
      case Graph(ctx,par) :
        fn(ctx,ufold(par,arg,fn));
      case Empty : arg;
    }
  }
  static public function nodes<A,B>(graph:Graph<A,B>):ReadonlyArray<Node>{
    return ufold(graph,([]:ReadonlyArray<Node>),
      function(next:Context<A,B>,memo:ReadonlyArray<Node>):ReadonlyArray<Node>{
        return memo.append(next.key);
      }
    );
  }
  static public function contexts<A,B>(graph:Graph<A,B>):ReadonlyArray<Context<A,B>>{
    return ufold(graph,([]:ReadonlyArray<Context<A,B>>),
      function(c:Context<A,B>,arr:ReadonlyArray<Context<A,B>>):ReadonlyArray<Context<A,B>>{
        return arr.append(c);
      }
    );
  }
  static public function gmap<A,B,C,D>(graph:Graph<A,B>,fn:Context<A,B>->Context<C,D>):Graph<C,D>{
    return switch(graph){
      case Empty : Empty;
      case Graph(ctx, parent) :
        var val = fn(ctx);
        gmap(parent,fn).with(val);
    }
  }
  static public function grev<A,B>(graph:Graph<A,B>):Graph<A,B>{
    return gmap(graph,
      function(ctx){
        return Context.create(ctx.outgoing,ctx.key,ctx.val,ctx.incoming);
      }
    );
  }

  static public function gsuc<A, B>(graph: Graph<A, B>,nd: Node):ReadonlyArray<Node>{
    var log   = new stx.Log().use(stx.Show.show).close();
    log(graph.snip(nd).snd());
    return switch(graph.snip(nd).fst()){
      case None : [];
      case Some(ctx) :
        log(ctx);
        ctx.outgoing.map(Tuples2.snd);
    }
  }
  static public function gpred<A, B>(graph: Graph<A, B>,nd: Node):ReadonlyArray<Node>{
    return switch(graph.snip(nd).fst()){
      case None : [];
      case Some(ctx) :
        ctx.incoming.map(Tuples2.snd);
    }
  }
  static public function dfs<A, B>(graph:Graph<A,B>,nodes: ReadonlyArray<Node>):ReadonlyArray<Node>{
    var log = new stx.Log().close();
    log(nodes);
      if(!nodes.hasElements()){
        return [];
      }
      if(!graph.hasElements()){
        return [];
      }
      var head : Node = nodes.first();
      var after = graph.snip(head);
      return switch(after){
        case tuple2(None,g) :
          dfs(g,nodes.toArray().dropLeft(1));
        case tuple2(Some(ctx),g) :
          var suc : ReadonlyArray<Node> = ctx.successors();
          var nxt_nodes = nodes.slice(1);
          log('$suc | ${nxt_nodes}');
            dfs(
              g,
                suc.concat(nxt_nodes)
              ).append(nodes[0]);
      }
  }
  static public function bfs<A,B>(graph:Graph<A,B>,nodes:ReadonlyArray<Node>):ReadonlyArray<Node>{
    var log = new stx.Log().close();
        log(nodes);

      if(nodes == null || nodes.length == 0){
        return [];
      }
      if(!graph.hasElements()){
        return [];
      }
    var head : Node = nodes[0];
    var after = graph.snip(head);
      return switch(after){
        case tuple2(None,g) :
          bfs(g,nodes.slice(1));
        case tuple2(Some(ctx),g) :
          var suc : ReadonlyArray<Node> = ctx.successors();
          var nxt_nodes : ReadonlyArray<Node> = nodes.slice(1);
          //log('${nodes.dropLeft(1)} |  suc');
            bfs(
              g,
                nxt_nodes.concat(suc)
              ).append(nodes[0]);

      }
  }
  /*
  static public function undir<A,B>(g:Graph<A,B>):Graph<A,B>{
    function combine(p:Adj<B>,s:Adj<B>):Adj<B> =
  }
  def combine(p: Adj[B], s: Adj[B]): Adj[B] = RedBlackSet((p ++ s) :_*) toList
  def helper(ctx: Context[A, B]): Context[A, B] = {
      val adj = combine(ctx.snd(), ctx._4)
      (adj, ctx._2, ctx._3, adj)
  }*/

}
