package coll.i;

/**
 * ...
 * @author 0b1kn00b
 */

interface DefaultEnumeratorTrait<T,C> implements Data<C>{
	/**
	 * @inheritDoc
	 */
	public function enumerator() : Enumerator<T> {
		return coll.CollectionUtil.toEnumerator( data.iterator() );
	}
}