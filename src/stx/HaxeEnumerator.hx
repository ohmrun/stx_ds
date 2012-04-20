package coll;

/**
 * ...
 * @author 0b1kn00b
 */
import coll.i.Enumerator;

/**
 * Enumerator that uses haxe internal Iterator directly.
 */
class HaxeEnumerator<T> implements Enumerator<T> {
	private var __next__ 			: Void -> T;
	private var __hasNext__		: Void -> Bool;
	public function new(next,hasNext):Void {
		this.__next__ 			= next;
		this.__hasNext__ 		= hasNext;
	}
	public inline function next():T {
		return __next__();
	}
	public inline function hasNext():Bool {
		return __hasNext__();
	}
}