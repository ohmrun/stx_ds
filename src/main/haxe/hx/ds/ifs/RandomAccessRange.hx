package hx.ds.ifs;

interface RandomAccessRange<K,V> extends ForwardRange<V>{
  public function at(key:K):T;
  public function slice(from:K,to:K):RandomAccessRange<V>;
}