package hx.ds;

import hx.ds.ifs.Symbol in ISymbol;

import haxe.ds.StringMap;

class Graph<T:ISymbol>{
  private var nodes : StringMap<T>;
  private var edges : StringMap<Edge<T>>;

  public function new(?nodes:StringMap<T>,?edges:StringMap<Edge<T>>){
    this.nodes = nodes == null ? new StringMap() : nodes;
    this.edges = edges == null ? new StringMap() : edges;
  }
  private function copyWith(?node:T,?edge:Edge<T>):Graph<T>{
    var o = copyContent();
      if(node!=null){
        o.nodes.set(node.id,node);
      }
      if(edge!=null){
        o.edges.set(edge.id,edge);
      }
      return new Graph(o.nodes,o.edges);
  }
  private function copyContent():{nodes:StringMap<T>,edges:StringMap<Edge<T>>}{
    var nodes = new StringMap();
      for (node in this.nodes){
        nodes.set(node.id,node);
      }
    var edges = new StringMap();
      for (edge in this.edges){
        edges.set(edge.id,edge);
      }
    return { nodes : nodes, edges : edges };
  }
  public function link(edge:Edge<T>){
    return copyWith(null,edge);
  }
  public function unlink(edge:Edge<T>){
    var content = copyContent();
        content.edges.remove(edge.id);
        return new Graph(content.nodes,content.edges);
  }
  public function connect(node0:T,node1:T,?bidirectional = false):Graph<T>{
    var o = copyWith(null,new Edge(node0,node1));
    if(bidirectional == true){
      o = o.copyWith(null, new Edge(node1,node0));
    }
    return o;
  }
  public function add(node:T):Graph<T>{
    return copyWith(node);
  }
  public function rem(node:T):Graph<T>{
    var content = copyContent();
        content.nodes.remove(node.id);
    return new Graph(content.nodes,content.edges);
  }
}