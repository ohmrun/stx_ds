class GraphTest2 {
  var log : stx.Log;
  public function new(log){
    this.log = log;
  }
  public function graph(){
    var lctx = Context([tuple2("left",2),tuple2("up",3)],1,"a",[tuple2("right",2)]);
    var mctx = Context([],2,"b",[tuple2("down",3)]);
    var rctx = Context([],3,"c",[]);

    var g = new Graph();
    var g1 = g.with(rctx);
    var g2 = g1.with(mctx);
    var g3 = g2.with(lctx);

    log.info(g3);

    return g3;
  }
  public function testNodes(){
    var g = graph();
    same([3,2,1],g.nodes());
  }
  public function testGSuc(){
    var g = graph();
    log(g);
    var o0 = g.gsuc(1);
      log('g.gsuc(1) $o0');
    same([2],o0);
    var o0 = g.gsuc(2);
      log('g.gsuc(2) $o0');
    same([1,3],o0);
    var o0 = g.gsuc(3);
      log('g.gsuc(3) $o0');
    same([2],o0);
      /**
    log("------reverse-------");

    var g = graph().grev();
    log(g);
    var o0 = g.gsuc(1);
      log('g.gsuc(1) $o0');

    var o0 = g.gsuc(2);
      log('g.gsuc(2) $o0');

    var o0 = g.gsuc(3);
      log('g.gsuc(3) $o0');
      */
  }
  public function initial(){
    var node : Node = 1;
    var o = node.label("first");
    var node0 : Node = 2;
    var o0 = node0.label("second");
    var o1 = o.and(o0);
    var node1 : Node = 3;
    var o2 = o1.from(node1).withData("hello");
  }
  public function testSnip1(){
    var g = graph();

    var o3 = g.snip(1);
    same([3,2],o3.snd().nodes());
  }
  public function testSnip2(){
    var g = graph();
    var o4 = g.snip(2);

    same([3,1],o4.snd().nodes());
  }
  public function testSnip3(){
    var g = graph();
    var o5 = g.snip(3);
    same([2,1],o5.snd().nodes());
  }
  public function testBuild(){
    var lctx = Context([tuple2("left",2),tuple2("up",3)],1,"a",[tuple2("right",2)]);
    var mctx = Context([],2,"b",[tuple2("down",3)]);
    var rctx = Context([],3,"c",[]);

    var a = function(){
          var g = new Graph();
          var g0 = g.with(rctx);
          var g1 = g0.with(mctx);
          var g2 = g1.with(lctx);
        }
    a();
    pass();
  }
  public function testBuildFail(){
    var lctx = Context([tuple2("left",2),tuple2("up",3)],1,"a",[tuple2("right",2)]);
    var mctx = Context([],2,"b",[tuple2("down",3)]);
    var rctx = Context([],3,"c",[]);

    var g = new Graph();
    raises(
        function(){
          var g1 = g.with(lctx);

          log(g1);
          var g2 = g1.with(mctx);
          log(g2);
          var g3 = g2.with(rctx);
          log(g3);

          log.info(g3);
        }
    );

  }
  public function explodeObject(o):Context<KeyOrVal,String>{
    var ids     = new UniqueIdGen();
    var obj_key = ids.next();
    var keys    = stx.Reflects.fields(o);

    var out : Adj<KeyOrVal> = keys.flatMap(
      function(key,val){
        var key_node = ids.next();
        var key_edge = new Edge(tuple2(Key(key),key_node));
        var val_node = ids.next();
        var val_edge = new Edge(tuple2(Val(val),val_node));
        var adj = new Adj().and(key_edge).and(val_edge);

        //var fld_ctx  = new Context().withOutgoing(adj);
        return adj;
      }.tupled()
    ).toArray();
    //return stx.Context.create([],obj_key,o,out);
    return null;
  }
  public function testWith(){
    var lctx = Context([tuple2("left",2),tuple2("up",3)],1,"a",[tuple2("right",2)]);
    var mctx = Context([],2,"b",[tuple2("down",3)]);
    var rctx = Context([],3,"c",[]);

    var _0 = new Graph().with(rctx);
    var _1 = _0.with(mctx);
    var _2 = _1.with(lctx);

    pass();
  }
  public function testGRev(){
    var log = new Log();
    var a = graph();
    var b = a.grev();
    log(a);
    log(b);
  }
  public function testDFS(){
    var g0 = graph0();
    var a : Node = 1;
    var b : Node = 2;
    var c : Node = 3;
    var g : Node = 7;
    var h : Node = 8;

    var arr = [a];
        same([1,2,4,5,3,6,7],g0.dfs(arr));
        same([1,2,3,4,5,6,7],g0.bfs(arr));

  }

  public function graph0(){
    var a : Node = 1;
    var b : Node = 2;

    var c : Node = 3;

    var d : Node = 4;
    var e : Node = 5;

    var f : Node = 6;
    var g : Node = 7;

    var h : Node = 8;

    var i : Node = 9;
    var j : Node = 10;

    var ctx_h = stx.Context.create([],h,null,[]);
    var ctx_i = stx.Context.create([],i,null,[]);

    var ctx_f = stx.Context.create([],f,null,[]);
    var ctx_g = stx.Context.create([],g,null,[]);

    var ctx_d = stx.Context.create([],d,null,[]);
    var ctx_e = stx.Context.create([],e,null,[]);

    var ctx_c = stx.Context.create([],c,null,[f,g]);
    var ctx_b = stx.Context.create([],b,null,[d,e]);

    var ctx_a = stx.Context.create([],a,null,[b,c]);


    var g0 =
      new Graph()
        .with(ctx_i)
        .with(ctx_h)
        .with(ctx_f)
        .with(ctx_g)
        .with(ctx_d)
        .with(ctx_e)
        .with(ctx_b)
        .with(ctx_c)
        .with(ctx_a);

    return g0;
  }
  public function testGraph0(){
    var g = graph0();
    pass();
  }
}
class UniqueIdGen{
  private static var idx : Int;
  static function __init__(){
    idx = 0;
  }
  public function new(){}
  public function next():Int{
    var out = idx;
    idx = idx + 1;
    return out;
  }
}
enum KeyOrVal{
    Key(k:String);
    Val(v:Dynamic);
}
