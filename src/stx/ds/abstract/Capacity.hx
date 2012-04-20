package coll.i;

/**
 * ...
 * @author 0b1kn00b
 */

interface Sized {
	
	public var size(get_size, null) : Int;
	/**
	 * Get the length of the Collection
	 * @return Int
	 */
	private function get_size():Int;
	
	public function isEmpty():Bool;
}