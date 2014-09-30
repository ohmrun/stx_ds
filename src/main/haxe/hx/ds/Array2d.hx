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

package hx.ds;

import stx.ds.ifs.Collection;
/**
  A two-dimensional array that's faster (and contains more features) than 
  Array<Array<T>>.   
**/
class Array2d<T> implements Collection<T> {
    
  public var size(get_size, null) : Int;
  
  @:isVar public var height(get_height, set_height) : Int;
  @:isVar public var width(get_width, set_width) : Int;
  
  private var array : Array<Null<T>>;
  
  /**
    Initializes a two-dimensional array to match a given width and
    height. The smallest possible size is a 1x1 matrix. The initial value
    of all elements is null.
    
    This will throw an error if w or h is less than 1.
  **/
  public function new(w : Int, h : Int) {
      if (w < 1 || h < 1) throw "Illegal size";
      
      height = h;
      width = w;
                      
      array = new Array();
      for (i in 0...(w * h)) array.push(null);
  }
  
  private function get_height() {return height;}
  private function get_width()  {return width;}
  private function set_height(to : Int) : Int {
      resize(width, to);
      return height;
  }
  private function set_width(to : Int) : Int {
      resize(to, height);
      return width;
  }
  
  /**
    Writes a given value into each cell of the two-dimensional array. 
  **/
  public function fill(obj : Null<T>) {
      for (i in 0...(width * height)) array[i] = obj;
  }
  
  /**
    Fills the collection with the return value of the given function.
    At each location in the Array2d, the function is given the x and y 
    cooridinates and is expected to return a value.
  **/
  public function fillIndividual(f : Int -> Int -> Null<T>) {
      for (y in 0...height) {
          var offset = y * width;
          
          for (x in 0...width) array[offset + x] = f(x, y);
      }
  }
  
  
  /**
    Reads a value from a given x/y index. No boundary check is done, so
    you have to make sure that the input coordinates do not exceed the
    width or height of the two-dimensional array.
  **/
  public function get(x : Int, y : Int) : Null<T> {
      return array[y * width + x];
  }
  
  /**
    Writes a value into a cell at the given x/y index. Because of
    performance reasons no boundary check is done, so you have to make
    sure that the input coordinates do not exceed the width or height of
    the two-dimensional array.
  **/
  public function set(x : Int, y : Int, obj : Null<T> ) {
      array[y * width + x] = obj;
  }
  
  /**
    Resizes the array to match the given width and height. If the new
    size is smaller than the existing size, values are lost because of
    truncation, otherwise all values are preserved. The minimum size
    is a 1x1 matrix.
    
    This will throw an error if you attempt to resize below 1x1.
  **/
  public function resize(w : Int, h : Int) {
      if (w < 1 || h < 1) throw "Illegal size.";
                      
      var copy = array.copy();
      
      array = new Array();
      for (i in 0...(width * height)) array.push(null);
                      
      var minX = if (w < width) w else width;
      var minY = if (h < height) h else height;
                      
      for (y in 0...minY) {
          var t1 = y * w;
          var t2 = y * width;
          
          for (x in 0...minX) array[t1 + x] = copy[t2 + x];
      }
      
      width = w;
      height = h;
  }
  
  /**
    Extracts a row from a given index.
  **/
  public function getRow(y : Int) : Array<Null<T>> {
      var offset = y * width;
      return array.slice(offset, offset + width);
  }
  
  /**
    Inserts new values into a complete row of the two-dimensional array. 
    The new row is truncated if it exceeds the existing width.
    
    This will throw an error if y is out of bounds.
  **/
  public function setRow(y : Int, a : Array<Null<T>>) {
      if (y < 0 || y > height) throw "Row index out of bounds";
                      
      var offset = y * width;
      for (x in 0...width) array[offset + x] = a[x];     
  }
  
  /**
    Extracts a column from a given index.
  **/
  public function getColumn(x : Int) : Array<Null<T>> {
      var t = new Array<T>();
      
      for (i in 0...height) t[i] = array[i * width + x];
      return t;
  }
              
  /**
    Inserts new values into a complete column of the two-dimensional
    array. The new column is truncated if it exceeds the existing height.
    
    This will throw an error if the column index is out of bounds.
  **/
  public function setColumn(x : Int, a : Array<Null<T>>) {
      if (x < 0 || x > width) throw "Column index out of bounds";
                      
      for (y in 0...height) array[y * width + x] = a[y];     
  }
  
  /**
    Shifts all columns by one column to the left. Columns are wrapped,
    so the column at index 0 is not lost but appended to the rightmost
    column.
  **/
  public function shiftLeft() {
      if (width == 1) return;
                      
      var j = width - 1;
      for (i in 0...height) {
          var k = i * width + j;
          array.insert(k, array.splice(k - j, 1)[0]);
      }
  }
              
  /**
    Shifts all columns by one column to the right. Columns are wrapped,
    so the column at the last index is not lost but appended to the
    leftmost column.
  */
  public function shiftRight() {
      if (width == 1) return;
                      
      var j = width - 1;
      for (i in 0...height) {
          var k = i * width + j;
          array.insert(k - j, array.splice(k, 1)[0]);
      }
  }
              
  /**
    Shifts all rows up by one row. Rows are wrapped, so the first row
    is not lost but appended to bottommost row.
  **/
  public function shiftUp() {
      if (height == 1) return;
                      
      array = array.concat(array.slice(0, width));
      array.splice(0, width);
  }
              
  /**
    Shifts all rows down by one row. Rows are wrapped, so the last row
    is not lost but appended to the topmost row.
  **/
  public function shiftDown() {
      if (height == 1) return;
                      
      var offset = (height - 1) * width;
      array = array.slice(offset, offset + width).concat(array);
      array.splice(height * width, width);
  }
  
  /**
      Appends a new row. If the new row doesn't match the current width,
      the inserted row gets truncated or widened to match the existing
      width.
  **/
  public function appendRow(a : Array<Null<T>>) {
      a = ensureLength(a, width);
      
      array = array.concat(a);
      height++;
  }
              
  /**
    Prepends a new row. If the new row doesn't match the current width,
    the inserted row gets truncated or widened to match the existing
    width.
  **/
  public function prependRow(a : Array<Null<T>>) {
      a = ensureLength(a, width);
      
      array = a.concat(array);
      height++;
  }
              
  /**
    Appends a new column. If the new column doesn't match the current
    height, the inserted column gets truncated or widened to match the
    existing height.
  **/
  public function appendColumn(a : Array<Null<T>>) {
      for (y in 0...height) array.insert(y * width + width + y, a[y]);
      width++;
  }
              
  /**
    Prepends a new column. If the new column doesn't match the current
    height, the inserted column gets truncated or widened to match the
    existing height.
  **/
  public function prependCol(a : Array<Null<T>>) {       
      a = ensureLength(a, height);
      
      for (y in 0...height) array.insert(y * width + y, a[y]);
      width++;
  }
              
  /**
    Flips rows with columns and vice versa.
  **/
  public function transpose() {
      var a = array.copy();
      for (y in 0...height) {
          for (x in 0...width) {
              array[x * width + y] = a[y * width + x];
          }
      }
  }
  
  /**
    Grants access to the linear array which is used internally to
    store the data in the two-dimensional array. Use with care for
    advanced operations.
  **/
  public function getInternalArray() : Array<Null<T>> {
      return array;
  }
              
  public function contains(obj : Null<T>) : Bool {
    for (match in array) {
        if (match == obj) return true;
    }
    
    return false;
  }
              
  public function clear() {
    array = new Array();
    for (i in 0...(width * height)) array.push(null);
  }
 
  public function enumerator(){
    return null;
  }
  
  private function get_size() : Int {
      return width * height;
  }
              
  public function isEmpty() : Bool {
      return false;
  }
              
  public function toArray() : Array<T> {
      var a = array.copy();
                      
      var k = width * height;
      if (a.length > k) a.splice(k - 1, a.length - k);
      
      return a;
  }
              
  /**
    Prints out a string representing the current object.
    Example: "[Array2, width=2, height=93]"
  **/
  public function toString() : String {
      return "[Array2, width=" + width + ", height=" + height + "]";
  }
              
  /**
    Prints out all elements (for debug/demo purposes).
  **/
  public function dump() : String {
      var s:String = "Array2\n{";
      
      for (y in 0...height) {
          s += "\n" + "\t";
          var offset = y * width;
          
          for (x in 0...width) {
              var value = Std.string(array[offset + x]);
              s += "[" + (if (value != null) value else "?") + "]";
          }
      }
      
      s += "\n}";
      return s;
  }
  
  /**
    Ensures that the array is the length given.
    If it's too short, its filled with nulls, otherwise it's truncated.
  **/
  private static inline function ensureLength<U>(array : Array<U>, length : Int) : Array<U> {
      var newArray = new Array<U>();
      for (i in 0...length) newArray.push(array[i]);
      
      return newArray;
  }
}