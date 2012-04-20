package coll.i;

/**
 * ...
 * @author 0b1kn00b
 */

interface Searchable {
	/**
	 * Removes the object from the queue. Returns true if it was actually in
	 * the queue.
	 */
	@edit
	public function remove(v:T):Bool;
	
	/**
	 * Returns true if this collection contains the object given.
	 * @param	v
	 * @return
	 */
	public function contains(v:T):Bool;
}