package coll.i;

/**
 * ...
 * @author 0b1kn00b
 */
interface Enumerator<T> {
	public function next():T;
	public function hasNext():Bool;
}