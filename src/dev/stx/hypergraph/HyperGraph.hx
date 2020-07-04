package stx.hypergraph;

using stx.Tuple;

/*
import thx.Nel;
import thx.fp.RedBlackSet;
import thx.fp.List;


typedef VertexT     = Int;
abstract Vertex(VertexT) from VertexT{

}
typedef Name        = String;
typedef Attribute   = String;
typedef Attributes  = RedBlackSet<Attribute>;

//typedef Relation<T> = RedBlackSet<List<T>>;

typedef Schema<T>   = Couple<Name,RedBlackSet<Attribute>>;
typedef DBSchema<T> = RedBlackSet<Schema<T>>;


enum Atom{
    Sym(attribute:Attribute);
    Lit(v:Dynamic);
}
enum Expr{
    EAll(e:Expr);
    EAny(e:Expr);
    ENot(e:Expr);
    EOr(l:Expr,r:Expr);
    EAnd(l:Expr,r:Expr);

    EBind(l:Expr,name:String);
    EFree(name:String);

    EAtom(atom:Atom);
}
abstract Run(Dynamic) from Dynamic{
    @:resolve public function resolve(str:String){
        throw 'parse fail';
        return null;
    }
}
class Grammar{
    public function new(){}
}
//typedef Domain = Attributes -> 
//typedef RelationSymbol = Symg;

typedef HyperGraphData = {
    var vertices : RedBlackSet<Vertex>;
    var edges    : Couple<VertexT,Nel<Vertex>>;
}
abstract HyperGraph(HyperGraphData) from HyperGraphData to HyperGraphData{
    public function new(self){
        this = self;
    }
}

*/