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

package zen.colhx.sort;

class Comparisons {
    
    public static var DEFAULT_COMPARISON = Reflect.compare;
    
    public static var COMPARE_INT_DESCENDING = 
    function(a : Null<Int>, b : Null<Int>) : Int {
        return b - a;
    };
    
    public static var COMPARE_INT =
    function(a : Null<Int>, b : Null<Int>) : Int {
        return a - b;
    };
    
    public static var COMPARE_STRING_CASE_INSENSITIVE =
    function(a : String, b : String) : Int {
        var r = 0;
		a = a.toLowerCase();
		b = b.toLowerCase();

		if (a.length + b.length > 2){
			var k = if (a.length > b.length) a.length else b.length;
			for (i in 0...k){
				r = a.charCodeAt(i) - b.charCodeAt(i);
				if (r != 0){
					break;
				}
			}
		} else {
			r = a.charCodeAt(0) - b.charCodeAt(0); 	
		}

		return r;
    };
    
    public static var COMPARE_STRING_CASE_INSENSITIVE_DESCENDING = 
    function(a : String, b : String) : Int {
        var r = 0;
		a = a.toLowerCase();
		b = b.toLowerCase();

		if (a.length + b.length > 2){
			var k = if (a.length > b.length) a.length else b.length;
			for (i in 0...k){
				r = b.charCodeAt(i) - a.charCodeAt(i);
				if (r != 0){
					break;
				}
			}
		} else {
			r = b.charCodeAt(0) - a.charCodeAt(0); 	
		}

		return r;
    };
    
    public static var COMPARE_STRING =
    function(a : String, b : String) : Int {
        var r = 0;

		if (a.length + b.length > 2){
			var k = if (a.length > b.length) a.length else b.length;
			for (i in 0...k){
				r = a.charCodeAt(i) - b.charCodeAt(i);
				if (r != 0){
					break;
				}
			}
		} else {
			r = a.charCodeAt(0) - b.charCodeAt(0); 	
		}

		return r;
    };
    
    public static var COMPARE_STRING_DESCENDING =
    function(a : String, b : String) : Int {
        var r = 0;

		if (a.length + b.length > 2){
			var k = if (a.length > b.length) a.length else b.length;
			for (i in 0...k){
				r = b.charCodeAt(i) - a.charCodeAt(i);
				if (r != 0){
					break;
				}
			}
		} else {
			r = b.charCodeAt(0) - a.charCodeAt(0); 	
		}

		return r;
    };
    
}