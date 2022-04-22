package stx;

using stx.Tuple;

import stx.data.Context in TContext;
import stx.data.Graph in TGraph;

abstract Context<T,U>(TContext<T,U>) from TContext<T,U>{
  static public function create<A,B>(incoming:Adj<A>,ref:Node,v:B,outgoing:Adj<A>):Context<A,B>{
    return new Context(TContext.Context(incoming,ref,v,outgoing));
  }
  public function node():Null<Node>{
    return switch(this){
      case TContext.Context(_,ref,_,_): ref;
      default : null;
    }
  }
  public function new(?self){
    this = self;
    if(self == null){
      this = cast unit();
    }
  }
  @:from static public function fromNode<A,B>(n:Node):Context<A,B>{
    return pure(n);
  }
  @:to public function toGraph():Graph<T,U>{
    return TGraph.Graph(this,Empty);
  }
  @:noUsing static public function pure<A,B>(n:Node):Context<A,B>{
    return TContext.Context([],n,null,[]);
  }
  static public function unit<A,B>():Context<A,B>{
    return pure(null);
  }
  public function withIncoming(a:Adj<T>):Context<T,U>{
    return switch(this){
      case Context(incoming,ref,v,outgoing) if (incoming == null) : Context(a,ref,v,outgoing);
      case Context(incoming, ref,v,outgoing) : Context(incoming.and(a),ref,v,outgoing);
    }
  }
  public function withOutgoing(a:Adj<T>):Context<T,U>{
    return switch(this){
      case Context(incoming,ref,v,outgoing) if (outgoing == null) : Context(incoming,ref,v,a);
      case Context(incoming, ref,v,outgoing) : Context(incoming,ref,v,outgoing.and(a));
    }
  }
  public function withData(d:U):Context<T,U>{
    return switch(this){
      case Context(incoming,ref,v,outgoing): Context(incoming,ref,d,outgoing);
    }
  }
  public function withNode(n:Node):Context<T,U>{
    return switch(this){
      case Context(incoming,ref,v,outgoing): Context(incoming,n,v,outgoing);
    }
  }
  public function edges():Adj<T>{
    return switch(this){
      case Context(incoming,_,_,outgoing) : incoming.concat(outgoing);
    }
  }
  public var incoming(get,never) : Adj<T>;

  private function get_incoming(){
    return switch(this){
      case Context(_incoming,_,_,_) : _incoming;
    }
  }

  public function successors():Array<Node>{
    return outgoing.map(Tuples2.snd);
  }
  public var outgoing(get,never) : Adj<T>;

  private function get_outgoing(){
    return switch(this){
      case Context(_,_,_,_outgoing) : _outgoing;
    }
  }
  public var val(get,never) : U;

  private function get_val(){
    return switch(this){
      case Context(_,_,v,_) : v;
    }
  }
  public var key(get,never) : Node;

  private function get_key(){
    return switch(this){
      case Context(_,k,_,_) : k;
    }
  }
}
class Contexts{

}
