package stx.ds.graph.test;


class Dep{
    static public function eq(l:Dep,r:Dep):Bool{
        return true;
    }
}
class GraphTest extends stx.test.TestCase{
    public function test(){
        //var g   = Graph.unit();
        //var c   = new Context(Dep.eq);
        //var l : List<Vertex> = ["this","then","that","done"].map(Vertex.pure);
        //var g0  = g.circuit(l);
        
        //trace(g0.edges.toList());
        //trace(g0.vertices.toList());
    }
}
/*
interface LogicI<P,T>{
    public function conj(l:Predicate<P>,r:P):P;
    public function disj(l:P,r:P):P;
    public function unif(l:T,r:T):P;
    public function push(t:T,p:P):P;
}
enum Logic<P,T>{
    Conj(l:Predicate<P>,r:Predicate<P>);
    Disj(l:Predicate<P>,r:Predicate<P>);
    Unif(l:T,r:T);
    Push(t:T,p:Predicate<P>);
}

typedef PredicateT<T> = T -> Stream<T>;
abstract Predicate<T>(PredicateT<T>){
    static public function trueP(v:T):Stream<T>{
        var out : Stream = [v].iterator();
        return out;
    }
    static public function falseP(v:T):Stream<T>{
        var out : Stream = [].iterator();
        return out;
    }
}
*/
@:forward abstract AdjacencyMap<T>(Map<T,RedBlackSet<T>>) from Map<T,RedBlackSet<T>> to Map<T,RedBlackSet<T>>{
    static public function empty<T>():AdjacencyMap<T>{
        return Map.empty();
    }
}
//@:forward abstract AdjacencyMapGraph<T>(Context<AdjacencyMap<T>>) from Context<AdjacencyMap<T>> to Context<AdjacencyMap<T>>{
    /*
     empty       = AM $ Map.empty
    vertex  x   = AM $ Map.singleton x RedBlackSet.empty
    overlay x y = AM $ Map.unionWith RedBlackSet.union
        (adjacencyMap x) (adjacencyMap y)
    connect x y = AM $ Map.unionsWith RedBlackSet.union
        [ adjacencyMap x, adjacencyMap y
        , fromRedBlackSet (const . keysRedBlackSet $ adjacencyMap y)
                  (keysRedBlackSet $ adjacencyMap x) ]

    */
//}