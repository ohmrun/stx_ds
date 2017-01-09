package hx.ds;

import stx.types.*;

import stx.Compare.*;

import stx.Options;
import stx.Tuple;
import stx.Tuple.Tuples2.snd;

using stx.Iterables;
using stx.Pointwise;
using stx.Order;
using stx.Tuple;
import stx.types.*;
using stx.Arrays;

@:stability(0)
class MultiMap<K,V>{
	private var impl : OrderedMap<K,Array<V>>;

	public function new() {
		impl = new OrderedMap();
	}
	public function set(key:K,val:V){
		if(!impl.has(key)){
			impl.set(key,[val]);
		}else{
			impl.get(key).push(val);
		}
		return this;
	}
	public function get(key:K):Array<V>{
		return impl.get(key);
	}
	public function del(key:K){
		return impl.del(key);
	}
	public function rem(val:V){
		for( arr in impl.map(snd) ){
			if( arr.remove(val) ){
				return true;
			}
		}
		return false;
	}
	public function has(key:K){
		return impl.has(key);
	}
	public function put(t:Tuple2<K,V>){
		this.set(t.fst(),t.snd());
	}
	public function iterator(){
		return impl.iterator();
	}
	public function toArray(){
		return impl.toArray();
	}
	public function toString():String{
		return impl.toString();
	}
	private function at(idx:Int){
		return impl.at(idx);
	}
	public function vals():Iterable<V>{
		return {
			iterator :
			function(){
				var idx 		: Int 			= 0;
				var current : Array<V>  = at(idx);
				var idx0 		: Int 			= 0;

				return {
					next : function(){
						if(idx0 == current.length){
							idx0 = 0;
							idx  +=1;
							current = at(idx);
						}
						var o = current[idx0];
						idx0+=1;
						return o;
					},
					hasNext : function(){
						return if(nl().apply(current)){
							false;
						}else{
							if(idx0 == current.length){
								if(nl().apply(at(idx+1))){
									false;
								}else{
									true;
								}
							}else{
								true;
							}
						}
					}
				}
			}
		};
	}
	public function sort(){
		impl.sort();
	}
	public function sortWith(fn:Ord<Tuple2<K,Array<V>>>){
		return impl.sortWith(fn);
	}
	public function size(){
		return impl.size();
	}
	@:noUsing static public function fromArray<A,B>(v:Array<Tuple2<A,B>>):MultiMap<A,B>{
		var hash = new MultiMap();
		v.each(hash.put.enclose());
		return hash;
	}
}
