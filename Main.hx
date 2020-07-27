package ;

#if (test=="stx_ds")
  import stx.ds.test.*;
#end


class Main {
	static function main() {
		#if (test=="stx_ds")
			utest.UTest.run(
				[new SetTest()]
			);
		#end
	}
}