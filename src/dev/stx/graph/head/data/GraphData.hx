package stx.graph.head.data;

import stx.graph.body.Vertex;
import stx.graph.body.Edge;

typedef GraphData = {
    var vertices    : RedBlackSet<Vertex>;
    var edges       : RedBlackSet<Edge>;
}