package coll.i;

/**
 * ...
 * @author 0b1kn00b
 */

 /**
  * Describes a collection with one entry poing and one exit point.
  */
interface Opaque<T,X> implements Collection<Enumerator<T>,X>{
	/**
	 * Adds an element.
	 * @param	v
	 */
	@edit
	public function adjoin(v:T):Void;	
	
	/**
	 * Removes and returns an element.
	 * @return
	 */
	@edit
	public function disjoin():T;
	
	/**
	 * Look at whatever the first value is.
	 */
	public function peek():T;
}