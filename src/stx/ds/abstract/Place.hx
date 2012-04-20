package coll.i;

/**
 * ...
 * @author 0b1kn00b
 */

interface Place<K,V,R> {
	@edit
	public function set(key:K, value:V):R;
}