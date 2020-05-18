package stx.ds.type;

enum RedBlackTreeSum<T> {
  Leaf;
  Node(color: RedBlackSum, left: RedBlackTreeSum<T>, label: T, right: RedBlackTreeSum<T>);
}