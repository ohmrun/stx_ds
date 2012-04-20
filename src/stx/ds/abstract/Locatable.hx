/**
 * ...
 * @author 0b1kn00b
 */

package stx.i;

interface Locatable<K,V> {
	/**
	 * returns the value at key
	 * @param	key
	 * @return
	 */
	public function get(key:K):V;
	/**
	 * returns the existence of a value at key
	 * @param	key
	 * @return
	 */
	public function exists(key:K):Bool;
}