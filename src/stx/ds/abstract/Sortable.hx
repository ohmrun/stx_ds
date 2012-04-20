package stx.ds.abstract;

/**
 * ...
 * @author 0b1kn00b
 */

interface Sortable<C:Enumerable>,V,R> {
	public function sort():C;
	public function sortOn(fn V -> V -> Int):R;
}