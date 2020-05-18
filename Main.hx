package ;

#if (test=="stx_ds")
  import stx.ds.test.*;
#end

using stx.Core;
using stx.Assert;


class Main {
	static function main() {
		#if test
			utest.UTest.run(
				[new SetTest()]
			);
		#end
	}
}