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

package;
using CollectionUtil;

/**
 * A standard FIFO queue. 
 */
class Queue<T> implements Collection<Enumerator<T>,T,Array<T>>, implements DefaultEnumeratorTrait<T> {
    
    public var length(getLength, null) : Int;
    
    private var list : List<T>;
    
    public function new() {
        list = new List();
    }
		/**
		 * @inheritDoc
		 */
		public function init(v:Array<T>):Void {
			if ( !initialized ) {
				for (val in v) {
						list.add(val);
				}
				initialized = true;
			}
		}
		private var initialized : Bool;
		
    /**
		 * @inheritDoc
		 */
    public function peek() : Null<T> {
        if (list.isEmpty()) return null;
        
        return list.first();
    }
    /**
		 * @inheritDoc
		 */
    public function adjoin(item : Null<T>) {
        list.add(item);
    }
    /**
		 * @inheritDoc
		 */
    public function disjoin() : Null<T> {
        return list.pop();
    }  
		/**
		 * @inheritDoc
		 */
    public function clear() {
        list = new List();
    }
		/**
		 * @inheritDoc
		 */
    private function getLength() {
        return list.length;
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
    public function contains(obj : Null<T>) : Bool {
        for (match in list) {
            if (obj == match) return true;
        }
        
        return false;
    }
		/**
		 * @inheritDoc
		 */
    public function toArray() : Array<Null<T>> {
        return Lambda.array(list);
    }
    /**
		 * @inheritDoc
		 */
    public function enumerator() : Enumerator<T> {
        return list.iterator().toEnumerator();
    }
}