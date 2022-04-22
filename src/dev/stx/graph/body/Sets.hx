package stx.graph.body;

class RedBlackSets{
    static public function unit<T>():RedBlackSet<T>{
        return (Tip:RedBlackSet<T>);
    }
    @:noUsing static public function pure<T>(v:T,ord:T->T->Ordering):RedBlackSet<T>{
        return unit().insert(v,ord);
    }
}