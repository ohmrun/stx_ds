package ;

import stx.assert.pack.Comparable;
using stx.Tuple;
using stx.core.Lift;
using stx.assert.Lift;

import stx.ds.Package;
import stx.ds.Package.RoseTree;

import utest.ui.Report;
import utest.Runner;
import utest.Test;
using utest.Assert;

import stx.ds.pack.XerSet;

class Main {
	static public var orig : Float = haxe.Timer.stamp();
	static function main() {
		trace("main");
		var r = new Runner();
				//r.addCase(new BranchTest());
				//r.addCase(new test.stx.ds.SetTest());
				r.addCase(new XerSetTest());
		Report.create(r);
				r.run();
	}
}
class BranchTest extends Test{
	public function test(){
		var a = Set.create((l,r) -> l < r,(l,r) -> l == r);
				a = a.put(1).put(2);

		for(v in a){
			trace(v);
		}
		trace(a.has(1));
		trace(a.has(9));
	}
}
class XerSetTest extends Test{
	public function test(){
		trace("test xerset");
		var a = XerSet.makeKV(key(),val());
				a = a.setVal("hello",1);
				trace(a.hasKey("hello"));
				trace(a.hasKey("nope"));
				trace(a.hasLeaf(1));
				trace(a.hasLeaf(20));
		var b = XerSet.makeKV(key(),val());
				b = b.setVal("hello",99);
				trace(a);
		var c = a.keyspace().union(b);
		trace(c.hasLeaf(99));
		var d = a.setspace().union(b);
		var e = c.setspace().difference(d);
		trace(e);
		var f = d.difference(c);
		trace(f);
	}
	static public function key(){
		return __.assert().comparable().string();
	}
	static public function val(){
		return __.assert().comparable().int();
	}
}