/**
 * Created with JetBrains WebStorm.
 * User: shilov_sa
 * Date: 08.08.13
 * Time: 17:10
 * To change this template use File | Settings | File Templates.
 */
(function (window) {
  window.f.log('start');
  var _h, dirs, i, l, dir, d,
    h = {},
    hash = function (prop) {
      if (prop in h) {
        return h[prop];
      }
      return null;
  };
  _h = window.location.hash;
  if (_h.length > 0) {
    if (_h.charAt(0) === '#') {
      _h = _h.substr(1);
    }
    dirs = _h.split('&');
    for (i = 0, l = dirs.length; i < l; i++) {
      dir = dirs[i];
      if (dir.indexOf('=') > 0) {
        d = dir.split('=');
        h[decodeURI(d[0])] = decodeURI(d[1]);
      } else {
        h[decodeURI(dir)] = true;
      }
    }
  }
  window.hash = hash;
}).call(this, window);

{ // self tests
  group('Self-tests', !hash('system'));
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
      // QSA
      test('1c f.QSA', seq(f.QSA('#testBlock.testBlock > s'), document.getElementById('testBlock').getElementsByTagName('s')));
      test('1c f.QSA no exists', f.QSA('#testBlock.testBlock > .glue').length === 0);
      test('1c f.qsa', seq(f.qsa('#testBlock.testBlock > s'), document.getElementById('testBlock').getElementsByTagName('s')));
      test('1c f.qsa no exists', f.qsa('#testBlock.testBlock > .glue').length === 0);
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
      var baseDate = new Date(2000, 0, 1); //sometime this return 01.01.2000 03:00:00 It's bad, but not critical
      baseDate.setHours(0);
      baseDate.getNew = function () {
        return new Date(this);
      };
      test('1c f.dateToFormat simple date width time'+f.dateToFormat(baseDate.getNew(), '%d.%m.%y %h:%i:%s'), f.dateToFormat(baseDate.getNew(), '%d.%m.%y %h:%i:%s') === '01.01.2000 00:00:00');
      test('1c f.dateToFormat simple date width time simpled', f.dateToFormat(baseDate.getNew(), '%D.%M.%Y %H:%I:%S') === '1.1.00 0:0:0');
      test('1c f.dateToFormat masked percent', f.dateToFormat(baseDate.getNew(), "%%%d %% %%_") === "%01 % %_");
      test('1c f.dateToFormat date width local names', f.dateToFormat(baseDate.getNew(), '%l, %d %f %y %h:%i:%s') === f._dateNames.weekShort[5] + ', 01 '+f._dateNames.monthShort[0]+' 2000 00:00:00');
      test('1c f.dateToFormat other local names', f.dateToFormat(baseDate.getNew(), '%L %F %z %a %A') === f._dateNames.weekFull[5] + ' ' + f._dateNames.monthFull[0] + ' 1 am AM');
      test('1c f.dataToFormat unix time', function () {
        var t0 = baseDate.getNew(), t, t2;
        t0.setHours(15);
          t = parseInt(f.dateToFormat(t0, '%u'));
          t2 = parseInt(f.dateToFormat(t0, '%U'));
        return t2 / t === 1000;
      });
      test('1c f.dateToFormat full test', f.dateToFormat((new Date(baseDate.getNew().setHours(15))),
        '%d %D %w %l %L %m %M %f %F %y %Y %a %A %g %G %h %H %i %I %s %S %p %P %z') ===
        '01 1 6 '+ f._dateNames.weekShort[5] + ' ' + f._dateNames.weekFull[5] + ' 01 1 ' + f._dateNames.monthShort[0] + ' ' + f._dateNames.monthFull[0] + ' 2000 00 pm PM 03 3 15 15 00 0 00 0 000 0 1');
      gEnd();
    }
    { // window
      group('window functions');
      test('3b f.browser', {
        type: TEST_TYPE_USER,
        mess: 'Browser: ' + f.browser().name + ', ver: ' + f.browser().version
      });
      test('1c f.getSize', function () {
        var s = f.getSize();
        return s.w > 0 && s.h > 0 && s.s >= 0 && s.sl >= 0 && s.sh > 0 && s.sw > 0;
      });
      test('3c f.openWin sync', function(cb) {
        var w  = f.openWin('second.html', '', 200, 200, {sync: true});
        if (w) {
          w.close();
          cb(true);
        } else {
          cb(false);
        }
      });
      test('3c f.openWin async', function(cb) {
        f.openWin('second.html', '', 200, 200, null, function (w) {
          if (w) {
            w.close();
            cb(true);
          } else {
            cb(false);
          }
        })
      });
      test('3a f.log log', {
        type: TEST_TYPE_USER,
        mess: 'log fill message "log test"',
        func: function () {
          f.log('log test');
        }
      });
      test('3a f.log warn', {
        type: TEST_TYPE_USER,
        mess: 'log fill warning "warn test"',
        func: function () {
          f.log('warn test', 'warn');
        }
      });
      test('3a f.log warning', {
        type: TEST_TYPE_USER,
        mess: 'log fill warning "warning test"',
        func: function () {
          f.log('warning test', 'warning');
        }
      });
      test('3a f.log info', {
        type: TEST_TYPE_USER,
        mess: 'log fill warning "info test"',
        func: function () {
          f.log('info test', 'info');
        }
      });
      test('3a f.log err', {
        type: TEST_TYPE_USER,
        mess: 'log fill err "err test"',
        func: function () {
          try {
            f.log('err test', 'err');
          } catch (e) {}
        }
      });
      test('3a f.log error', {
        type: TEST_TYPE_USER,
        mess: 'log fill error "error test"',
        func: function () {
          try {
            f.log('error test', 'error');
          } catch (e) {}
        }
      });
      { // time
        test ('3c f.time function only', function () {
          var s = f.time(function () {
            document.getElementById('testBlock');
          });
          return typeof s === 'number' && s >= 0
        });
        test ('3c f.time function + render', function () {
          var s = f.time(function () {
            var testBlock = document.getElementById('testBlock'), table, tr, r, c;
            table = document.createElement('table');
            for (r = 0; r < 100; r++) {
              tr = document.createElement('tr');
              for (c = 0; c < 100; c++) {
                tr.appendChild(document.createElement('td'));
              }
              table.appendChild(tr);
            }
            testBlock.appendChild(table);
          }, true);
          return typeof s === 'number' && s >= 0
        });
        test ('3c f.time function async without render', function (cb) {
          f.time(function (callback) {
            window.setTimeout(function () {
              callback();
            }, 4);
          }, false, true, function (time) {
            cb (typeof time === 'number' && time >= 0)
          });
        });
        test ('3c f.time function async with render', function (cb) {
          f.time(function (callback) {
            window.setTimeout(function () {
              callback();
            }, 4);
          }, true, true, function (time) {
            cb (typeof time === 'number' && time >= 0)
          });
        });
      }
      { // ajax
        group('AJAX', !hash('ajax'));
        test('1c f.load GET classic', function(cb) {
          f.load('load.html?get=1', function (data) {
            if (data === 'success') {
              cb(true);
            } else {
              cb(false);
            }
          }, function () {
            cb(false);
          });
        });
        test('1c f.load GET modern', function(cb) {
          f.load({
            url: 'load.html?get=1',
            method: 'GET',
            scs: function (data) {
              if (data === 'success') {
                cb(true);
              } else {
                cb (false);
              }
            },
            err: function () {
              cb (false);
            }
          });
        });
        test('1c f.load GET error', function(cb) {
          f.load({
            url: 'load.html?get=2',
            method: 'GET',
            scs: function (data) {
              if (data === 'error') {
                cb(true);
              } else {
                cb (false);
              }
            },
            err: function () {
              cb (false);
            }
          });
        });
        test('1c f.load POST classic', function(cb) {
          f.load('load.html', function (data) {
            if (data === 'success') {
              cb(true);
            } else {
              cb(false);
            }
          }, function () {
            cb(false);
          }, 'post=1');
        });
        test('1c f.load POST modern', function(cb) {
          f.load({
            url: 'load.html',
            method: 'POST',
            data: 'post=1',
            scs: function (data) {
              if (data === 'success') {
                cb(true);
              } else {
                cb (false);
              }
            },
            err: function () {
              cb (false);
            }
          });
        });
        test('1c f.load POST error', function(cb) {
          f.load({
            url: 'load.html',
            method: 'POST',
            data: 'post=2',
            scs: function (data) {
              if (data === 'error') {
                cb(true);
              } else {
                cb (false);
              }
            },
            err: function () {
              cb (false);
            }
          });
        });
        test('1c f.load PUT', function(cb) {
          f.load({
            url: 'load.html',
            method: 'PUT',
            data: 'put=1',
            scs: function (data) {
              if (data === 'success') {
                cb(true);
              } else {
                cb (false);
              }
            },
            err: function () {
              cb (false);
            }
          });
        });
        test('1c f.load PUT error', function(cb) {
          f.load({
            url: 'load.html',
            method: 'PUT',
            data: 'put=2',
            scs: function (data) {
              if (data === 'error') {
                cb(true);
              } else {
                cb (false);
              }
            },
            err: function () {
              cb (false);
            }
          });
        });
        test('1c f.load HEAD', function(cb) {
          f.load({
            url: 'load.html',
            method: 'HEAD',
            header: {
              'X-Data': '1'
            },
            scs: function (data, h) {
              var p, i, l
                , headers = h.split('\n');
              for (i = 0, l = headers.length; i < l; i++) {
                p = headers[i].split(':');
                if (p[0].trim().toLowerCase() === 'X-Result-Request'.toLowerCase()) {
                  if (p[1].trim() === 'success') {
                    cb(true);
                  } else {
                    cb(false);
                  }
                  return;
                }
              }
              cb(false);
            },
            err: function () {
              cb (false);
            }
          });
        });
        test('1c f.load HEAD error', function(cb) {
          f.load({
            url: 'load.html',
            method: 'HEAD',
            header: {
              'X-Data': '2'
            },
            scs: function (data, h) {
              var p, i, l
                , headers = h.split('\n');
              for (i = 0, l = headers.length; i < l; i++) {
                p = headers[i].split(':');
                if (p[0].trim().toLowerCase() === 'X-Result-Request'.toLowerCase()) {
                  if (p[1].trim() === 'error') {
                    cb(true);
                  } else {
                    cb(false);
                  }
                  return;
                }
              }
              cb(false);
            },
            err: function () {
              cb (false);
            }
          });
        });
        gEnd();
      }
      { // getScrollBarWidth
        test('1c f.getScrollBarWidth', function () {
          var el = f.createElement('div', {innerHTML: '<div>test</div>', style: {overflow: 'scroll', width: '200px', height: '200px'}}, document.body);
          var sw = f.getScrollBarWidth();
          var ret = false;
          if (sw === 200 - el.childNodes[0].offsetWidth) {
            ret = true;
          }
          document.body.removeChild(el);
          return ret;
        });
      }
      gEnd();
    }
    { // elements func
      group('elements');
      test('1c f.createElement clear => div', f.createElement('').tagName.toUpperCase() === 'DIV');
      test('1c f.createElement div', f.createElement('').tagName.toUpperCase() === 'DIV');
      test('1c f.createElement span', f.createElement('span').tagName.toUpperCase() === 'SPAN');
      test('1c f.createElement #testElement1', function () {
        var el = f.createElement('#testElement1');
        return el.id === 'testElement1'
          && el.tagName.toUpperCase() === 'DIV';
      });
      test('1c f.createElement div#testElement1', function () {
        var el = f.createElement('div#testElement1');
        return el.id === 'testElement1'
          && el.tagName.toUpperCase() === 'DIV';
      });
      test('1c f.createElement span#testElement1', function () {
        var el = f.createElement('span#testElement1');
        return el.id === 'testElement1'
          && el.tagName.toUpperCase() === 'SPAN';
      });
      test('1c f.createElement .testElement1', function () {
        var el = f.createElement('.testElement1');
        return el.className === 'testElement1'
          && el.tagName.toUpperCase() === 'DIV';
      });
      test('1c f.createElement .testElement1....testElementN', function () {
        var el = f.createElement('.testElement1.testElement2.testElement3');
        return el.className === 'testElement1 testElement2 testElement3'
          && el.tagName.toUpperCase() === 'DIV';
      });
      test('1c f.createElement span.testElement1....testElementN', function () {
        var el = f.createElement('span.testElement1.testElement2.testElement3');
        return el.className === 'testElement1 testElement2 testElement3'
          && el.tagName.toUpperCase() === 'SPAN';
      });
      test('1c f.createElement span#testElement1.testElement1.testElement2', function () {
        var el = f.createElement('span#testElement1.testElement1.testElement2');
        return el.className === 'testElement1 testElement2'
          && el.tagName.toUpperCase() === 'SPAN'
          && el.id === 'testElement1';
      });
      test('1c f.createElement width attrs', function () {
        var el = f.createElement('', {"data-set": 'abc', "id": 'testElement1'});
        return el.getAttribute('data-set') === 'abc'
          && el.tagName.toUpperCase() === 'DIV'
          && el.id === 'testElement1';
      });
      test('1c f.createElement width attrs + style', function () {
        var el = f.createElement('', {
          "data-set": 'abc',
          "id": 'testElement1',
          "style": {
            "left": '1px',
            "top": '1px',
            "position": "relative"
          }});
        return el.getAttribute('data-set') === 'abc'
          && el.tagName.toUpperCase() === 'DIV'
          && el.id === 'testElement1'
          && el.style.left === '1px'
          && el.style.top === '1px'
          && el.style.position === 'relative'
          ;
      });
      test('1c f.createElement width parent', function () {
        var el = f.createElement('', null, document.getElementById('testBlock')), ret;
        ret = el.parentNode === document.getElementById('testBlock')
          && el.tagName.toUpperCase() === 'DIV';
        document.getElementById('testBlock').removeChild(el);
        return ret;
      });
      test('1c f.createElement full', function () {
        var el = f.createElement(
            'span#testElement1.testElement1.testElement2',
            {
              "data-set": 'abc',
              "style": {
                "left": '1px',
                "top": '1px',
                "position": "relative"
              }
            },
            document.getElementById('testBlock')),
          ret;
        ret = el.parentNode === document.getElementById('testBlock')
          && el.tagName.toUpperCase() === 'SPAN'
          && el.className === 'testElement1 testElement2'
          && el.id === 'testElement1'
          && el.getAttribute('data-set') === 'abc'
          && el.style.left === '1px'
          && el.style.top === '1px'
          && el.style.position === 'relative'
        ;
        document.getElementById('testBlock').removeChild(el);
        return ret;
      });
    }
  }
}











