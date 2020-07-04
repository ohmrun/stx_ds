package hx.ds.ifs;

interface Symbol{
  @:isProp public var id(get,set) : String;
  private function get_id():String;
  private function set_id(str:String):String;
}