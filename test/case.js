/**
 * Created with JetBrains WebStorm.
 * User: shilov_sa
 * Date: 08.08.13
 * Time: 17:10
 * To change this template use File | Settings | File Templates.
 */
{ // self tests
  group('Self-tests', window.location.hash !== '#system');
  test('0b success assert', function () {
    return true;
  });
  test('0b fail assert', function () {
    return false;
  });
  test('0b success trow except', {
    func:function () {
      throw new Error('check catch error');
    },
    mess:'check catch error',
    type:TEST_TYPE_ERROR
  });
  test('0b fail by except', {
    func:function () {
      throw new Error('check catch error');
    },
    type:TEST_TYPE_SUCCESS
  });
  test('0b success async', function (callback) {
    callback(true);
  });
  test('0b fail async', function (callback) {
    callback(false);
  });
  test('0b eq', eq([1,2,3], [1,2,3]));
  gEnd();
}
{ // Proto mod test
  group('Proto mod test');
  { // Function::bind
    group('Function::bind');
    test('2c Function::bind context only', function () { // 1
      var module, boundGetX, getX;
      module = {
        x:81,
        getX:function () {
          return this.x;
        }
      };
      getX = module.getX;
      if (getX() !== 81) {
        boundGetX = getX.bind(module);
        return boundGetX() === 81;
      }
      return false;
    });
    test('2c Function::bind context, arg in bind', function () { // 2
      var t, b, m = {
        a:1,
        s:function (b, c, d) {
          return this.a + b + c + d;
        }
      };
      t = m.s;
      b = t.bind(m, 2, 3, 4);
      return (1 + 2 + 3 + 4) === b();
    });
    test('2c Function::bind context, arg in bound', function () { // 3
      var t, b, m = {
        a:1,
        s:function (b, c, d) {
          return this.a + b + c + d;
        }
      };
      t = m.s;
      b = t.bind(m);
      return (1 + 2 + 3 + 4) === b(2, 3, 4);
    });
    test('2c Function::bind context, arg in bind and bound', function () { // 4
      var t, b, m = {
        a:1,
        s:function (b, c, d) {
          return this.a + b + c + d;
        }
      };
      t = m.s;
      b = t.bind(m, 2);
      return (1 + 2 + 3 + 4) === b(3, 4);
    });
    test('2c Function::bind exception', { // 5
      func:function () {
        var t, m = {
          a:1,
          s:function (b, c, d) {
            return this.a + b + c + d;
          }
        };
        t = m.s;
        return t.bind.call(m, 2);
      },
      mess:'',
      type:TEST_TYPE_ERROR
    });
    gEnd();
  }
  { // String::trim
    group('String::trim');
    test('2c String:trim empty', ''.trim() === '');
    test('2c String:trim to empty', '\t   \t'.trim() === '');
    test('2c String:trim ltrim', '    x'.trim() === 'x');
    test('2c String:trim rtrim', 'x       '.trim() === 'x');
    test('2c String:trim trim', '    x     '.trim() === 'x');
    test('2c String:trim tabs', ' \t   x  \t y \t '.trim() === 'x  \t y');
    gEnd();
  }
  { // String::replace
    group('String::replace');
    test('2c String::replace simple', 'test'.replace('t', 'b') === 'best');
    test('2c String::replace global', 'test'.replace('t', 'b', 'g') === 'besb');
    test('2c String::replace simple ignore case', 'test'.replace('T', 'b', 'i') === 'best');
    test('2c String::replace global ignore case', 'test'.replace('T', 'b', 'gi') === 'besb');
    test('2c String::replace simple, function', function () {
      return 'test'.replace('t', function () {
        if (arguments[0] === 't' && arguments[1] === 0) {
          return 'b';
        }
        return 'a';
      }) === 'best';
    });
    test('2c String::replace global, function', function () {
      return 'test'.replace('t', function () {
        if (arguments[0] === 't' && (arguments[1] === 0 || arguments[1] === 3)) {
          return 'b';
        }
        return 'a';
      }, 'g') === 'besb';
    });
    test('2c String::replace simple ignore case, function', function () {
      return 'test'.replace('T', function () {
        if (arguments[0] === 't' && arguments[1] === 0) {
          return 'b';
        }
        return 'a';
      }, 'i') === 'best';
    });
    test('2c String::replace global ignore case, function', function () {
      return 'test'.replace('T', function () {
        if (arguments[0] === 't' && (arguments[1] === 0 || arguments[1] === 3)) {
          return 'b';
        }
        return 'a';
      }, 'gi') === 'besb';
    });
    test('2c String::replace regexp simple', 'test'.replace(/t/, 'b') === 'best');
    test('2c String::replace regexp global', 'test'.replace(/t/g, 'b', 'g') === 'besb');
    test('2c String::replace regexp simple ignore case', 'test'.replace(/T/i, 'b', 'i') === 'best');
    test('2c String::replace regexp global ignore case', 'test'.replace(/T/gi, 'b', 'gi') === 'besb');
    test('2c String::replace regexp simple, function', function () {
      return 'test'.replace(/t/, function () {
        if (arguments[0] === 't' && arguments[1] === 0) {
          return 'b';
        }
        return 'a';
      }) === 'best';
    });
    test('2c String::replace regexp global, function', function () {
      return 'test'.replace(/t/g, function () {
        if (arguments[0] === 't' && (arguments[1] === 0 || arguments[1] === 3)) {
          return 'b';
        }
        return 'a';
      }, 'g') === 'besb';
    });
    test('2c String::replace regexp simple ignore case, function', function () {
      return 'test'.replace(/T/i, function () {
        if (arguments[0] === 't' && arguments[1] === 0) {
          return 'b';
        }
        return 'a';
      }, 'i') === 'best';
    });
    test('2c String::replace regexp global ignore case, function', function () {
      return 'test'.replace(/T/gi, function () {
        if (arguments[0] === 't' && (arguments[1] === 0 || arguments[1] === 3)) {
          return 'b';
        }
        return 'a';
      }, 'gi') === 'besb';
    });
    gEnd();
  }
  {// Array::forEach
    group('Array::forEach');
    test('2c Array:forEach simple', function () {
      var ret = true;
      [1,2,3,4].forEach( function(val, i){
        ret = (ret && i === val - 1);
      });
      return ret;
    });
    test('2c Array:forEach mod context', function () {
      var ret = true, a = {b:2}, arr = [1,2,3,4];
      arr.forEach( function(val, i, a){
        ret = (ret && (i === val - 1 && this.b === 2 && arr === a));
      }, a);
      return ret;
    });
    gEnd();
  }
  { // Array::take
    group('Array::take');
    test('2c Array::take array+array', function () {
      var i, l,
        ret = true,
        a1 = [1,2,3,4],
        a2 = [5,6,7,8];
      a1.take(a2);
      for (i = 0, l = a1.length; i < l; i++) {
        ret = (ret && i === a1[i] - 1);
      }
      return ret && a1.length === 8;
    });
    test('2c Array::take array+list', function () {
      var a, i, list, ret, ul, _i, _j;
      ul = document.createElement('ul');
      for (_i = 0; _i <= 4; _i++) {
        ul.appendChild(document.createElement('li'));
      }
      list = ul.getElementsByTagName('li');
      a = [].take(list);
      ret = true;
      for (i = _j = 0; _j <= 4; i = ++_j) {
        ret = ret && a[i] === list[i];
      }
      return ret && a.length === 5;
    });
    test('2c Array::take array+(Object|Number|Bool)', function () {
      var a = [1,2,3]
        , ret = true;
      ret = ret && a.take({}).length === 3;
      ret = ret && a.take(1).length === 3;
      return ret && a.take(true).length === 3;
    });
    test('2c Array::take array+String', function () {
      var i, l
        , s = 'string'
        , a = [].take(s)
        , ret = true;
      for (i = 0, l = a.length; i < l; i++) {
        ret = ret && a[i] === s[i];
      }
      return ret && a.length === 6;
    });
    test('2c Array:take except empty', {
      mess: '',
      type: TEST_TYPE_ERROR,
      func:function () {
        return [].take();
      }
    });
    test('2c Array:take except null', {
      mess: '',
      type: TEST_TYPE_ERROR,
      func:function () {
        return [].take(null);
      }
    });
    gEnd();
  }
  { // Array:del
    group('Array::del');
    test('2c Array::del delete', [1].del(0).length === 0);
    test('2c Array::del delete negative', function () {
      var a = [1,2];
      return a.del(-1).length === 1 && a[0] === 1;
    });
    test('2c Array::del delete no index', function () {
      var a = [1,2];
      return a.del().length === 1 && a[0] === 2;
    });
    gEnd();
  }
  { // window.setImmediate
    group('window.setImmediate');
    test('2c window.setImmediate', function (callback) {
      window.setImmediate(function(){
        callback(true);
      });
    });
    gEnd();
  }
  gEnd();
  { // HSF functions
    group('HSF functions');
    // getThis
    test('2c f.getThis call f', eval(f.getThis()) === f);
    test('2c f.getThis call method', eval(f.getThis() + '.GBI') === f.GBI);
    { // Get children
      group('Get children');
      // GBI
      test('1c f.GBI simple', function () {
        return document.getElementById('testBlock') === f.GBI('testBlock');
      });
      test('1c f.GBI no exists => null', function () {
        return document.getElementById('unknownBlock') == f.GBI('unknownBlock');
      });
      // GBT
      test('1c f.GBT simple', seq(f.GBT('s'), document.getElementsByTagName('s')));
      test('1c f.GBT in context', function () {
        var tb = document.getElementById('testBlock');
        return seq(f.GBT('s', tb), tb.getElementsByTagName('s'))
      });
      test('1c f.GBT no exists', f.GBT('sas').length === 0 && 0 === document.getElementsByTagName('sas').length);
      // GBC
      test('1c f.GBC simple', seq(f.GBC('sTest'), document.getElementsByTagName('s')));
      test('1c f.GBC in context', function () {
        var tb = document.getElementById('testBlock');
        return seq(f.GBC('sTest', tb), tb.getElementsByTagName('s'))
      });
      test('1c f.GBC no exists', f.GBC('sas').length === 0);
      gEnd();
    }
    { // Get parent
      group('Get parent');
      // GPC
      test('1c f.GPC parentNode', f.GPC(document.getElementsByTagName('s')[0], 'testBlock') === document.getElementById('testBlock'));
      test('1c f.GPC closest', f.GPC(document.getElementById('testItalic'), 'testBlock') === document.getElementById('testBlock'));
      test('1c f.GPC empty parent have\'t class', f.GPC(document.getElementById('testBlock'), '') === document.getElementById('testBlock').parentNode);
      test('1c f.GPC empty parent of papent have\'t class', f.GPC(document.getElementById('testItalic'), '') === document.getElementById('testItalic').parentNode.parentNode);
      test('1c f.GPC no exists class', f.GPC(document.getElementById('testBlock'), 'abrakadabra') == null);
      test('1c f.GPC no exists el', f.GPC(null, 'abrakadabra') == null);
      test('1c f.GPC no exists el and class', f.GPC() == null);
      // GPT
      test('1c f.GPT parentNode', f.GPT(document.getElementById('testItalic'), 'i') === document.getElementById('testItalic').parentNode);
      test('1c f.GPT closest', f.GPT(document.getElementById('testItalic'), 'div') === document.getElementById('testBlock'));
      test('1c f.GPT empty className', f.GPT(document.getElementById('testItalic'), '') === null);
      test('1c f.GPT no el', f.GPT(null, '') === null);
      test('1c f.GPT no el and class', f.GPT(document.getElementById('testItalic')) === null);
      test('1c f.GPT no args', f.GPT() === null);
      gEnd();
    }
    { // Work width vars
      group('Work width vars');
      // toSource
      test('2c f.toSource simple String', f.toSource('sas') === '"sas"');
      test('2c f.toSource simple Number', f.toSource(10.5) === '10.5');
      test('2c f.toSource simple Boolean', f.toSource(true) === 'true');
      test('2c f.toSource simple Undefined', f.toSource() === 'undefined');
      test('2c f.toSource simple Object', f.toSource({}) === '{\n}');
      test('2c f.toSource simple Array', f.toSource([]) === '[\n]');
      test('2c f.toSource part recursive', f.toSource({a:1,b:1,c:3,d:[1,2,3],e:'sasd',f:{1:'1',2:'2',3:{a:4,b:true,c:false}}}, 1) === '{\n  a: 1,\n  b: 1,\n  c: 3,\n  d: [\n    1,\n    2,\n    3\n  ],\n  e: "sasd",\n  f: {\n    1: "1",\n    2: "2",\n    3: [object Object]\n  }\n}');
      test('2c f.toSource full recursive', f.toSource({a:1,b:1,c:3,d:[1,2,3],e:'sasd',f:{1:'1',2:'2',3:{a:4,b:true,c:false}}}, 2) === '{\n  a: 1,\n  b: 1,\n  c: 3,\n  d: [\n    1,\n    2,\n    3\n  ],\n  e: "sasd",\n  f: {\n    1: "1",\n    2: "2",\n    3: {\n      a: 4,\n      b: true,\n      c: false\n    }\n  }\n}');
      // oSize
      test('2c f.oSize simple empty object', f.oSize({}) === 0);
      test('2c f.oSize simple non-empty object', f.oSize({k:2}) === 1);
      test('2c f.oSize simple empty array', f.oSize([]) === 0);
      test('2c f.oSize simple non-empty array', f.oSize([1,2,3]) === 3);
      test('2c f.oSize string by new', f.oSize(new String('123')) === 3);
      test('2c f.oSize number by new', f.oSize(new Number('123')) === 0);
      test('2c f.oSize boolean by new', f.oSize(new Boolean('123')) === 0);
      test('2c f.oSize string without new', f.oSize('123') === 3);
      test('2c f.oSize number without new', {
        type: TEST_TYPE_ERROR,
        mess: '',
        func: function(){
          f.oSize(123);
        }
      });
      test('2c f.oSize boolean without new', {
        type: TEST_TYPE_ERROR,
        mess: '',
        func: function(){
          f.oSize(true);
        }
      });
      test('2c f.oSize function', {
        type: TEST_TYPE_ERROR,
        mess: '',
        func: function(){
          f.oSize(function(){return true;});
        }
      });
      // oKeys
      test('2c f.oKeys simple empty object',      eq(f.oKeys({}), []));
      test('2c f.oKeys simple non-empty object',  eq(f.oKeys({k:2}), ['k']));
      test('2c f.oKeys simple empty array',       eq(f.oKeys([]), []));
      test('2c f.oKeys simple non-empty array',   eq(f.oKeys([1,2,3]), ["0", "1", "2"]));
      test('2c f.oKeys string by new',            eq(f.oKeys(new String('123')), ["0", "1", "2"]));
      test('2c f.oKeys number by new',            eq(f.oKeys(new Number('123')), []));
      test('2c f.oKeys boolean by new',           eq(f.oKeys(new Boolean('123')), []));
      test('2c f.oKeys string without new',       eq(f.oKeys('123'), ["0", "1", "2"]));
      test('2c f.oKeys number without new', {
        type: TEST_TYPE_ERROR,
        mess: '',
        func: function(){
          f.oKeys(123);
        }
      });
      test('2c f.oKeys boolean without new', {
        type: TEST_TYPE_ERROR,
        mess: '',
        func: function(){
          f.oKeys(true);
        }
      });
      test('2c f.oKeys function', {
        type: TEST_TYPE_ERROR,
        mess: '',
        func: function(){
          f.oKeys(function(){return true;});
        }
      });
      // merge
      test('2c f.merge simple object', eq(f.merge({}, {}), {}));
      test('2c f.merge to left', eq(f.merge({}, {c:3, d: 4}), {c:3, d: 4}));
      test('2c f.merge by left', eq(f.merge({a:1, b:2}, {}), {a:1, b:2}));
      test('2c f.merge objects 1-level', eq(f.merge({a:1, b:2}, {c:3, d: 4}), {a:1, b:2, c:3, d: 4}));
      test('2c f.merge objects many-level', eq(f.merge({a:1,b:2},{c:3,d:4,e:{a:1}}), {a:1, b:2, c:3, d: 4, e:{a:1}}));
      test('2c f.merge arrays', eq(f.merge([1,2,3,4], [4,5]), [4,5,3,4]));
      test('2c f.merge hard merge', eq(f.merge({
        a: 1,
        b: [1, 2, 3, 4],
        c: {
          d: 1,
          e: 2,
          f: [1, 2, {
            a: 1,
            b: 2,
            c: 3
          }]
        }
      }, {
        h: 4,
        b: [5, 6],
        c: {
          g: 3,
          h: 4,
          f: [1, 2, {
            a: 3,
            b: 4,
            d: 5
          }]
        }
      }), {
        a: 1,
        b: [5, 6, 3, 4],
        h: 4,
        c: {
          d: 1,
          e: 2,
          g: 3,
          h: 4,
          f: [1, 2, {
            a: 3,
            b: 4,
            c: 3,
            d: 5
          }]
        }
      }));
      // JSON stringify
      test('2c f.varToJSON null', f.varToJSON(null) === 'null');
      test('2c f.varToJSON ""', f.varToJSON('') === '""');
      test('2c f.varToJSON 12.5', f.varToJSON(12.5) === '12.5');
      test('2c f.varToJSON true', f.varToJSON(true) === 'true');
      test('2c f.varToJSON {}', f.varToJSON({}) === '{}');
      test('2c f.varToJSON []', f.varToJSON([]) === '[]');
      test('2c f.varToJSON complex array', f.varToJSON([null,"",12.5,true,{}]) === '[null,"",12.5,true,{}]');
      test('2c f.varToJSON complex object', f.varToJSON({a:null,b:'',c:12.5,d:true,e:[]}) === '{"a":null,"b":"","c":12.5,"d":true,"e":[]}');
      test('2c f.varToJSON object', f.varToJSON({
        a: 1,
        b: [5, 6, 3, 4],
        h: 4,
        c: {
          d: 1,
          e: 2,
          g: 3,
          h: 4,
          f: [1, 2, {
            a: 3,
            b: 4,
            c: 3,
            d: 5
          }]
        }
      }) === '{"a":1,"b":[5,6,3,4],"h":4,"c":{"d":1,"e":2,"g":3,"h":4,"f":[1,2,{"a":3,"b":4,"c":3,"d":5}]}}');
      // JSON parse
      test('2c f.parseJSON null', f.parseJSON('null') === null);
      test('2c f.parseJSON ""', f.parseJSON('""') === '');
      test('2c f.parseJSON 12.5', f.parseJSON('12.5') === 12.5);
      test('2c f.parseJSON true', f.parseJSON('true') === true);
      test('2c f.parseJSON {}', eq(f.parseJSON('{}'), {}));
      test('2c f.parseJSON []', eq(f.parseJSON('[]'), []));
      test('2c f.parseJSON complex array', eq(f.parseJSON('[null,"",12.5,true,{}]'), [null,"",12.5,true,{}]));
      test('2c f.parseJSON complex object', eq(f.parseJSON('{"a":null,"b":"","c":12.5,"d":true,"e":[]}'), {a:null,b:'',c:12.5,d:true,e:[]}));
      test('2c f.parseJSON object', eq(f.parseJSON('{"a":1,"b":[5,6,3,4],"h":4,"c":{"d":1,"e":2,"g":3,"h":4,"f":[1,2,{"a":3,"b":4,"c":3,"d":5}]}}'), {
        a: 1,
        b: [5, 6, 3, 4],
        h: 4,
        c: {
          d: 1,
          e: 2,
          g: 3,
          h: 4,
          f: [1, 2, {
            a: 3,
            b: 4,
            c: 3,
            d: 5
          }]
        }
      }));
      // toInt
      test('2c f.toInt number', f.toInt(0) === 0);
      test('2c f.toInt number', f.toInt(10) === 10);
      test('2c f.toInt number', f.toInt(10.956) === 10);
      test('2c f.toInt number', f.toInt(10.112) === 10);
      test('2c f.toInt string', f.toInt('0') === 0);
      test('2c f.toInt string', f.toInt('10') === 10);
      test('2c f.toInt true',   f.toInt(true) === 1);
      test('2c f.toInt false',  f.toInt(false) === 0);
      test('2c f.toInt object', f.toInt({}) === 0);
      test('2c f.toInt number with e',  f.toInt('12.35e5') === 1235000);
      test('2c f.toInt number with e+', f.toInt('12.35e+5') === 1235000);
      test('2c f.toInt number with e-', f.toInt('1200e-2') === 12);
      test('2c f.toInt number with E',  f.toInt('12.35E5') === 1235000);
      test('2c f.toInt number with E+', f.toInt('12.35E+5') === 1235000);
      test('2c f.toInt number with E-', f.toInt('1200E-2') === 12);
      // toFloat
      test('2c f.toFloat number', f.toFloat(0) === 0);
      test('2c f.toFloat number', f.toFloat(10) === 10);
      test('2c f.toFloat number', f.toFloat(10.956) === 10.956);
      test('2c f.toFloat number', f.toFloat(10.112) === 10.112);
      test('2c f.toFloat string', f.toFloat('0') === 0);
      test('2c f.toFloat string', f.toFloat('10.956') === 10.956);
      test('2c f.toFloat true',   f.toFloat(true) === 1);
      test('2c f.toFloat false',  f.toFloat(false) === 0);
      test('2c f.toFloat object', f.toFloat({}) === 0);
      test('2c f.toFloat number with e',  f.toFloat('0.003e2') === 0.3);
      test('2c f.toFloat number with e+', f.toFloat('0.003e+2') === 0.3);
      test('2c f.toFloat number with e-', f.toFloat('0.003e-2') === 0.00003);
      test('2c f.toFloat number with E',  f.toFloat('0.003E2') === 0.3);
      test('2c f.toFloat number with E+', f.toFloat('0.003E+2') === 0.3);
      test('2c f.toFloat number with E-', f.toFloat('0.003E-2') === 0.00003);
      // mLog
      test('2c f.mLog ln e', f.mLog(Math.E) === 1);
      test('2c f.mLog ln 1', f.mLog(1) === 0);
      test('2c f.mLog log 10', f.mLog(10, 10) === 1);
      test('2c f.mLog log 100', f.mLog(100, 10) === 2);
      test('2c f.mLog log 1000000', f.mLog(1000000, 10) === 6);
      test('2c f.mLog log 2, 2', f.mLog(2, 2) === 1);
      test('2c f.mLog log 2, 4', f.mLog(4, 2) === 2);
      test('2c f.mLog log 2, 1024', f.mLog(1024, 2) === 10);
      test('2c f.mLog hard calc', f.mLog(181.019335983756182, 8) === 2.5);
      // md5
      test('2c f.md5 ""', f.md5('') === 'd41d8cd98f00b204e9800998ecf8427e');
      test('2c f.md5 "123"', f.md5('123') === '202cb962ac59075b964b07152d234b70');
      test('2c f.md5 "abc"', f.md5('abc') === '900150983cd24fb0d6963f7d28e17f72');
      test('2c f.md5 symbols', f.md5('!&^&*@^(*$&)(%$$^$}{:"<?><') === '6cebd516ac821a24cf7e669117711adf');
      test('2c f.md5 long string', f.md5('bfx89I6SqNqUuphtxv7wV6lAj5j4qOiCaV8AuZOI6NnUvyOo3xuDUQHFEa6jNzXr47aquebvab9Fytwqb9WasbAkFRERaj5wrJrY') === '109f2df7548eb13a9a817f4505909d0a');
      // random
      test('2c f.random 0, 1', function(){
        var i, r, ret = true, o = false, s = false;
        for(i=0; i < 100000; i++) {
          r = f.random(0, 1);
          ret = ret && (r === 0 || r === 1);
          if (r === 0) {
            o = true;
          } else {
            s = true;
          }
        }
        return ret && o && s;
      });
      test('2c f.random 0, 50', function(){
        var i, r, ret = true, o = false, s = false;
        for(i=0; i < 100000; i++) {
          r = f.random(0, 50);
          ret = ret && (r >= 0 || r <= 50);
          if (r === 0) {
            o = true;
          } else if (r === 50) {
            s = true;
          }
        }
        return ret && o && s;
      });
      test('2c f.random -1, 0', function(){
        var i, r, ret = true, o = false, s = false;
        for(i=0; i < 100000; i++) {
          r = f.random(-1, 0);
          ret = ret && (r === 0 || r === -1);
          if (r === 0) {
            o = true;
          } else {
            s = true;
          }
        }
        return ret && o && s;
      });
      test('2c f.random -50, 0', function(){
        var i, r, ret = true, o = false, s = false;
        for(i=0; i < 100000; i++) {
          r = f.random(-50, 0);
          ret = ret && (r <= 0 || r >= -50);
          if (r === 0) {
            o = true;
          } else if (r === -50) {
            s = true;
          }
        }
        return ret && o && s;
      });
      test('2c f.random -25, 25', function(){
        var i, r, ret = true, o = false, s = false;
        for(i=0; i < 100000; i++) {
          r = f.random(-25, 25);
          ret = ret && (r <= 25 || r >= -25);
          if (r === 25) {
            o = true;
          } else if (r === -25) {
            s = true;
          }
        }
        return ret && o && s;
      });
      // f.zeroFill
      test('1c f.zeroFill 001', f.zeroFill(1, 3) === '001');
      test('1c f.zeroFill 100', f.zeroFill(100, 3) === '100');
      test('1c f.zeroFill 100, 1', f.zeroFill(100, 1) === '100');
      test('1c f.zeroFill 0.1', f.zeroFill(0.1, 4) === '00.1');
      test('1c f.zeroFill 0.1', f.zeroFill(.1, 4) === '00.1');
      test('1c f.zeroFill 0.01', f.zeroFill(.01, 4) === '0.01');
      test('1c f.zeroFill 0.321312', f.zeroFill(.321312, 4) === '0.321312');
      test('1c f.zeroFill 321', f.zeroFill(321, 5) === '00321');
      // f.truncateStringMin
      test('1c f.truncateStringMin simple truncate', f.truncateStringMin('123456', 3) === '...');
      test('1c f.truncateStringMin simple none truncate', f.truncateStringMin('123456', 6) === '123456');
      test('1c f.truncateStringMin simple width truncate', f.truncateStringMin('1234567', 6) === '123...');
      test('1c f.truncateStringMin custom after, none', f.truncateStringMin('1234567', 7, 'AAAA') === '1234567');
      test('1c f.truncateStringMin custom after', f.truncateStringMin('123456', 5, 'AAAA') === '1AAAA');
      // f.truncateString
      test('1c f.truncateString, simple', f.truncateString('abc', 3) === 'abc');
      test('1c f.truncateString, simple2', f.truncateString('abc', 4) === 'abc');
      test('1c f.truncateString, big string, after cleared', f.truncateString('abc', 2) === '..');
      test('1c f.truncateString, big string, after full', f.truncateString('abcd', 3) === '...');
      test('1c f.truncateString, ab| cd', f.truncateString('ab cd', 3, 5) === 'ab...');
      test('1c f.truncateString, ab| cd_ef gh', f.truncateString('ab cd_ef gh', 5, 8) === 'ab...');
      test('1c f.truncateString, ab cd| ef gh', f.truncateString('ab cd ef gh', 6, 8) === 'ab cd...');
      test('1c f.truncateString, ab cd ef| gh', f.truncateString('ab cd ef gh', 10, 12) === 'ab cd ef...');
      test('1c f.truncateString, ab cd| ef_gh', f.truncateString('ab cd ef_gh', 10, 12) === 'ab cd...');
      test('1c f.truncateString, ab cd ef| gh', f.truncateString('ab cd ef gh', 10, 12) === 'ab cd ef...');
      // f.truncateString width change after
      test('1c f.truncateString, width change after simple', f.truncateString('abc', 3, 3, 'aaa') === 'abc');
      test('1c f.truncateString, width change after simple2', f.truncateString('abc', 4, 4, 'aaa') === 'abc');
      test('1c f.truncateString, width change after big string, after cleared', f.truncateString('abc', 2, 2, 'aaa') === 'aa');
      test('1c f.truncateString, width change after big string, after full', f.truncateString('abcd', 3, 3, 'aaa') === 'aaa');
      test('1c f.truncateString, width change after ab| cd', f.truncateString('ab cd', 3, 5, 'aaa') === 'abaaa');
      test('1c f.truncateString, width change after ab| cd_ef gh', f.truncateString('ab cd_ef gh', 5, 8, 'aaa') === 'abaaa');
      test('1c f.truncateString, width change after ab cd| ef gh', f.truncateString('ab cd ef gh', 6, 8, 'aaa') === 'ab cdaaa');
      test('1c f.truncateString, width change after ab cd ef| gh', f.truncateString('ab cd ef gh', 10, 12, 'aaa') === 'ab cd efaaa');
      test('1c f.truncateString, width change after ab cd| ef_gh', f.truncateString('ab cd ef_gh', 10, 12, 'aaa') === 'ab cdaaa');
      test('1c f.truncateString, width change after ab cd ef| gh', f.truncateString('ab cd ef gh', 10, 12, 'aaa') === 'ab cd efaaa');
      // f.getCharWidthMax
      test('1c f.getCharWidthMax, no args', function () {
        var w = f.getCharWidthMax();
        return w != null && w === f.getCharWidthMax();
      });
      test('1c f.getCharWidthMax, set font size', function () {
        var w = f.getCharWidthMax(16);
        return w != null && w === f.getCharWidthMax(16);
      });
      test('1c f.getCharWidthMax, set font size and font famaly', function () {
        var w = f.getCharWidthMax(16, 'Arial, "Helvetica CY", "Nimbus Sans L", sans-serif');
        return w != null && w === f.getCharWidthMax(16, 'Arial, "Helvetica CY", "Nimbus Sans L", sans-serif');
      });
      test('1c f.getCharWidthMax, all args, latin', function () {
        var w = f.getCharWidthMax(16, 'Arial, "Helvetica CY", "Nimbus Sans L", sans-serif', 'M');
        return w != null && w === f.getCharWidthMax(16, 'Arial, "Helvetica CY", "Nimbus Sans L", sans-serif', 'M');
      });
      test('1c f.getCharWidthMax, all args, ru', function () {
        var w = f.getCharWidthMax(16, 'Arial, "Helvetica CY", "Nimbus Sans L", sans-serif', 'Щ');
        return w != null && w === f.getCharWidthMax(16, 'Arial, "Helvetica CY", "Nimbus Sans L", sans-serif', 'Щ');
      });
      // f.getCharWidth
      test('1c f.getCharWidth, no args', function () {
        var w = f.getCharWidth();
        return w != null && w === f.getCharWidth();
      });
      test('1c f.getCharWidth, set font size', function () {
        var w = f.getCharWidth(16);
        return w != null && w === f.getCharWidth(16);
      });
      test('1c f.getCharWidth, set font size and font famaly', function () {
        var w = f.getCharWidth(16, 'Arial, "Helvetica CY", "Nimbus Sans L", sans-serif');
        return w != null && w === f.getCharWidth(16, 'Arial, "Helvetica CY", "Nimbus Sans L", sans-serif');
      });
      test('1c f.getCharWidth, all args, latin', function () {
        var w = f.getCharWidth(16, 'Arial, "Helvetica CY", "Nimbus Sans L", sans-serif', 'M');
        return w != null && w === f.getCharWidth(16, 'Arial, "Helvetica CY", "Nimbus Sans L", sans-serif', 'M');
      });
      test('1c f.getCharWidth, all args, ru', function () {
        var w = f.getCharWidth(16, 'Arial, "Helvetica CY", "Nimbus Sans L", sans-serif', 'Щ');
        return w != null && w === f.getCharWidth(16, 'Arial, "Helvetica CY", "Nimbus Sans L", sans-serif', 'Щ');
      });
      // f.dateToFormat
      test('1c f.dateToFormat simple date width time', f.dateToFormat((new Date(2000, 0, 1)), '%d.%m.%y %h:%i:%s') === '01.01.2000 00:00:00');
      test('1c f.dateToFormat simple date width time simpled', f.dateToFormat((new Date(2000, 0, 1)), '%D.%M.%Y %H:%I:%S') === '1.1.00 0:0:0');
      test('1c f.dateToFormat masked percent', f.dateToFormat((new Date(2000, 0, 1)), "%%%d %% %%_") === "%01 % %_");
      test('1c f.dateToFormat date width local names', f.dateToFormat((new Date(2000, 0, 1)), '%l, %d %f %y %h:%i:%s') === f._dateNames.weekShort[5] + ', 01 '+f._dateNames.monthShort[0]+' 2000 00:00:00');
      test('1c f.dateToFormat other local names', f.dateToFormat((new Date(2000, 0, 1)), '%L %F %z %a %A') === f._dateNames.weekFull[5] + ' ' + f._dateNames.monthFull[0] + ' 1 am AM');
      test('1c f.dataToFormat unix time', function () {
        var t = parseInt(f.dateToFormat(new Date(2000, 0, 1, 15), '%u')),
          t2 = parseInt(f.dateToFormat(new Date(2000, 0, 1, 15), '%U'));
        return t2 / t === 1000;
      });
      test('1c f.dateToFormat full test', f.dateToFormat((new Date(2000, 0, 1, 15)),
        '%d %D %w %l %L %m %M %f %F %y %Y %a %A %g %G %h %H %i %I %s %S %p %P %z') ===
        '01 1 6 '+ f._dateNames.weekShort[5] + ' ' + f._dateNames.weekFull[5] + ' 01 1 ' + f._dateNames.monthShort[0] + ' ' + f._dateNames.monthFull[0] + ' 2000 00 pm PM 03 3 15 15 00 0 00 0 000 0 1');
    }
  }
}











