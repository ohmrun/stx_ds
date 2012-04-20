package stx.ds.fn.abstract;

/**
 * ...
 * @author 0b1kn00b
 */

interface Monadic<C:Enumerable<V>,V> {
	public function map<R>(fn : V -> R) : C;
	/**
	 * NOTE cannot enforce R output as *this* collection type in definition, although in practice this isn't a problem.
	 */
	public function reduce<R>(fn : V -> R) : R;
}