package hx.ds.ifs;

class Data<V> {
	@:isVar private var data(get,set) : V;
  private function get_data():V{
    return data; 
  }
  private function set_data(v:V):V{
    return data = v; 
  }
}