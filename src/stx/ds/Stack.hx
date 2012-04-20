/**
* Copyright (c) 2008 Chase Kernan, Laurence Taylor
* chase.kernan@gmail.com, polysemantic@gmail.com
* Based off of Michael Baczynski's as3ds project, http://www.polygonal.de.
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/

package coll;

import coll.i.Collection;
import coll.i.Bounded;
import coll.i.DefaultEnumeratorTrait;
import coll.i.Enumerable;
import coll.i.Enumerator;
/**
 * A standard LIFO stack. 
*/
class Stack<T> 
		implements Collection < T, Array<T> > , 
				implements Bounded,
				implements DefaultEnumeratorTrait<T,List<Null<T>>>{
	
    public var length(getLength, null) : Int;
    
    private var data : List<Null<T>>;
    
    /**
        Creates a new empy stack.
    **/
    public function new() {
        data = new List();
    }
		private var initialized : Bool;
    /**
		 * @inheritDoc
		 */
		public function init(v:Array<T>):Void {
			if ( !initialized ) {
				for (val in v) {
						data.add(val);
				}
				initialized = true;
			}
		}
    /**
		 * Adds the item to the top of the stack.
    **/
    public function adjoin(item : T) {
        list.push(item);
    }
    
    /**
		 * Removes and returns the item on the top of the stack.
    **/
    public function disjoin() : T {
        return list.pop();
    }
		/**
		 * @inheritDoc
		 */
    public function clear() {
        data = new List();
    }
    /**
     * @inheritDoc
     */
    private function getLength() {
        return data.length;
    }
    /**
		 * @inheritDoc
		 */
    public function isEmpty() : Bool {
        return list.isEmpty();
    }
		/**
		 * @inheritDoc
		 */
    public function toArray() : Array<Null<T>> {
        return Lambda.array(list);
    }

    /**
        Prints out a string representing the current object.
        Example: "[Stack, size=4]"
    **/
    public function toString() : String {
        return "[Stack, size=" + Std.string(list.length) + "]";
    }
}