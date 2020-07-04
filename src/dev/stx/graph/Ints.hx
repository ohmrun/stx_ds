package stx.graph;

class Ints{
    static public function ord(l:Int,r:Int):Ordering{
        return l > r ? GT : l == r ? EQ : LT;
    }
}