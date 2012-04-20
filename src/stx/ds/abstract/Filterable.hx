/**
 * ...
 * @author 0b1kn00b
 */

package stx.ds.abstract;

interface Filterable<V,R:Enumerable> {
	public function filter( fn : V -> Bool ) : R
}