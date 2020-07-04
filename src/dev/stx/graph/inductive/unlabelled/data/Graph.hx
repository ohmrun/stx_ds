package stx.data;

import stx.Context in AContext;
import stx.Graph in AGraph;

enum Graph<T,U>{
  Empty;
  Graph(next:AContext<T,U>,prev:AGraph<T,U>);
}
