/*
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
*/

package hx.ds;

using stx.Tuple;

@doc("A 'java-style' collection interface.")
interface Collection<K,V> {

    @doc("The total number of items.")
    public var size(get,null) : Int;

    @doc("Returns true if this collection contains the value given.")
    function has(obj : Null<V>) : Bool;

    @doc("Returns true if this collection contains the key given.")
    function got(obj : Null<K>) : Bool;

    @doc("Clears all items")
    function clear() : Void;

    @doc("Returns true if the collection is empty.")
    function isEmpty() : Bool;

    @doc("Converts the collection to an array.")
    function toArray() : Array<Tuple2<K,V>>;

    @doc("Returns an Iterator")
    function iterator() : Iterator<Tuple2<K,V>>;
}
