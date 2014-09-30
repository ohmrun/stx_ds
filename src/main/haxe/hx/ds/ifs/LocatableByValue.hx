package hx.ds.ifs;

import stx.ds.ifs.*;

/**
 * Describes a collection where the elements can be addressed with a key of some sort. eg Hash & Array.
 * V = value in key / value setup.
 * K = key in key / value setup.
 */
interface LocatableByValue<K, V> {
	/**
	 * Returns true if this collection contains the object given.
	 * @param	v
	 * @return
	 */
	public function contains(v:V):Bool;
	/**
	 * Find the location of a value in the collection.
	 * @param	v
	 * @return The location.
	 */
	public function locationOf(value:V):K;
	/**
	 * Find the locations of a value in the collection.
	 * @param	v
	 * @return The locations.
	 */
	public function locationsOf(value:V):Enumerable<K>;
	/**
	 * Find the last location of a value.
	 * @param	v
	 * @return The location.
	 */
	public function locationOfLast(value:V):K;
	/**
	 * Find the last location of a value.
	 * @param	v
	 * @return The location
	 */
	public function locationOfFirst(value:V):K;
}