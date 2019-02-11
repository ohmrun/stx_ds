package stx.ds.head.data;

enum RBTree<T> {
  Leaf;
  Node(color: RBColour, left: RBTree<T>, label: T, right: RBTree<T>);
}