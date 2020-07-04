package stx.graph;

import tink.core.Error;
import haxe.PosInfos;

class Errors{
    static public function node_reference_not_found(node:Node,?pos:PosInfos){
      throw new Error('node ($node) not found.');
    }
}
