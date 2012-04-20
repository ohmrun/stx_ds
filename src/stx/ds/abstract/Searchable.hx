package coll.i;

/**
 * ...
 * @author 0b1kn00b
 */

interface Searchable {
	/**
	 * Removes the object from the collection. Returns true if it was actually in
	 * the queue.
	 */
	@edit
	public function remove(v:T):Bool;
	

}