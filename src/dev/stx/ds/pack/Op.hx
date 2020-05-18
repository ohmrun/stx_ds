package stx;

enum Op<A,B>{
    Put(a:A);
    Get(b:B);
    Idx;
}