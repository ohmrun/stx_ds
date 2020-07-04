package stx.graph.body;

@:forward abstract Edge(Couple<Int,Int>) from Couple<Int,Int>{
    public function new(self){
        this = self;
    }
    public function unbox():Couple<Int,Int>{
        return this;
    }
    static public function ord(l:Edge,r:Edge):Ordering{
        return switch([l.unbox(),r.unbox()]){
            case [tuple2(l0,r0),tuple2(l1,r1)] :
                return Orderings.monoid.append(Ints.ord(l0,l1),Ints.ord(r0,r1));
        }
    }
    static public function union(l:RedBlackSet<Edge>,r:RedBlackSet<Edge>):RedBlackSet<Edge>{
        return l.foldLeft(
            r,
            function(memo,next:Edge){
                return memo.insert(next,ord);
            }
        );
    }
    
}