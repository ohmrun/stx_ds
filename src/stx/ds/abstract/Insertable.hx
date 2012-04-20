/**
 * ...
 * @author 0b1kn00b
 */

package stx.ds.abstract;

interface Insertable<K,V,R> {
	public function insertBefore(key:K, value:V):R;
	public function insertAfter(key:K, value:V):R;
}