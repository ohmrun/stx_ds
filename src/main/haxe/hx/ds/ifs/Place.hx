package stx.ds.ifs;

import stx.mcr.Self;

interface Place<K,V>{
	public function set(key:K, value:V):Bool;
}