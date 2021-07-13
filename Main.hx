package ;

using stx.Nano;
using stx.Test;

#if (test=="stx_ds")
  import stx.ds.test.*;
#end


class Main {
	static function main() {
		#if (test=="stx_ds")
			__.test(
				[new SetTest()],
				[]
			);
		#end
	}
}