package coll.i;

/**
 * ...
 * @author 0b1kn00b
 */

interface Joinable <V,R> {
	
	@edit public function append(value:V):R;
	@edit public function prepend(value:V):R;
	
	@edit public function appendAll(values:Enumerable<V>):R;
	@edit public function prependAll(values:Enumerable<T>):R;
}