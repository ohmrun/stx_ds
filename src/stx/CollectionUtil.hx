package coll;

/**
 * ...
 * @author 0b1kn00b
 */
import coll.i.Enumerator;

class CollectionUtil {
	public static function toEnumerator<A>(i:Iterator<A>):Enumerator<A>{
		return new HaxeEnumerator(i.next, i.hasNext);
	}
}