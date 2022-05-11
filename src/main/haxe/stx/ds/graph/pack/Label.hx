package stx.ds.graph.pack;

typedef LabelDef = Int;

abstract Label(LabelDef) from LabelDef to LabelDef{
  public function new(self) this = self;
  @:noUsing static public function lift(self:LabelDef):Label return new Label(self);

  public function prj():LabelDef return this;
  private var self(get,never):Label;
  private function get_self():Label return lift(this);

  static public function map(){
    return RedBlackMap.make(Comparable.Couple(Comparable.Int(),Comparable.Int()));
  }
}