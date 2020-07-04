package stx.ds.graph;

class Test{
  public function test(){
    trace("test"); 
    var arr = [1,2,3,4,5,6,7,8].ds();
    var cons = [
      [1,2],
      [1,3],
      [3,4],
      [3,5],
      [3,6],
      [4,7],
      [5,8],
      [2,8],
      [1,6],
      [8,1],
    ].ds();
    var vertices = arr.fold((next,memo:RedBlackSet<Vertex>) -> memo.put(next),Vertex.set());
    var edges    = cons.fold((next,memo:RedBlackSet<Edge>)-> memo.put(__.couple(next[0],next[1])),Edge.set());
    var graphdata : Graph = {
      vertices : vertices,
      edges : edges
    };
    var out = graphdata;
    for(val in vertices){
      //trace(val);
    }
    var show = out.toKTree(3).toString();
      //trace(show);
}