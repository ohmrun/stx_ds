package stx;

abstract Node(Int) from Int{
  public function new(self){
    this = self;
  }
  public function label<T>(l:T):Adj<T>{
    var adj = new Adj();
    return adj.snoc(this,l);
  }
  public function unsafe():Int{
    return this;
  }
}
