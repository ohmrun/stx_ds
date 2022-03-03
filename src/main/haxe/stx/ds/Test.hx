package stx.ds;

#if (test=="stx_ds")
  import stx.ds.test.*;
#end

class Package{
  static public function main():Array<TestCase>{
    return [
      new SetTest()
    ];
  }
}