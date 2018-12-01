package stx.ds.body;

class RBTrees{
     public static function balance<T>(tree: TreeT<T>): TreeT<T> {
      return switch (tree) {
        case  Node(Black, Node(Red, Node(Red, a, x, b), y, c), z, d)
            | Node(Black, Node(Red, a, x, Node(Red, b, y, c)), z, d)
            | Node(Black, a, x, Node(Red, Node(Red, b, y, c), z, d))
            | Node(Black, a, x, Node(Red, b, y, Node(Red, c, z, d))):
            Node(Red, Node(Black, a, x, b), y, Node(Black, c, z, d));
        case _:
            tree;
        }
    }
}