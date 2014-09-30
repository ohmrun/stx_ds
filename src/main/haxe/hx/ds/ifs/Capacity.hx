package hx.ds.ifs;

interface Capacity{
	
	public var size(get_size, null) : Int;
	/**
	 * Get the size of the Collection
	 * @return Int
	 */
	private function get_size():Int;
	 
	public function isEmpty():Bool;
}