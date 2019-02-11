package stx.ds.pack.xerset;

abstract SouVal<K,V>(SouValT<K,V>) from SouValT<K,V>{
  public function new(self) this = self;
  public function fst():K{
    return switch(this){
      case SouSan(k,_) : k;
      case SouSet(k,_) : k;
    }
  }
  public function snd():Either<XerSet<K,V>,V>{
    return switch(this){
      case SouSet(_,v) : Left(v);
      case SouSan(_,v) : Right(v);
    }
  }
}