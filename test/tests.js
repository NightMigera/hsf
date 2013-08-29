/**
 * Created with JetBrains WebStorm.
 * User: louter
 * Date: 07.08.13
 * Time: 0:42
 */
(function (window) {
  window.TEST_TYPE_SUCCESS = 1;
  window.TEST_TYPE_ERROR = 2;
  window.TEST_TYPE_USER = 3;
  window.TEST_TYPE_SYSTEM = 4;

  var number, callback, error, warn, lis, ul, res, updateResult
    , s = 0
    , e = 0
    , ss = 0
    , skipped = false
    , padding = 15
    , gStack = []
    , __slice = [].slice
    , __hasProp = {}.hasOwnProperty;
  number = 1;
  lis = [];

  ul = document.createElement('ul');
  ul.className = 'testList';
  res = document.createElement('div');
  res.className = 'result';
  res.innerHTML = '<div class="runs">Runs: 0; </div><div class="scs">Success: 0; </div><div class="err">Error: 0; </div><div class="skip">Skipped: 0;</div>';
  document.getElementsByTagName('body')[0].appendChild(res);
  document.getElementsByTagName('body')[0].appendChild(ul);

  error = function (str) {
    if ('console' in window) {
      if ('error' in window.console) {
        window.console.error(str);
      } else if ('log' in window.console) {
        window.console.log('Error: ' + str);
      } else {
        window.setTimeout(function () {
          alert('Error!\n' + str);
        }, 0);
      }
    } else {
      window.setTimeout(function () {
        alert('Error!\n' + str);
      }, 0);
    }
  };
  warn = function (str) {
    if ('console' in window) {
      if ('warn' in window.console) {
        window.console.warn(str);
      } else if ('log' in window.console) {
        window.console.log('Warning: ' + str);
      } else {
        window.setTimeout(function () {
          alert('Warning!\n' + str);
        }, 0);
      }
    } else {
      window.setTimeout(function () {
        alert('Warning!\n' + str);
      }, 0);
    }
  };

  callback = function (n, result) {
    if (result === 'skip') {
      lis[n].getElementsByTagName('strong')[0].innerHTML = '<span class="skip">skip</span>';
      s++;
      updateResult();
      return;
    }
    if (result) {
      lis[n].getElementsByTagName('strong')[0].innerHTML = '<span class="success">success</span>';
      ss++;
    } else {
      lis[n].getElementsByTagName('strong')[0].innerHTML = '<span class="fail">fail</span>';
      e++;
    }
    updateResult();
  };

  updateResult = function () {
    res.innerHTML = "<div class=\"runs\">Runs: <b>" + (s + ss + e) + "</b>; </div><div class=\"scs\">Success: <b>" + ss + "</b>; </div><div class=\"err\">Error: <b>" + e + "</b>; </div><div class=\"skip\">Skipped: <b>" + s + "</b>;</div>";
  };

  window.eq = function() {
    var a, i, k, r, ret, v, _i, _len;
    r = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    if (r.length < 2) {
      return false;
    }
    ret = true;
    for (i = _i = 0, _len = r.length; _i < _len; i = ++_i) {
      a = r[i];
      if (i === 0) {
        i++;
      } else {
        i--;
      }
      for (k in a) {
        if (!__hasProp.call(a, k)) continue;
        v = a[k];
        if (typeof v === "object") {
          ret = ret && typeof r[i][k] && eq(v, r[i][k]);
        } else if (isNaN(v)) {
          ret = ret && isNaN(r[i][k]);
        } else if (v == null) {
          ret = ret && (r[i][k] == null);
        } else {
          ret = ret && v === r[i][k];
        }
      }
      if (!ret) {
        return false;
      }
    }
    return ret;
  };

  window.seq = function () {
    var a, i, k, r, ret, v, _i, _len;
    r = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    if (r.length < 2) {
      return false;
    }
    ret = true;
    for (i = _i = 0, _len = r.length; _i < _len; i = ++_i) {
      a = r[i];
      if (i === 0) {
        i++;
      } else {
        i--;
      }
      for (k in a) {
        if (!__hasProp.call(a, k)) continue;
        v = a[k];
        if (isNaN(v)) {
          ret = ret && isNaN(r[i][k]);
        } else if (v == null) {
          ret = ret && (r[i][k] == null);
        } else {
          ret = ret && v === r[i][k];
        }
      }
      if (!ret) {
        return false;
      }
    }
    return ret;
  };

  window.group = function (name, skip) {
    var li;
    li = document.createElement('li');
    li.style.paddingLeft = (padding * gStack.length).toString() + 'px';
    li.appendChild(document.createTextNode(name));
    li.style.fontWeight = 'bold';
    ul.appendChild(li);
    gStack.push([name,skip||false]);
    if (skip) {
      skipped = true;
    }
  };

  window.groupEnd = window.gEnd = function () {
    if (gStack.pop()[1]) {
      skipped = false;
    }
  };

  window.skip = function () {
    skipped = true;
  };

  window.sEnd = window.skipEnd = function () {
    skipped = false;
  };

  window.test = function (name, body, tType) {
    var func, type, mess, str, n, res, li, tNum, tName, tRes, vRes;
    n = number++;
    if (skipped) {
      body = true;
    }
    switch (typeof body) {
      case 'object':
        func = body.func;
        type = body.type || window.TEST_TYPE_SUCCESS;
        mess = body.mess;
        break;
      case 'function':
        func = body;
        type = tType || window.TEST_TYPE_SUCCESS;
        break;
      case 'boolean':
        func = function() {
          return body;
        };
        type = window.TEST_TYPE_SUCCESS;
        break;
      default:
        str = 'Error in test ' + n + ': ' + name + ': typeof body not exists: ' + typeof body;
        error(str);
        return;
    }
    li = document.createElement('li');
    li.style.paddingLeft = (padding * gStack.length).toString() + 'px';
    tNum = document.createElement('span');
    tNum.className = 'testNumber';
    tNum.appendChild(document.createTextNode(n.toString()));
    tName = document.createElement('span');
    tName.className = 'testName';
    tName.appendChild(document.createTextNode(name));
    tRes = document.createElement('strong');
    tRes.className = 'testResult';
    tRes.appendChild(vRes = document.createTextNode('...'));
    li.appendChild(tNum);
    li.appendChild(tName);
    li.appendChild(tRes);
    ul.appendChild(li);
    lis[n] = li;
    if (skipped === true) {
      callback(n, 'skip');
      return;
    }
    switch (type) {
      case TEST_TYPE_SUCCESS:
      case TEST_TYPE_SYSTEM:
        try {
          res = func(function (r) {
            callback(n, r)
          });
          if (typeof res === 'boolean') {
            callback(n, res);
          }
        } catch (e) {
          callback(n, false);
          warn('№' + n + ', ' + name + ': ' + e.message);
        }
        break;
      case TEST_TYPE_ERROR:
        try {
          res = func();
          if (typeof res === 'boolean') {
            callback(n, false);
          }
        } catch (e) {
          if (e.message.indexOf(mess) > -1) {
            callback(n, true);
          } else {
            callback(n, false);
            warn('№' + n + ', ' + name + ': ' + e.message);
          }
        }
        break;
      case TEST_TYPE_USER:
        tName.appendChild(document.createTextNode(' ' + mess));
        tRes.innerHTML = '<button>Yes Да</button><button>No Нет</button>';
        tRes.childNodes[0].onclick = function () {
          callback(n, true);
        };
        tRes.childNodes[1].onclick = function () {
          callback(n, false);
        };
        break;
      default:
        error('Unknown type of test: ' + type);
        return;
    }
  };
})(window);