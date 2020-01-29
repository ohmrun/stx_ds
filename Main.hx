package ;

import stx.assert.pack.Comparable;

using stx.core.Lift;
using stx.assert.Lift;

import stx.ds.Package;

import utest.ui.Report;
import utest.Runner;
import utest.Test;
using utest.Assert;

class Main {
	static function main() {
		#if test
			utest.UTest.run(cast stx.ds.Package.tests());
		#end
	}
}