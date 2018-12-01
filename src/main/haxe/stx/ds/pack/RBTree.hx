package stx.ds.head.data;

private enum RBTreeT<T> {
  Leaf;
  Node(color: Color, left: TreeT<T>, label: T, right: TreeT<T>);
}