package hx.ds;

import haxe.ds.Option;

using stx.Tuple;
import stx.Options.option;
import stx.types.*;

import stx.Compare.*;

import stx.Show;
import stx.Equal;
using stx.Order;

using stx.Pointwise;
import stx.types.*;
using stx.Bools;
import stx.types.*;
using stx.Iterables;
using stx.Arrays;
using stx.Options;
using stx.Strings;


@:stability(1)
@:note('#0b1kn00b: How to clone this and maintain equalities?')
class OrderedHashMap<V>{
	private var __key_sort__ 	: Ord<Int>;
	private var __val_sort__ 	: Ord<V>;

	private var __val_equal__ : Eq<V>;
	public var impl 					: Array<Tuple2<Int,V>>;

	public function new(){
		impl = [];
	}
	public function set(key:Int,val:V){
		var tp : Tuple2<Int,V> = tuple2(key,val);
		lookup(key)
			.flatMap(
				function(t){
					return impl.findIndexOf(t);
				}
			).each(
				function(idx){
					this.impl = impl.set(idx,tp);
				}
			).isEmpty()
			 .ifTrue(
			 		function(){
			 			impl.push(tp);
			 			return null;
			 		}
			 	);
	}
	public function has(key:Int){
		return lookup(key).isDefined();
	}
	public function at(i:Int):V{
		return option(impl[i]).map(Tuples2.snd).valOrC(null);
	}
	public function get(key:Int):V{
		return lookup(key).map(Tuples2.snd).valOrC(null);
	}
	public function del(key:Int){
		lookup(key)
		 .each(
		 		function(x){
		 			impl.remove(x);
		 		}
		 	);
	}
	public function rem(v:V){
		nl().apply(__val_equal__) ? (__val_equal__ = Equal.getEqualFor(v)) : __val_equal__;
		var val = impl.search(
			function(l:Int,r:V){
				return __val_equal__(v,r);
			}.tupled()
		);
		return impl.remove(val.valOrC(null));
	}
	public function sort(){
		impl = ArrayOrder.sort(impl);
	}
	public function sortWith(fn:Ord<Tuple2<Int,V>>){
		impl = impl.sortWith(fn);
	}
	public function iterator():Iterator<Tuple2<Int,V>>{
		return impl.iterator();
	}
	private function lookup(key:Int):Option<Tuple2<Int,V>>{
		return impl.search(function(t){ return t.fst() == key; });
	}
	public function size(){
		return impl.length;
	}
	public function toString():String{
		var shw 	= null;
		var gsh 	= function(x) {return shw == null ? shw = Show.getShowFor(x) : shw;}

		var vals 	=
			impl.map(
				function(key:Int,val:V){
					return '$key : ${gsh(val)(val)}';
				}.tupled()
			);
		return vals.foldLeft('',
			function(memo:String,next:String){
				return Strings.concat(memo,'\n\t').concat(next);
			}
		);
	}
}
