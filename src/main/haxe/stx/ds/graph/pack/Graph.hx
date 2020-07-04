package stx.ds.graph.pack;

typedef GraphDef = {
  var vertices    : RedBlackSet<Vertex>;
  var edges       : RedBlackSet<Edge>;
}

@:using(stx.ds.graph.pack.Graph.GraphLift)
@:forward abstract Graph(GraphDef) from GraphDef{
  static public var _(default,never) = GraphLift;
  public function new(?self:GraphDef){
    this = self == null ? def() : self;
  }
  static private function def():GraphDef{
    return {
      vertices  : Vertex.set(),
      edges     : Edge.set() 
    }
  }
  static public function unit():Graph{
    return def();
  }
  @:noUsing static public function make(verts,edges):Graph{
    return new Graph({
      vertices : __.option(verts).defv(Vertex.set()),
      edges    : __.option(edges).defv(Edge.set())
    });
  }
  function clone(?vertices,?edges){
    return make(
      __.option(vertices).defv(this.vertices), 
      __.option(edges).defv(this.edges) 
    );
  }
  public function node(v:Vertex):Graph{
    return clone(this.vertices.put(v));
  };
}

class GraphLift{
  static public function connect(l:Graph,r:Graph):Graph{
    __.assert().exists(l);__.assert().exists(r);
    var next_vertices   = l.vertices.union(r.vertices);
    var next_edges      = 
        l.edges.union(r.edges)
         .union(
           Vertex._.product(l.vertices,r.vertices)
         );
        
    return {
        vertices : next_vertices,
        edges    : next_edges     
    };
  }
  static public function overlay(l:Graph,r:Graph):Graph{
    var next_vertices   = l.vertices.union(r.vertices);
    var next_edges      = l.edges.union(r.edges);
    return {
        vertices    : next_vertices,
        edges       : next_edges
    };
  }
  static public function biconnect(l:Graph,r:Graph):Graph{
    return overlay(connect(l,r),connect(r,l));
  }
  static public function fromEdges(g:Graph,arr:Iterable<Couple<Vertex,Vertex>>):Graph{
      var edge = function(l:Vertex,r:Vertex){
        return connect(
            Graph.unit().node(l),
            Graph.unit().node(r)
        );
      };
      return arr.fold(
          function(next:Couple<Vertex,Vertex>,memo:Graph){
              return overlay(
                  memo,
                  overlay(Graph.unit(),next.decouple(edge))
              );
          },
          g
      );
  }
  /*
  static public function path(g:Graph,list:List<Vertex>):Graph{
    return switch(list){
      case Nil                : g;
      case Cons(x,Nil)        : Graph.unit().node(x);
      case _         :
          fromEdges(
              g,
              list.zip(list.tail()).map(
                  function(tp){
                      return tuple2(tp._0,tp._1);
                  }
              )
          );
    }
  }*/
  static public function toKTree(g:Graph,from:Vertex):KaryTree<Vertex>{
    var membership = RedBlackSet.make_with(
      Ord.Anon((l,r) -> l < r),
      Eq.Anon((l,r) -> l == r)
    ).put(from);  
    var pure = KaryTree.pure;

    var tree = new KaryTree();
    
    var show_edges = g.edges.fold(
      (next,memo:Array<Edge>) -> memo.snoc(next),
      []
    );
    //trace('edges: $show_edges');
    function rep(zip:KaryTreeZipper<Vertex>,membership:RedBlackSet<Vertex>):KaryTreeZipper<Vertex>{
      //trace("_______________________________" + zip.value());
      var value = zip.value();
       
      var leads = g.edges.filter(
        function(tp){
          var is_from   = (tp.fst() == value);
          var has_seen  = (membership.has(tp.snd()));
          //trace('${tp.fst()} ${tp.snd()} is_from $is_from has_seen $has_seen');
          var ok = is_from && !has_seen; 
          //trace('ok $ok');
          if(ok){
            //trace('value: $value adding lead: $tp because is_from = $is_from');
          }
          return ok;
        }
      );
      var show_leads = leads.fold(
        (next,memo:Array<Vertex>) -> memo.snoc(next.snd()),
        []
      );
      //trace('val: $value leads: $show_leads membership: $membership');
      
      for(lead in leads){
        var subtree = rep(pure(lead.snd()).zipper(),membership.put(lead.snd()));
        zip = zip.add_child_node(subtree.toTree());
      }
      return zip;
    }
    var out = rep(pure(from).zipper(),membership);
    return out;
  }
}