package stx.data;

import stx.Adjacent in AAdjacent;

enum Context<T,U>{
  Context(incoming:AAdjacent<T>,ref:Node,v:U,outgoing:AAdjacent<T>);
}
