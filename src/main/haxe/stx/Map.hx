package stx;

enum Map<K,V>{
    Put(v:V);
    Get(k:K);
    Rem(k:K);
    Del(v:V);
    Idx;
}