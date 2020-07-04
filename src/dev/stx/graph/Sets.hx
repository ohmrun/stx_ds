package stx.graph;

class RedBlackSets{
    static public function union<T>(set0:RedBlackSet<T>,set1:RedBlackSet<T>):RedBlackSet<T>{
        return set0.union(set1);
    }
}