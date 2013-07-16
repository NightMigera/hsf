"use strict"
###*
 * <b>HSF</b> это hight speed function (высокоскоростные функции).
 * Функции, ориентированные на скорость выполнения в зависимости от задач.
 * Созданный класс вносит корректировки в прототипы базовых классов и сильно
 * расширяет базовый функционал, позволяя использовать функии со скоростью превосходящей jQuery,
 * но уступающей по кросбраузерности
 * @author Louter
 * @version 0.4.0
 * @changeLog: by 0.1
 *  +getScrollBarWidth
 *  +random
 *  +qsa
 *  +insertAfter, +insertBefore
 *  +clearElement #todo утечка памяти
 *  ~setDrag add dragOver, gragOut, drop and change arguments mix
 *  ~openWin add callback
 * @changeLog: by 0.2
 *  +formToData
 * @changeLog: by 0.3
 *  +removeElement
 *  ~appendChild
 * @changeLog: by 0.4
 *  +setStyle
 *  +getIndexElement
 *  ~createLoaderBubble
 *  ~setMem,buttonClick,hover (return this)
 *  ~retTempStyle
 *  ~load
 *  ~setDrag add touch
 * @changeLog: by 0.5
 *  +setCSSS
 *  +remCSSS
 *  +updateStyleSheetIndex
 *  +createStyleSheet
 *  +Function::bind
 *  ~openWin
 *  ~load
 *  ~log, printLog
 *  ~qsa
 * @changeLog: by 0.5.1
 *  ~updateStyleSheetIndex
 *  ~addEvent
###

###*
 * _HSF это контейнер для всех экземпляров класса, но обычно в нём всего 1 экземпляр
 * @type {Object}
 * @private
###
window._HSF =
  get: (id) ->
    _HSF[id] || null

###*
 * Базовый класс содержит методы и переменные
 * @type {HSF}
 ###
class HSF
  ###*
   * Сбор объектов для запросов.
   * Необходим для использования установившихся соединений и для образ-я новых
   * @type {Array}
   * @private
   ###
  _rPool: []
  ###*
   * Счётчик для отклучения кэша при AJAX запросах. Может быть выключен через параметр counter:false
   * @type {Number}
   * @private
   ###
  _counter: 0
  ###*
   * Флвг, определяющая включен ли счётчик
   * @type {Boolean}
   * @private
   ###
  _counterEnabled: true
  ###*
   * Кэш для названия браузера.
   * (Надеюсь в процессе работы браузер не сменится внезапно с одного на другой)
   * @type {Object}
   * @private
   ###
  _browser: {version: 0,name: ""}
  ###*
   * Флаг, включен ли режим отладки
   * @type {Boolean}
   * @private
   ###
  _debug: false
  ###*
   * id экземпляра для обращения в inline-функциях
   * @type {String}
   * @private
   ###
  _id: ''
  ###*
   * Кеш для имён CSS свойств, с префиксами (-mox
   * @type {Object}
   * @private
   ###
  _setUniversalStyleCascade: {}
  ###*
   * константа, определяющая, с какими префиксами мы работаем
   * @const
   * @type {Array}
   * @private
   ###
  _stylePrefixes: ['','o','ms','moz','webkit']

  ###*
   * Сбор объектов, за которыми происходит слежка изменили ли они свои размеры
   * @type {Array}
   * @private
   ###
  _onResizeCollection: []
  ###*
   * Массив объектов у которых следует следить за изменением размера (их позиции в коллекции)
   * @type {Array}
   * @private
   ###
  _onResizeArray: []
  ###*
   * Дата начала логирования вмилесекундах
   * @type {Number}
   * @private
   ###
  _startLogDate: (new Date()).getTime()
  ###*
   * Логи, которые откидываются в console.log, если таковой имеется.
   * @type {Object}
   * @private
   ###
  _stackLog: []
  ###*
   * Названия клавиш и значения их при нажатии по умолчанию. Внутри keyListener переопределяются
   * @type {Object}
   * @private
   ###
  _keyMap:
    backspace: 8, tab: 9, enter: 13, shift: 16, ctrl: 17, alt: 18, pauseBreak: 19, capsLock: 20, escape: 27, esc: 27
    pageUp: 33,pageDown: 34,end: 35,home: 36,left: 37,up: 38,right: 39,down: 40,insert: 45,delete: 46
    0: 48, 1: 49, 2: 50, 3: 51, 4: 52, 5: 53, 6: 54, 7: 55, 8: 56, 9: 57, a: 65, b: 66, c: 67, d: 68, e: 69, f: 70,g: 71, h: 72
    i: 73 ,j: 74 ,k: 75 ,l: 76 ,m: 77 ,n: 78 ,o: 79 ,p: 80 ,q: 81 ,r: 82 ,s: 83 ,t: 84 ,u: 85 ,v: 86 ,w: 87 ,x: 88 ,y: 89 ,z: 90
    leftWinKey: 91, rightWinKey: 92, selectKey: 93, numpad0: 96, numpad1: 97, numpad2: 98, numpad3: 99, numpad4: 100
    numpad5: 101, numpad6: 102, numpad7: 103, numpad8: 104, numpad9: 105, multiply: 106, add: 107, subtract: 109
    decimalPoint: 110, divide: 111, f1: 112, f2: 113, f3: 114, f4: 115, f5: 116, f6: 117, f7: 118, f8: 119, f9: 120
    f10: 121, f11: 122, f12: 123, semiColon: 186, equalSign: 187, comma: 188, dash: 189, period: 190, forwardSlash: 191
    graveAccent: 192, openBracket: 219, backSlash: 220, closeBraket: 221, singleQuote: 222

  ###*
   * Сбор для отслеживания нажатия клавиш
   * @type {Array}
   * @private
   ###
  _keyListMap: []
  ###*
   * Функция для использования в domDocumentReady
   * @type {String}
   * @private
   ###
  _funcDomReady: ''
  ###*
   * Мы ловим и keyDown и keyPress, но когда мы кого-то поймали не должно выполняться дважды.
   * Сюда пишется функция, которую мы выполнили только что на keyDown
   * @type {null|Function}
   * @private
   ###
  _onKeyDowned: null
  ###*
   * Названия месяцов и недель для генератора строк
   * @type {Object}
   * @private
   ###
  _dateNames:
    monthShort:['Янв',"Фев","Мар","Апр","Май","Июн","Июл","Авг","Сен","Окт","Ноя","Дек"]
    monthFull: ['Январь',"Февраль","Март","Апрель","Май","Июнь","Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь"]
    weekShort: ['Пн','Вт',"Ср","Чт","Пт","Сб","Вс"]
    weekFull:  ['Понедельник','Вторник',"Среда","Четверг","Пятница","Суббота","Воскресенье"]
  ###*
   * Ширина скролбара в данной системе. Полезно при пиксельхантинге в js
   * @type {Number}
   * @private
   ###
  _scrollBarWidth: -1

  ###*
   * Готово ли дерево док-та
   * @type {Boolean}
   * @private
   ###
  _ready: false

  ###*
   * Путь до лоадера по умолчанию
   * @type {String}
   * @private
   ###
  _defaultLoader: 'img/loader.gif'

  ###*
   * Элемент хранящий данные по умолчанию
   * @type {Element}
   * @private
   ###
  _storage: null

  ###*
   * Путь до скрипта
   * @type {String}
   * @private
   ###
  _scriptPath: ''

  ###*
   * Кэш правил
   * @type {Object}
   * @private
   ###
  _CSSCache: null

  ###*
   * Системный стайлшит
   * @type {Object}
   * @private
   ###
  _systemStyleSheet: null

  ###*
   * Параметры:
   *    debug: true|false режим отладки
   *    ajaxPoolLength: {numeric} длина пула ajax
   *    counter: (bool) включено ли добавление параметра, защищающего от кешированного ответа
   *    dateNames: (Object) Названия месяцев и недель в календарях
   * @param {Object} options
   * @constructor
   ###
  constructor: (options) ->
    ajaxPoolLength = if 'ajaxPoolLength' of options then options.ajaxPoolLength else 5
    @_rPool.push({ajax: null,state: 0,func: null, err: null}) for [0..ajaxPoolLength]
    @_debug = true if 'debug' of options and options.debug is true
    @_counterEnabled = false if 'counter' of options and not options.counter
    if 'dateNames' of options
      for own k, v of options.dateNames
        @_dateNames[k] = v
    @_id = @md5(navigator.userAgent + (new Date()).getTime().toString() + Math.random().toString())
    _HSF[@_id] = @
    @onDomReady( =>
      document.onkeypress = document.onkeydown = (e) =>
        e = e || window.event
        result = true
        list = @_keyListMap[e.keyCode] || [];
        if list.length
          for shortcut in list
            if e.ctrlKey is shortcut.ctrl and e.shiftKey is shortcut.shift and e.altKey is shortcut.alt
              if e.type.indexOf('keydown') >= 0 or (@_onKeyDowned isnt shortcut.func)
                result = shortcut.func.call(@, e) || false
                @_onKeyDowned = shortcut.func
              else if e.type.indexOf('keypress') >= 0 or @_onKeyDowned is shortcut.func
                @_onKeyDowned = null
                return true
        e.preventDefault() if (not result or (16 <= e.keyCode <= 18)) and "preventDefault" of e
        result
    )
    @onDomReady(=>
      @keyListener('semiColon', =>
        @printLog()
      , true
      )
      if typeof @_initIeStorage is 'function'
        @_initIeStorage()
      return
    )

    unless Function::bind
      Function::bind = (oThis) ->
        if typeof this isnt "function"
          throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable")
        aArgs = Array::slice.call(arguments, 1)
        fToBind = @
        fNOP = ->
        fBound = ->
          fToBind.apply (if @ instanceof fNOP and oThis then @ else oThis), aArgs.take(arguments)
        fNOP:: = @::
        fBound:: = new fNOP()
        fBound

    unless "trim" of String
      ###*
       * Добавляет функцию trim в String там, где этого нет (IE)
       * @return String
       ###
      String::trim = ->
        @replace(/^\s\s*/, '').replace(/\s\s*$/, '') #прикол, но это быстрее, чем \s+

    s = "test"
    try
      o = s.replace("t", "d", "g")
    if o isnt "desd"
      String::replaceOld = String::replace
      String::replace = (string, newValue, flags) ->
        unless flags
          @replaceOld string, newValue
        else
          @replaceOld new RegExp(string.replaceOld(/([\/\,\!\\\^\$\{\}\[\]\(\)\.\*\+\?\|\<\>\-\&])/g, "\\$&"), flags), (if (typeof newValue is "string") then newValue.replaceOld(/\$/g, "$$$$") else newValue)

    unless Array::forEach
      ###*
         * forEach executes the provided callback once for each element of
         * the array with an assigned value. It is not invoked for indexes
         * which have been deleted or which have been initialized to undefined.
         *
         * @param {Function} fn Function to execute for each element.
         * @param {Object} [scope] Object to use as this when executing callback.
       ###
      Array::forEach = (fn, scope) ->
        `for(var i = 0, len = this.length; i < len; ++i) {
          if (i in this) {
            fn.call(scope, this[i], i, this);
          }
        }`
        return
    ###*
     * Присоединяет значения объекта к текущему массиву
     * @param {Array|NodeList|HTMLCollection} array любой массивоподобный объект
     * @return Array
     ###
    Array::take = (array) ->
      `for (var i = 0, j = this.length, l= array.length; i < l; i++, j++) {
        this[j] = array[i];
      }`
      @
    ###*
     * Удаляем элемент из массива
     * @param {Number} index индекс элемента
     * @return Array
     ###
    Array::del = (index) ->
      @.splice(index,1)
      @

    unless 'indexOf' of Array
      ###*
       * Получаем элемент в массиве или -1, если его нет. Фикс для старых браузеров
       * @param {*} item элемент массива
       * @param {Number} [startIndex] = 0 начальный индекс
       * @return Number
       ###
      Array::indexOf = (item, startIndex = 0) ->
        l = @length
        i = if startIndex > 0 then startIndex|0 else l - (startIndex|0)
        while i < l
          return i  if i of this and this[i] is item
          i++
        -1

    unless window.setImmediate
      head = {}
      tail = head
      ID = Math.random()*10000000|0+''
      onmessage = (e) ->
        return  unless e.data is ID # не наше сообщение
        head = head.next
        func = head.func
        delete head.func
        func()
      if window.addEventListener # IE9+, другие браузеры
        window.addEventListener "message", onmessage, false
      else # IE8
        window.attachEvent "onmessage", onmessage
      if window.postMessage
        window.setImmediate = (func)->
          tail = tail.next = func: func
          window.postMessage(ID, "*")
          return
      else
        window.setImmediate = (func) ->
          setTimeout(func, 0)
          return

    @prepareOnDocumentReady()


  ###*
   * Получает строку для обращения из глобальной области видимости для inline функций
   * @return String
   ###
  getThis: ->
    "_HSF.get('#{@_id}')"

  ###*
   * синоним для document.getElementById
   * @param {String} el
   * @return Element
   ###
  GBI: (el) ->
    document.getElementById el

  ###*
   * кросс-браузерная версия для получения элементов по имени класса classname внутри node
   * @param {String} classname
   * @param {Element} [node] = document
   * @return Array|NodeList
   ###
  GBC: (classname, node = document) ->
    if 'getElementsByClassName' of node # use native implementation if available
      node.getElementsByClassName(classname)
    else
      ((searchClass, node) ->
        classElements = []
        els = node.getElementsByTagName("*")
        elsLen = els.length
        pattern = new RegExp("(^|\\s)" + searchClass + "(\\s|$)")
        i = 0
        j = 0

        while i < elsLen
          if pattern.test(els[i].className)
            classElements[j] = els[i]
            j++
          i++
        classElements
      ) classname, node

  ###*
   * синоним для node.getElementsByTagName
   * @param {String} tagName
   * @param {Node} [node] = document
   * @return NodeList
   * @constructor
   ###
  GBT: (tagName, node = document) ->
    node.getElementsByTagName tagName

  ###*
   * создаём окно по центру с заданной ссылкой и названием.
   * Размеры, а так же различные элементы определяются отдельно
   * @param {String} url
   * @param {String} [title]
   * @param {Number} [width] = 902
   * @param {Number} [height] = 700
   * @param {Object} [option]
   * @return window
   ###
  openWin: (url, title, width = 902, height = 700, option = {}, callback) ->
    map = {resizable:1,scrollbars:1,menubar:0,toolbar:0,status:1}
    try
      left = ((screen.availWidth ||screen.width) / 2) - (width / 2) + (screen.availLeft || 0)
      top = ((screen.availHeight || screen.height) / 2) - (height / 2) + (screen.availTop || 0)
      link = "width=#{width},height=#{height},left=#{left}, top=#{top}"
      for name in ['resizable','scrollbars','menubar','toolbar','status']
        link += ",#{name}=" + (if name of option then (if option[name] then 1 else 0) else map[name])
      w = window.open(url, title, link)
      w.activated = false
      w.onfocus = () =>
        return if w.activated
        w.activated = true
        if typeof callback is 'function'
          callback(w)
        else
          @log('success win open')
        true
      w.blocked = !!(w.document.getElementById)
      w.onfocus() if w
    catch err
      alert "Ошибка открытия окна - #{title}"
    w || false

  getSelection: (el) ->
    start = 0
    end = 0
    if typeof el.selectionStart is "number" and typeof el.selectionEnd is "number"
      start = el.selectionStart
      end = el.selectionEnd
    else
      range = document.selection.createRange()
      if range and range.parentElement() is el
        len = el.value.length
        normalizedValue = el.value.replace(/\r\n/g, "\n")

        # Create a working TextRange that lives only in the input
        textInputRange = el.createTextRange()
        textInputRange.moveToBookmark range.getBookmark()

        # Check if the start and end of the selection are at the very end
        # of the input, since moveStart/moveEnd doesn't return what we want
        # in those cases
        endRange = el.createTextRange()
        endRange.collapse false
        if textInputRange.compareEndPoints("StartToEnd", endRange) > -1
          start = end = len
        else
          start = -textInputRange.moveStart("character", -len)
          start += normalizedValue.slice(0, start).split("\n").length - 1
          if textInputRange.compareEndPoints("EndToEnd", endRange) > -1
            end = len
          else
            end = -textInputRange.moveEnd("character", -len)
            end += normalizedValue.slice(0, end).split("\n").length - 1
    start: start
    end: end

  ###*
   * получается позиция объекта в документе. Некоторые баги в ИЕ
   * @param {Element} el
   * @return Object {x:(number),y:(number)}
   ###
  getPos: (el, parent = document.body) ->
    return false if not @hasElement(parent, el)
    s = {x: 0,y: 0}
    if 'getBoundingClientRect' of el and parent is document.body
      box = el.getBoundingClientRect()
      body = document.body
      docElem = document.documentElement
      scrollTop = window.pageYOffset or docElem.scrollTop or body.scrollTop
      scrollLeft = window.pageXOffset or docElem.scrollLeft or body.scrollLeft
      clientTop = docElem.clientTop or body.clientTop or 0
      clientLeft = docElem.clientLeft or body.clientLeft or 0
      top = box.top + scrollTop - clientTop
      left = box.left + scrollLeft - clientLeft
      s.x = Math.round(left)
      s.y = Math.round(top)
    else if parent is document.body
      unless el.offsetParent
        s.x += el.offsetLeft
        s.y += el.offsetTop
      while el.offsetParent
        s.x += el.offsetLeft
        s.y += el.offsetTop
        el = el.offsetParent
    else
      while not @hasElement(el.offsetParent, parent)
        s.x += el.offsetLeft
        s.y += el.offsetTop
        el = el.offsetParent
        return s unless el
      if el.offsetParent isnt parent
        s.x += el.offsetLeft - parent.offsetLeft
        s.y += el.offsetTop - parent.offsetTop
      else
        s.x += el.offsetLeft
        s.y += el.offsetTop
    s
  ###*
   * получается позиция event-a
   * @param {Event} e
   * @return Object {x:(number),y:(number)}
   ###
  getMousePos: (e) ->
    unless e
      throw new Error('event is empty')
    posx = 0
    posy = 0
    if (e.pageX or e.pageY)
      posx = e.pageX;
      posy = e.pageY;
    else if (e.clientX or e.clientY)
      posx = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
      posy = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
    x: posx
    y: posy

  ###*
   * alias to getMousePos
   * @param {Event} e
   * @return {Object} {x:(number),y:(number)}
   ###
  GMP: @getMousePos

  ###*
   * получается позиция объекта на экране.
   * @param {Element} el
   * @return {Object} {x:(number),y:(number)}
   ###
  getScreenPos: (el) ->
    s =
      x: 0
      y: 0
    if 'getBoundingClientRect' of el
      box = el.getBoundingClientRect()
      s.x = Math.round box.left
      s.y = Math.round box.top
    else
      box = @getPos el
      body = document.body
      docElem = document.documentElement
      scrollTop = window.pageYOffset or docElem.scrollTop or body.scrollTop
      scrollLeft = window.pageXOffset or docElem.scrollLeft or body.scrollLeft
      clientTop = docElem.clientTop or body.clientTop or 0
      clientLeft = docElem.clientLeft or body.clientLeft or 0
      s.x = box.x + clientLeft - scrollLeft
      s.y = box.y + clientTop - scrollTop
    s

  ###*
   * получение размеров экрана, возвращается объект с свойствами:
   * w ширина экрана,
   * h высота экрана,
   * s величина прокрутки сверху,
   * sl величина прокрутки слева,
   * sw ширина прокручиваемой области,
   * sh высота документа
   * @return Object
   ###
  getSize: ->
    ret =
      w: 0
      h: 0
      s: 0
      sl: 0
      sw: 0
      sh: 0
    if self.innerHeight # Everyone but IE
      ret.w = window.innerWidth
      ret.h = window.innerHeight
      ret.s = window.pageYOffset
      ret.sl = window.pageXOffset
    else if document.documentElement and document.documentElement.clientHeight # IE6 Strict
      ret.w = document.documentElement.clientWidth
      ret.h = document.documentElement.clientHeight
      ret.s = document.documentElement.scrollTop
      ret.sl = document.documentElement.scrollLeft
    else if document.body # Other IE, such as IE7
      ret.w = document.body.clientWidth
      ret.h = document.body.clientHeight
      ret.s = document.body.scrollTop
      ret.sl = document.body.scrollLeft
    # Page size w/offscreen areas
    if window.innerHeight and window.scrollMaxY
      ret.sw = document.body.scrollWidth
      ret.sh = window.innerHeight + window.scrollMaxY
    else if document.body.scrollHeight > document.body.offsetHeight # All but Explorer Mac
      ret.sw = document.body.scrollWidth
      ret.sh = document.body.scrollHeight
    else # Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
      ret.sw = document.body.offsetWidth
      ret.sh = document.body.offsetHeight
    ret

  ###*
   * получаем значение стиля элемента по его DOM-имени
   * @param {Element} el
   * @param {String} styleName
   * @return String
   ###
  getStyle: (el, styleName) ->
    if @browser().name is "msie"
      return el.currentStyle[styleName] if styleName of el.currentStyle
      return ''
    ret = window.getComputedStyle(el, null)
    return ret[styleName] if ret[styleName]?
    ''

  ###*
   * Выставляет стиль, в основном призвын перебирать стили в объекте
   * @param {Element} el
   * @param {String|Object} style
   * @return HSF
   ###
  setStyle: (el, style) ->
    switch typeof style
      when 'string' then el.style.cssText += ";#{style}"
      when 'object' then for k, s of style then el.style[k] = s
      else
    @

  ###*
   * Получает индекс элемента у родительского элемента.
   * @param {Element} el
   * @param {Boolean} node = false считать ли среди всех дочерних элементов или только среди тэгов (по умолчанию)
   * @return Number
   ###
  getIndexElement: (el, node = false) ->
    if node is true
      return [].take(el.parentNode.childNodes).indexOf(el)
    else
      return [].take(el.parentNode.children).indexOf(el)

  ###*
   * определяет название браузера и версию
   * @return Object {name:[mozilla|opera|chrome|ie|safari|...], version: (Float)}
   ###
  browser: ->
    return @_browser if @_browser.version isnt 0
    nav = window.navigator
    chrome = /Chrome\/([\d\.]+)/
    chrome = nav.userAgent.search(chrome)
    safari = /Safari\/([\d\.]+)/
    safari = nav.userAgent.search(safari)
    start = 0
    v = 0
    if nav.appName is "Microsoft Internet Explorer"
      @_browser.name = "msie"
      start = nav.appVersion.indexOf("MSIE") + 5
      v = nav.appVersion.substring(start, nav.appVersion.indexOf(";", start) - 1)
      @_browser.version = parseFloat(v)
    else unless chrome is -1
      @_browser.name = "chrome"
      start = nav.appVersion.indexOf("Chrome") + 7
      v = nav.appVersion.substring(start, nav.appVersion.indexOf(" ", start) - 1)
      @_browser.version = parseFloat(v)
    else if nav.appName is "Opera"
      @_browser.name = "opera"
      start = nav.userAgent.indexOf("Version") + 8
      v = nav.userAgent.substring(start, nav.userAgent.length)
      @_browser.version = parseFloat(v)
    else unless safari is -1
      @_browser.name = "safari"
      start = nav.userAgent.indexOf("Version") + 8
      v = nav.userAgent.substring(start, nav.userAgent.indexOf(" ", start) - 1)
      @_browser.version = parseFloat(v)
    else if nav.appName is "Netscape" and nav.appCodeName is "Mozilla" and nav.userAgent.indexOf("Firefox") isnt -1
      @_browser.name = "mozilla"
      start = nav.userAgent.indexOf("Firefox") + 8
      v = nav.userAgent.substr(start)
      @_browser.version = parseFloat(v)
    else
      @_browser.name = nav.userAgent
      @_browser.version = parseFloat(nav.appVersion)
    @_browser

  ###*
   * устанавливаем "память" объекту.
   * пока он будет жив, память можно будет получить
   *
   * @param {Element} el
   * @param {String} prop properties
   * @param {String} val value of properties
   * @param {String} nameSpace = 'HSF' name space, of our params
   * @return Element
   ###
  setMem: (el, prop, val, nameSpace = 'HSF') ->
    if nameSpace
      el[nameSpace] = {}  unless nameSpace of el
      el[nameSpace][prop] = val
    else
      el[prop] = val
    @
  ###*
   * получаем "память" объекта.
   * пока он будет жив, память можно будет получить
   *
   * @param {Element} el
   * @param {String} prop properties
   * @param {String} nameSpace = 'HSF' name space, of our params
   * @return Mixed
   ###
  getMem: (el, prop, nameSpace = 'HSF') ->
    if nameSpace of el
      return el[nameSpace][prop]  if prop of el[nameSpace]
    else unless nameSpace
      return el[prop]  if prop of el
    null
  ###*
   * получаем всю память с установленным префиксом
   *
   * @param {Element} el
   * @param {String} nameSpace = 'HSF'
   * @return Object
   ###
  getMemList: (el, nameSpace = 'HSF') ->
    return {} unless nameSpace
    el[nameSpace]

  ###*
   * очищаем всю память с установленным префиксом
   *
   * @param {Element} el
   * @param {String} nameSpace = 'HSF'
   * @return Boolean
   ###
  clearMem: (el, nameSpace = 'HSF') ->
    return false unless nameSpace
    el[nameSpace] = {}
    return true

  ###*
   * Возвращает свойства объекта, преобразованные в строку.
   * Расширение класса происходит только там, где нет этого метода
   * @return String
   ###
  toSource: (o) ->
    return o.toSource() if 'toSource' of o
    source = "{\n"
    source += "  #{i}: #{val}\n" for own i, val of o
    source + "\n}"

  ###*
   * возвращает число или 0 (вместо NaN)
   * @param {*} value
   * @return Number
   ###
  toInt: (value) ->
    if typeof value is 'boolean'
      return +value
    parseInt(value)|0

  ###*
   * Берёт логарифм от a по основанию b. По умолчанию натуральный.
   * @param {Number} a
   * @param {Number} b = Math.E
   * @return Number
   ###
  mLog: (a, b = Math.E) ->
    1000*Math.log(a)/(1000*Math.log(b))

  ###*
   * Описываем, что в кнопке должно измениться и какие функции произойти, когда на неё нажимают,
   * прописываем функцию, срабатывающую при отпускании.
   * @param {Element} el
   * @param {Object} props css property
   * @param {Object} opt={} {[down:handler(el)],[up:handler(el)]}
   * @return Boolean
   ###
  buttonClick: (el, props, opt={}) ->
    md = =>
      @setTempStyle(el, props, 'Click')
      @addEvent el, "mouseout", mu
      opt.down(el) if 'down' of opt
      true
    mu = =>
      @retTempStyle(el, 'Click')
      @removeEvent el, "mouseout", mu
      opt.up(el) if 'up' of opt
      true
    @addEvent el, "mouseup", mu
    @addEvent el, "mousedown", md
    if opt.activate is true
      el.onmousedown()
    @

  ###*
   * Описываем, что в кнопке должно измениться и какие функции произойти, когда на неё наводят,
   * прописываем функцию, срабатывающую при отведении.
   * @param {Element} el
   * @param {Object} props css property
   * @param {Object} opt={} {[down:handler],[up:handler]}
   * @return Boolean
   ###
  hover: (el, props, opt={}) ->
    mover = (e) =>
      e = e || window.event
      src = e.toElement || document.body
      return true if e.type isnt 'mouseenter' and @hasElement(el,src) and @getMem(el, 'hover')
      @setTempStyle(el, props, 'Hover')
      opt.over(el) if 'over' of opt
      @setMem(el, 'hover', true)
      true
    mout = (e) =>
      e = e || window.event
      src = e.toElement || document.body
      return true if e.type isnt 'mouseleave' and @hasElement(el,src) and el isnt src
      @retTempStyle(el, 'Hover')
      opt.out(el) if 'out' of opt
      @setMem(el, 'hover', false)
      true
    if @browser().name is "msie"
      el.attachEvent "onmouseenter", mover
      el.attachEvent "onmouseleave", mout
      mover({toElement:el}) if opt.activate is true
    else
      if 'onmouseenter' of el
        el.addEventListener "mouseenter", mover, false
        el.addEventListener "mouseleave", mout, false
        mover({toElement:el}) if opt.activate is true
      else
        el.addEventListener "mouseover", mover, false
        el.addEventListener "mouseout", mout, false
        mover({toElement:el}) if opt.activate is true
    @

  ###*
   * Устанавливает временный стиль, записывая старый стиль в память объекта
   * @param {Element} el
   * @param {Object} props css property
   * @param {String} state имя блока стилей
   * @return HSF
   ###
  setTempStyle: (el, props, state) ->
    touch = @getMem el, 'touch'
    unless touch
      oldState = 'originStyle'
      touch = ["oldStyle#{state}"]
    else
      oldState = touch[touch.length-1]
      touch.push "oldStyle#{state}"
    for own k, v of props
      if k of el.style
        @
          .setMem(el, k, el.style[k], oldState)
          .setMem(el, k, v, "oldStyle#{state}")
        el.style[k] = v
    @setMem el, 'touch', touch

  ###*
   * Восстанавливает указанные в props ывойства из state блока
   * @param {Element} el
   * @param {Object} props css property
   * @param {String} state имя блока стилей
   * @return HSF
   ###
  retTempStyle: (el, state) ->
    props = @getMemList el, "oldStyle#{state}"
    return @ unless props
    touch = @getMem el, 'touch'
    return @ unless touch
    index = touch.indexOf("oldStyle#{state}")
    if index < 0
      f.log('Error: retTempStyle: index tempStyle is -1')
      return @
    #---------
    oldState = if index > 0 then touch[index-1] else 'originStyle'
    oldStyle = @getMemList el, oldState
    for k of props
      if k of oldStyle
        el.style[k] = oldStyle[k]
      else
        oldStyle[k] = props[k]
    touch.del(index)
    if index isnt touch.length
      while index < touch.length
        for k, v of @getMemList el, touch[index]
          el.style[k] = v
        index++
    touch = null if touch.length is 0
    @setMem el, 'touch', touch

  ###*
   * Добавление функции для действия
   * @param {Element} elem
   * @param {String} evType
   * @param {Function} fn имя блока стилей
   * @return Boolean|Function функция для удаления эвента или false
   ###
  addEvent: (elem, evType, fn) ->
    evType = evType.replace /^on/, ''
    if 'addEventListener' of elem
      elem.addEventListener evType, fn, false
    else
      onEvType = "on" + evType;
      if not (onEvType of elem) and evType isnt 'hashchange'
        return false
      if evType is 'hashchange' and 'location' of elem
        hashChangeCorrect = false
        bVersion = @_browser.version
        switch (@_browser.name)
          when 'msie' then if document.documentMode < 8 then hashChangeCorrect = true
          when 'mozilla' then if bVersion < 3.6 then hashChangeCorrect = true
          when 'chrome', 'safari' then if bVersion < 5 then hashChangeCorrect = true
          when 'opera' then if bVersion < 10.6 then hashChangeCorrect = true
          else hashChangeCorrect = true
        if hashChangeCorrect
          elem.onhashchange = null
          oldHash = elem.location.hash
          oldHref = elem.location.href
          window.setInterval( ->
            try
              if elem.location.hash isnt oldHash
                oldHash = elem.location.hash
                oldHref = elem.location.href
                if typeof elem.onhashchange is 'function'
                  elem.onhashchange.call(elem,
                    target: elem
                    timestamp: (new Date().getTime())
                    oldURL: oldHref
                    newURL: elem.location.hash
                  )
          , 42)
      func = (e) =>
        e = e || window.event
        e.target = e.target || e.srcElement
        for func in @getMem(elem, evType, 'eventsListener')
          func.call(elem,e)
        true
      if onEvType of elem and not elem[onEvType]
        @setMem elem, evType, [fn], 'eventsListener'
        elem[onEvType] = func
      else
        unless @getMem(elem, evType,'eventsListener')
          eventElem = elem[onEvType]
          @setMem elem, evType, [eventElem], 'eventsListener'
          elem[onEvType] = func
        @getMem(elem, evType,'eventsListener').push(fn)
    if @_debug is true
      collectByType = @getMem elem, evType, 'eventListenerCollect'
      if collectByType is null
        @setMem elem, evType, [{fn:fn,enable:true}], 'eventListenerCollect'
      else
        collectByType.push {fn:fn,enable:true}
    =>
      @removeEvent elem, evType, fn

  ###*
   * Удаление функции из слушателей
   * @param {Element} elem
   * @param {String} evType
   * @param {Function} fn имя блока стилей
   * @return Boolean
   ###
  removeEvent: (elem, evType, fn) ->
    evType = evType.replace(/^on/,'')
    if elem.addEventListener
      elem.removeEventListener evType, fn, false
    #else if elem.attachEvent
    #  elem.detachEvent "on" + evType, fn
    else
      fns = @getMem elem, evType, 'eventsListener'
      nfns = []
      nfns.push(val) for val in fns when val isnt fn
      @setMem elem, evType, nfns, 'eventsListener'
    if @_debug is true
      collectByType = @getMem elem, evType, 'eventListenerCollect'
      for func in collectByType
        func.enable = false if func.fn is fn
    true

  ###*
   * AJAX запрос
   * может принять необходимые аргументы, а может и объект, где:
   *   url: String собственно адрес
   *   scs: function(data) вызывается при успешном выполнении
   *   err: function(data) вызывается при неудачном выполнении
   *   data: String данные для POST метода
   *   method: String
   *   header: Object вида {header1Name: header1Value[, headerXName: headerXValue]...}
   * @param {String|Object} url к какому URL
   * @param {Function} [func]
   * @param {String} [data|err]
   * @param {String} [data]
   * @return String|XMLHttpRequest|ActiveXObject
   ###
  load: (url, func, err, data) ->
    if typeof url is 'object'
      func = url.scs if 'scs' of url
      func = erl.success if 'success' of url
      err = url.err if 'err' of url
      err = url.error if 'error' of url
      data = url.data if 'data' of url
      method = url.method if 'method' of url
      header = url.header if 'header' of url
      url = url.url
    else if typeof err is 'object'
      data = err
    active = -1
    i = 0
    errorTex = ''
    while i < @_rPool.length
      if @_rPool[i]["state"] is 0
        active = i
        @_rPool[i]["state"] = 1
        break
      i++
    if active < 0
      active = @_rPool.length
      @_rPool[active] =
        ajax: null
        state: 1
        func: null
        err: null
    unless @_rPool[active].ajax
      @_rPool[active].ajax = null
      if @_debug
        if 'XMLHttpRequest' of window
          try
            @_rPool[active].ajax = new XMLHttpRequest()
          catch e
            errorTex += "Cant't create XMLHttpRequest object, but XMLHttpRequest exists. Error: #{e.message}"
            @log e.message
        else if window.ActiveXObject
          try
            @_rPool[active].ajax = new ActiveXObject("Msxml2.XMLHTTP")
          catch e
            try
              @_rPool[active].ajax = new ActiveXObject("Microsoft.XMLHTTP")
            catch e
              errorTex += "Cant't create ActiveXObject object, but ActiveXObject exists. Error: #{e.message}"
              @log e.message
      else
        @_rPool[active].ajax = if 'XMLHttpRequest' of window then new XMLHttpRequest() else new ActiveXObject("Microsoft.XMLHTTP")
      @_rPool[active].ajax.onreadystatechange = =>
        xhr = {}
        `var xhr = this`
        try
          if xhr.readyState is 4
            active = xhr["active"]
            # для статуса "OK"
            if xhr.status is 200 || (xhr.status is 0 and xhr.responseText.length > 0) #в windows при открытии локальных файлов статус 0, но текст есть
              @_rPool[active].func xhr.responseText, xhr.getAllResponseHeaders()
            else
              @_rPool[active].err xhr.statusText
            @_rPool[active].state = 0
        catch e
          @log e.message + "\n" + e.toSource()
        true
    else if errorTex isnt ''
      @_rPool[active]["state"] = 0
      return errorTex
    if @_rPool[active].ajax
      @_rPool[active].func = func
      @_rPool[active].err = if err then err else -> true
      @_rPool[active].ajax["active"] = active
      @_rPool[active].state = 1
      unless data?
        d = if @_counterEnabled then ((if url.indexOf("?") > 0 then '&' else '?') + 'cOuNtEr=' + @_counter++) else ''
        @_rPool[active].ajax.open method || "GET", url + d, true
        if header
          for label, value of header
            @_rPool[active].ajax.setRequestHeader label, value
        @_rPool[active].ajax.send null
      else
        @_rPool[active].ajax.open method || "POST", url, true
        @_rPool[active].ajax.setRequestHeader "Content-length", data.length
        @_rPool[active].ajax.setRequestHeader "Content-type", "application/x-www-form-urlencoded"
        if header
          for label, value of header
            @_rPool[active].ajax.setRequestHeader label, value
        @_rPool[active].ajax.send data
      return @_rPool[active].ajax
    errorTex or "err"
#------------------------------------------------    start bubble
  ###*
   * Создаём бабл в центре экрана с шириной w и высотой h, с содержимым html
   * В опции можно передать:
   *   close: function наступает при закрытии окна
   *   resize: Boolean определяет, подгонять ли высоту по содержимому, если не умещается внутри
   *
   * TODO: сделать, чтобы в html можно было передать Element
   * @param {string} html
   * @param {Number} [w] = 300
   * @param {Number} [h] = 200
   * @param {Object} [options] см выше
   * @return Boolean|HSF
   ###
  createBubble: (html, w = 300, h = 200, options = {}) ->
    return false  unless html
    @closeBubble()
    bubble = @GBI("bubbleItem")
    bubbleContainer = null
    ws = @getSize()
    unless bubble #если бабла нет... Создаём!))
      #получаем максимальный z-index для родителя бэкграунда
      bodyChildrens = document.body.children
      zIndex = 10
      i = 0

      @
        .setCSS('.bubbleItem',
          'background-color': 'white'
          'font-family': 'Verdana, "Geneva CY", "DejaVu Sans", sans-serif'
          'font-size': '80%'
        )
        .setCSS('.bubbleItem .closeBtn',
          cursor: 'pointer',
          float: 'right'
          width: '12px'
        )
        .setCSS('.bubbleItem .bubbleContainer',
          'margin': '19px 10px 0'
          'text-align': 'left'
        )
        .setCSS('.bubbleItem .alertBubble',
          overflow: 'hidden'
        )
        .setCSS('.bubbleItem .alertBubble > button[onclick]',
          'float': 'right'
          'margin-right': '10px'
          'margin-top': '10px'
        )

      #создаём бэкграунд
      bg = @createElement('#bubbleBG',{style:{
        display: 'block'
        position: 'fixed'
        left: 0
        right: 0
        top: 0
        bottom: 0
        zIndex: zIndex
        backgroundColor: '#ccc'
        opacity: '0.5'
      }},document.body)

      while i < bodyChildrens.length
        bc = bodyChildrens[i]
        if bc?
          zi = @toInt(@getStyle(bc, "zIndex"))
        else
          zi = 0
        zIndex = zi + 1  if zi > zIndex
        i++
      bg.style.zIndex = zIndex

      #создаём сам бабл
      bubble = @createElement("#bubbleItem.bubbleItem", {
        style:
          position: 'fixed'
        close: =>
          bg.style.display = "none"
          bubble.style.display = "none"
          bubbleContainer.innerHTML = ""
          func = @getMem(bubble, "func")
          if func isnt null
            func()
            @setMem bubble, "func", null
      },
      document.body)
      bubble.style.zIndex = zIndex + 1

      #кнопка закрытия
      closeBtn = @createElement(".closeBtn",{innerHTML:'X',onclick:bubble.close},bubble)
      bg.onclick = bubble.close

      #контейнер для текста
      bubbleContainer = @createElement(".bubbleContainer",{},bubble)
      @setOnResize bg, =>
        bubble = @GBI("bubbleItem")
        ws = @getSize()
        l = (ws.w - parseInt(bubble.style.width)) / 2
        t = (ws.h - parseInt(bubble.style.height)) / 2
        if l < 0
          l = 0
        else
          l += "px"
        if t < 0
          t = 0
        else
          t += "px"
        bubble.style.left = l
        bubble.style.top = t

      @keyListener 'esc', =>
        @closeBubble()

    bubble.style.width = w + "px"
    bubble.style.height = h + "px"
    l = (ws.w - w) / 2
    t = (ws.h - h) / 2
    if l < 0
      l = 0
    else
      l += "px"
    if t < 0
      t = 0
    else
      t += "px"
    bubble.style.left = l
    bubble.style.top = t
    bubbleContainer = bubble.getElementsByTagName("div")[1]  if bubbleContainer is null
    bubbleContainer.style.overflowY = ''
    if typeof html is "string"
      bubbleContainer.innerHTML = html
    else if typeof html is "object" and "nodeType" of html
      bubbleContainer.innerHTML = ""
      bubbleContainer.appendChild html
    else
      return false
    bubble.style.display = "block"
    bg = @GBI("bubbleBG")
    bg.style.display = "block"

    if "close" of options
      @setMem bubble, "func", options.close
    else
      @setMem bubble, "func", null
    if 'loader' of options and options.loader
      @setTempStyle(f.GBC('closeBtn', bubble)[0], {display: 'none'}, 'loader')
      img = f.GBT('img', bubble)[0]
      bubble.style.left = ws.w / 2 - img.offsetWidth + 'px'
      bubble.style.top = ws.h / 2 - img.offsetHeight + 'px'
      f.GBI('bubbleBG').onclick = null
      f.setMem(bubble, 'flagLoader', true)
    else if f.getMem(bubble, 'flagLoader')
      @retTempStyle(f.GBC('closeBtn', bubble)[0], 'loader')
      f.GBI('bubbleBG').onclick = bubble.close
      f.setMem(bubble, 'flagLoader', false)
    if 'resize' of options and options.resize
      bgh = bg.offsetHeight
      if bubbleContainer.children[0].offsetHeight + bubble.children[0].offsetHeight > bubble.offsetHeight
        if bubbleContainer.children[0].offsetHeight < bgh - 20
          hght = bubbleContainer.children[0].offsetHeight + bubble.children[0].offsetHeight + 20
          h = if hght > h then hght else h
          bubble.style.top = "#{(ws.h - h) / 2}px"
          bubble.style.height = h + 'px';
        else
          bubble.style.height = "#{bgh-20}px"
          bubble.style.top = '10px'
          bubbleContainer.style.overflowY = 'scroll'
    @

  ###*
   * закрывает бабл
   * @return Boolean|Element
   ###
  closeBubble: ->
    @GBI("bubbleItem").close()  if @GBI("bubbleItem")
    @

  ###*
   * Возвращает бабл, если он есть или null
   * @return Element|NULL
   ###
  getBubble: ->
    @GBI("bubbleItem")|| null

  ###*
   * Создаёт бабл, который появляется при загрузке.
   * TODO: сделать так, чтобы в качестве img можно было передавать Element
   * @param {string} img
   * @return Boolean|HSF
   ###
  createLoaderBubble: (img = @_defaultLoader) ->
    @createBubble "<div style='text-align:center;margin-top:50px;'><img src='#{img}' alt='ajax-loader'/></div>", 0, 0, {loader: true}

  ###*
   * аналог alert, но не блокирует все скрипты.
   * @param {String} text путь к картинке
   * @return Boolean|HSF
   ###
  createAlertBubble: (text, option = {}) ->
    option.resize = true
    @createBubble "<div class=\"alertBubble\"><span>#{text}</span><button onclick=\"#{@getThis()}.closeBubble();\">Ok</button></div>", 400, 60, option
#------------------------------------------------    end bubble
  ###
  # Calculate the md5 hash of a string
  #
  # +   original by: Webtoolkit.info (http://www.webtoolkit.info/)
  # + namespaced by: Michael White (http://crestidg.com)
  ###

  ###*
   * md5 сумму подсчитывает по строке.
   * @param {String} str
   * @return String
   ###
  md5: (str) ->
    RotateLeft = (lValue, iShiftBits) ->
      (lValue << iShiftBits) | (lValue >>> (32 - iShiftBits))

    AddUnsigned = (lX, lY) ->
      lX8 = (lX & 0x80000000)
      lY8 = (lY & 0x80000000)
      lX4 = (lX & 0x40000000)
      lY4 = (lY & 0x40000000)
      lResult = (lX & 0x3FFFFFFF) + (lY & 0x3FFFFFFF)
      return (lResult ^ 0x80000000 ^ lX8 ^ lY8)  if lX4 & lY4
      if lX4 | lY4
        if lResult & 0x40000000
          lResult ^ 0xC0000000 ^ lX8 ^ lY8
        else
          lResult ^ 0x40000000 ^ lX8 ^ lY8
      else
        lResult ^ lX8 ^ lY8

    F = (x, y, z) ->
      (x & y) | ((~x) & z)

    G = (x, y, z) ->
      (x & z) | (y & (~z))

    H = (x, y, z) ->
      x ^ y ^ z

    I = (x, y, z) ->
      y ^ (x | (~z))

    FF = (a, b, c, d, x, s, ac) ->
      a = AddUnsigned(a, AddUnsigned(AddUnsigned(F(b, c, d), x), ac))
      AddUnsigned RotateLeft(a, s), b

    GG = (a, b, c, d, x, s, ac) ->
      a = AddUnsigned(a, AddUnsigned(AddUnsigned(G(b, c, d), x), ac))
      AddUnsigned RotateLeft(a, s), b

    HH = (a, b, c, d, x, s, ac) ->
      a = AddUnsigned(a, AddUnsigned(AddUnsigned(H(b, c, d), x), ac))
      AddUnsigned RotateLeft(a, s), b

    II = (a, b, c, d, x, s, ac) ->
      a = AddUnsigned(a, AddUnsigned(AddUnsigned(I(b, c, d), x), ac))
      AddUnsigned RotateLeft(a, s), b

    ConvertToWordArray = (str) ->
      lMessageLength = str.length
      lNumberOfWords_temp1 = lMessageLength + 8
      lNumberOfWords_temp2 = (lNumberOfWords_temp1 - (lNumberOfWords_temp1 % 64)) / 64
      lNumberOfWords = (lNumberOfWords_temp2 + 1) * 16
      lWordArray = new Array(lNumberOfWords - 1)
      lBytePosition = 0
      lByteCount = 0
      while lByteCount < lMessageLength
        lWordCount = (lByteCount - (lByteCount % 4)) / 4
        lBytePosition = (lByteCount % 4) * 8
        lWordArray[lWordCount] = (lWordArray[lWordCount] | (str.charCodeAt(lByteCount) << lBytePosition))
        lByteCount++
      lWordCount = (lByteCount - (lByteCount % 4)) / 4
      lBytePosition = (lByteCount % 4) * 8
      lWordArray[lWordCount] = lWordArray[lWordCount] | (0x80 << lBytePosition)
      lWordArray[lNumberOfWords - 2] = lMessageLength << 3
      lWordArray[lNumberOfWords - 1] = lMessageLength >>> 29
      lWordArray

    WordToHex = (lValue) ->
      WordToHexValue = ""
      WordToHexValue_temp = ""
      lCount = 0
      while lCount <= 3
        lByte = (lValue >>> (lCount * 8)) & 255
        WordToHexValue_temp = "0" + lByte.toString(16)
        WordToHexValue = WordToHexValue + WordToHexValue_temp.substr(WordToHexValue_temp.length - 2, 2)
        lCount++
      WordToHexValue

    S11 = 7
    S12 = 12
    S13 = 17
    S14 = 22
    S21 = 5
    S22 = 9
    S23 = 14
    S24 = 20
    S31 = 4
    S32 = 11
    S33 = 16
    S34 = 23
    S41 = 6
    S42 = 10
    S43 = 15
    S44 = 21
    str = @utf8_encode(str)
    x = ConvertToWordArray(str)
    a = 0x67452301
    b = 0xEFCDAB89
    c = 0x98BADCFE
    d = 0x10325476
    k = 0
    while k < x.length
      AA = a
      BB = b
      CC = c
      DD = d
      a = FF(a, b, c, d, x[k + 0], S11, 0xD76AA478)
      d = FF(d, a, b, c, x[k + 1], S12, 0xE8C7B756)
      c = FF(c, d, a, b, x[k + 2], S13, 0x242070DB)
      b = FF(b, c, d, a, x[k + 3], S14, 0xC1BDCEEE)
      a = FF(a, b, c, d, x[k + 4], S11, 0xF57C0FAF)
      d = FF(d, a, b, c, x[k + 5], S12, 0x4787C62A)
      c = FF(c, d, a, b, x[k + 6], S13, 0xA8304613)
      b = FF(b, c, d, a, x[k + 7], S14, 0xFD469501)
      a = FF(a, b, c, d, x[k + 8], S11, 0x698098D8)
      d = FF(d, a, b, c, x[k + 9], S12, 0x8B44F7AF)
      c = FF(c, d, a, b, x[k + 10], S13, 0xFFFF5BB1)
      b = FF(b, c, d, a, x[k + 11], S14, 0x895CD7BE)
      a = FF(a, b, c, d, x[k + 12], S11, 0x6B901122)
      d = FF(d, a, b, c, x[k + 13], S12, 0xFD987193)
      c = FF(c, d, a, b, x[k + 14], S13, 0xA679438E)
      b = FF(b, c, d, a, x[k + 15], S14, 0x49B40821)
      a = GG(a, b, c, d, x[k + 1], S21, 0xF61E2562)
      d = GG(d, a, b, c, x[k + 6], S22, 0xC040B340)
      c = GG(c, d, a, b, x[k + 11], S23, 0x265E5A51)
      b = GG(b, c, d, a, x[k + 0], S24, 0xE9B6C7AA)
      a = GG(a, b, c, d, x[k + 5], S21, 0xD62F105D)
      d = GG(d, a, b, c, x[k + 10], S22, 0x2441453)
      c = GG(c, d, a, b, x[k + 15], S23, 0xD8A1E681)
      b = GG(b, c, d, a, x[k + 4], S24, 0xE7D3FBC8)
      a = GG(a, b, c, d, x[k + 9], S21, 0x21E1CDE6)
      d = GG(d, a, b, c, x[k + 14], S22, 0xC33707D6)
      c = GG(c, d, a, b, x[k + 3], S23, 0xF4D50D87)
      b = GG(b, c, d, a, x[k + 8], S24, 0x455A14ED)
      a = GG(a, b, c, d, x[k + 13], S21, 0xA9E3E905)
      d = GG(d, a, b, c, x[k + 2], S22, 0xFCEFA3F8)
      c = GG(c, d, a, b, x[k + 7], S23, 0x676F02D9)
      b = GG(b, c, d, a, x[k + 12], S24, 0x8D2A4C8A)
      a = HH(a, b, c, d, x[k + 5], S31, 0xFFFA3942)
      d = HH(d, a, b, c, x[k + 8], S32, 0x8771F681)
      c = HH(c, d, a, b, x[k + 11], S33, 0x6D9D6122)
      b = HH(b, c, d, a, x[k + 14], S34, 0xFDE5380C)
      a = HH(a, b, c, d, x[k + 1], S31, 0xA4BEEA44)
      d = HH(d, a, b, c, x[k + 4], S32, 0x4BDECFA9)
      c = HH(c, d, a, b, x[k + 7], S33, 0xF6BB4B60)
      b = HH(b, c, d, a, x[k + 10], S34, 0xBEBFBC70)
      a = HH(a, b, c, d, x[k + 13], S31, 0x289B7EC6)
      d = HH(d, a, b, c, x[k + 0], S32, 0xEAA127FA)
      c = HH(c, d, a, b, x[k + 3], S33, 0xD4EF3085)
      b = HH(b, c, d, a, x[k + 6], S34, 0x4881D05)
      a = HH(a, b, c, d, x[k + 9], S31, 0xD9D4D039)
      d = HH(d, a, b, c, x[k + 12], S32, 0xE6DB99E5)
      c = HH(c, d, a, b, x[k + 15], S33, 0x1FA27CF8)
      b = HH(b, c, d, a, x[k + 2], S34, 0xC4AC5665)
      a = II(a, b, c, d, x[k + 0], S41, 0xF4292244)
      d = II(d, a, b, c, x[k + 7], S42, 0x432AFF97)
      c = II(c, d, a, b, x[k + 14], S43, 0xAB9423A7)
      b = II(b, c, d, a, x[k + 5], S44, 0xFC93A039)
      a = II(a, b, c, d, x[k + 12], S41, 0x655B59C3)
      d = II(d, a, b, c, x[k + 3], S42, 0x8F0CCC92)
      c = II(c, d, a, b, x[k + 10], S43, 0xFFEFF47D)
      b = II(b, c, d, a, x[k + 1], S44, 0x85845DD1)
      a = II(a, b, c, d, x[k + 8], S41, 0x6FA87E4F)
      d = II(d, a, b, c, x[k + 15], S42, 0xFE2CE6E0)
      c = II(c, d, a, b, x[k + 6], S43, 0xA3014314)
      b = II(b, c, d, a, x[k + 13], S44, 0x4E0811A1)
      a = II(a, b, c, d, x[k + 4], S41, 0xF7537E82)
      d = II(d, a, b, c, x[k + 11], S42, 0xBD3AF235)
      c = II(c, d, a, b, x[k + 2], S43, 0x2AD7D2BB)
      b = II(b, c, d, a, x[k + 9], S44, 0xEB86D391)
      a = AddUnsigned(a, AA)
      b = AddUnsigned(b, BB)
      c = AddUnsigned(c, CC)
      d = AddUnsigned(d, DD)
      k += 16
    temp = WordToHex(a) + WordToHex(b) + WordToHex(c) + WordToHex(d)
    temp.toLowerCase()
  ###*
   * Функция кодирует в utf8 нужна для md5
   * @param {String} str_data
   * @return String
   ###
  utf8_encode: (str_data) ->
    str_data = str_data.replace(/\r\n/g, "\n")
    utftext = ""
    n = 0

    while n < str_data.length
      c = str_data.charCodeAt(n)
      if c < 128
        utftext += String.fromCharCode(c)
      else if (c > 127) and (c < 2048)
        utftext += String.fromCharCode((c >> 6) | 192)
        utftext += String.fromCharCode((c & 63) | 128)
      else
        utftext += String.fromCharCode((c >> 12) | 224)
        utftext += String.fromCharCode(((c >> 6) & 63) | 128)
        utftext += String.fromCharCode((c & 63) | 128)
      n++
    utftext

  ###*
   * Создаёт элемент по шаблону tag с свойствами из option и прикрепляет в parent
   * последовательность важна! Сначала тэг, потом ID и уже потом имена классов
   * @param {String} tag [tagName][#tagId][.tagClass1][.tagClass2][...]
   * @param {Object} [option] ограничение на вложенные свойство. Не распространяется на style
   * @param {Element} [parent]
   * @return Element
   ###
  createElement: (tag, option = {}, parent) ->
    if /^\w+$/.test tag
      el = document.createElement(tag)
    else
      regRes = tag.match(/^(\w+)?(#(.*?))?(\.(.*))?$/)
      tagName = regRes[1] || 'div';
      el = document.createElement(tagName)
      el.id = regRes[3] if typeof regRes[3] is 'string'
      el.className = regRes[5].replace(/[\.\s]/, ' ') if typeof regRes[5] is 'string'
    if 'style' of option
      for own key, val of option.style
        el.style[key] = val
      delete option.style
    el[key] = val for own key, val of option
    parent.appendChild(el) if parent
    el

  ###*
   * прикрепляет к parent ребёнка из дочерний элемент el
   * Если el строка, то это равносильно parent.innerHTML += el, но не ломается DOM-модель
   * @param {Element} parent
   * @param {Element|String} el
   * @return Array массив элементов
   ###
  appendChild: (parent, el) ->
    if typeof el is 'string'
      div = document.createElement('div')
      div.innerHTML = el
      elems = []
      i = 0
      l = div.childNodes.length
      el = []
      while i < l
        el[el.length] = div.childNodes[0]
        parent.appendChild(div.childNodes[0])
        i++
      div = null
      return el
    else if typeof el is 'object' and 'nodeType' of el
      parent.appendChild el
    else
      throw new Error('el must be string or element')
    [el]

  ###*
  * удаляет элемент el из общего DOM
  * @param {Element} el
  ###
  removeElement: (el) ->
    el.parentNode.removeChild(el)
    @

  ###*
   * заменяет элемент el на newEl
   * @param {Element} el
   * @param {Element} newEl
   ###
  replaceElement: (el, newEl) ->
    el.parentNode.replaceChild(newEl, el)
    @

  ###*
   * Очищает элемент. Как оказалось innerHTML = '' довольно затратная операция
   * @param {Element} el
   ###
  clearElement: (el) ->
    childs = el.childNodes
    i = childs.length
    while i--
      el.removeChild(childs[i])
      delete childs[i]
    @

  ###*
   * Устанавливает стиль по имени вне зависимости от префиксов, если стиль вообще существует.
   * имя стилей следует преобразовывать в CamelCase c маленькой буквы
   * @param   {Element}           el
   * @param   {String}            name имя в стиле borderRadius
   * @param   {String|Number}     value
   * @return  Boolean
   ###
  setUniversalStyle: (el, name, value) ->
    name = name.toLowerCase()
    unless name of @_setUniversalStyleCascade
      @_setUniversalStyleCascade[name] = []
      for style of el.style
        if typeof style is 'string'
          index = style.toLowerCase().indexOf(name)
          if index >= 0 and index + name.length is style.length and style.substr(0, index).toLowerCase() in @_stylePrefixes
            @_setUniversalStyleCascade[name].push(style)
      if @.browser().name is 'safari'
        @_setUniversalStyleCascade[name].push(name) if name of el.style
        webkitName = "webkit" + name.substr(0, 1).toUpperCase() + name.substr(1)
        @_setUniversalStyleCascade[name].push(webkitName) if webkitName of el.style
    for styleName in @_setUniversalStyleCascade[name]
      try el.style[styleName] = value
    true

  ###*
   * Устанавливает, есть ли в элементе el потомок child
   * @param   {Element}   el
   * @param   {Element}   child
   * @return  Boolean
   ###
  hasElement: (el, child) ->
    return true if el is child
    parent = child.parentNode;
    return false if not parent or not parent.parentNode
    html = document.getElementsByTagName('html')[0]
    while(parent isnt el)
      return false if parent is html or parent.parentNode is html
      parent = parent.parentNode
    true

  ###*
   * Возвращает количество свойств объекта
   * @param {Object} obj
   * @return Number
   ###
  oSize: (obj) ->
    return Object.keys(obj).length  if "keys" of Object
    s = 0
    s++ for own k of obj
    s

  ###*
   * Возвращает ключи объекта
   * @param {Object} obj
   * @return Array
   ###
  oKeys: (obj) ->
    return Object.keys(obj) if "keys" of Object
    res = []
    for own k of obj
      res[res.length] = k
    res
#------------------------------------------------    start resize
  ###*
   * Устанавливает отслеживание изменение размеров элементов в документе.
   * Работает через единый таймер или через onresize
   * Если объект активируется повторно и нет funcName, то использыется прежняяфункция
   * @param {Element} el элемент
   * @param {Function} [funcName] callback фенкция, вызываемая при изменении размеров
   * @return Number|Boolean
   ###
  setOnResize: (el, funcName) ->
    pos = @getMem el, "resizePos"
    if pos isnt null #если уже иинициировался
      col = @_onResizeCollection[pos]
      if funcName
        col.func = funcName
      if col.type is 1
        col.action = @addEvent(el, 'resize', col.func)
      else
        @_onResizeArray[@_onResizeArray.length] = pos
      return pos

    pos = @_onResizeCollection.length
    if "onresize" of el
      @_onResizeCollection[pos] =
        el: el
        func: funcName
        type: 1
        action: @addEvent(el, 'resize', funcName)
      return pos
    #только объекты
    return -1  unless typeof el is "object"
    #только одиночные элементы DOM
    return -1  unless "nodeType" of el

    @_onResizeCollection[pos] =
      el: el
      func: funcName
      type: 0
      action: null #for V8
    @_onResizeArray[@_onResizeArray.length] = pos

    @setMem el, "ow", el.offsetWidth
    @setMem el, "oh", el.offsetHeight
    @setMem el, "resizePos", pos
    window.setInterval =>
      @resizeObjects()
    , 42
    pos

  ###*
   * Таймер отслеживает изменения по номерам позиции.
   * @private
   ###
  resizeObjects: ->
    for position in @_onResizeArray
      el = @_onResizeCollection[position]
      ow = @getMem el.el, "ow"
      oh = @getMem el.el, "oh"
      if ow isnt el.el.offsetWidth or oh isnt el.el.offsetHeight
        @setMem el.el, "ow", el.el.offsetWidth
        @setMem el.el, "oh", el.el.offsetHeight
        el.func.call el.el, position
    true

  ###*
   * Выключает таймер по позиции, которая возвращалась в setOnResize
   * @param {Number} pos
   * @return Object
   ###
  offOnResize: (pos) ->
    col = @_onResizeCollection[pos]
    if col.type is 1
      col.action()
    else
      return col unless pos in @_onResizeArray
      na = []
      na[na.length] = position for position in @_onResizeArray when pos isnt position
      @_onResizeArray = na
    col
#------------------------------------------------    end resize

#------------------------------------------------    start className

  ###*
   * Добавляет к элементу название класса
   * @param {Element} el
   * @param {String} className
   * @return Element
   ###
  addClassName: (el, className) ->
    el.className += " #{className.trim()}" unless @hasClassName(el, className)
    @

  ###*
   * Определяет, имеет ли документ определённый класс
   * @param {Element} el
   * @param {String} className
   * @return Boolean
   ###
  hasClassName: (el, className) ->
    not (" #{el.className} ".indexOf(" #{className.trim()} ") < 0)

  ###*
   * Удаляет у элемента название класса
   * @param {Element} el
   * @param {String}  className
   * @return Element
   ###
  removeClassName: (el, className) ->
    el.className = (" #{el.className} ").replace(" #{className.trim()} ", " ").trim()  if @hasClassName(el, className)
    @

  ###*
   * синоним для removeClassName
   * @param   {Element} el
   * @param   {String}  className
   * @return  Element
   ###
  delClassName: (el, className) =>
    @removeClassName el, className
#------------------------------------------------    end className
  ###*
   * Получить родителя по тэгу
   * @param   {Element} el
   * @param   {String}  tagName
   * @return  Element|Null
   ###
  GPT: (el, tagName) ->
    tagName = tagName.toLowerCase()
    return document.getElementsByTagName(tagName)[0] or null  if tagName is "html" or tagName is "body"
    return null if not el or not el.parentNode
    el = el.parentNode  while el?.parentNode?.tagName? and el.parentNode.tagName.toLowerCase() isnt tagName and el.parentNode.tagName.toLowerCase() isnt 'html'
    return null if not ("parentNode" of el) or el.tagName.toLowerCase() is 'html' or el.parentNode.tagName.toLowerCase() is 'html'
    el.parentNode

  ###*
   * Получить родителя по имени класса
   * @param   {Element} el
   * @param   {String}  className
   * @return  Element|Null
   ###
  GPC: (el, className) ->
    return null if not el
    while el and el.parentNode
      el = el.parentNode
      return el if @hasClassName(el, className)
    null
#------------------------------------------------    start truncateStrng
  ###*
   * Обрезает строку, если она больше и прибавляет к ней многоточие
   * @param   {String}  string
   * @param   {Number}  len
   * @param   {String}  [after] что ставится после обрезанной строки
   * @return  String
   ###
  truncateStringMin: (string, len, after = '...') ->
    return string.substr(0, len - after.length) + after if len < string.length
    string

  ###*
   * Более умное обрезание строки: ищет пробелы в промежутке от dMax до uMax.
   * Если пробел не найден в этом промежутке, то ищет его в меньшую сторону
   * TODO: могут быть не только пробелы, а любые разделяющие символы и при этом скорость не должна упасть
   * @param   {String}  string
   * @param   {Number}  dMax
   * @param   {Number}  uMax
   * @param   {String}  [after]
   * @return  String
   ###
  truncateString: (string, dMax, uMax, after = '...') ->
    newStr = ""
    dSpace = -1
    uSpace = -1
    minChars = Math.floor(string.length * 0.6)
    criticalMinChars = Math.floor(string.length * 0.35)
    string = string.trim()
    dMax = dMax - after.length
    uMax = uMax - after.length
    i = dMax
    j = dMax

    while i < uMax and i < string.length and j >= 0
      dSpace = i  if /\W/.test(string.charAt(i)) and dSpace < 0
      uSpace = j  if /\W/.test(string.charAt(j)) and uSpace < 0
      break  if uSpace >= 0 and dSpace >= 0
      i++
      j--

    #возможно 3 варианта выхода:
    #строка короче dMax
    return string  if string.length < dMax

    #пробел до максимума найден
    if dSpace > 0
      if dSpace < minChars
        if uSpace < uMax and uSpace > 0
          newStr = string.substr(0, uSpace) + after
        else if dSpace < criticalMinChars
          newStr = string.substr(0, dMax) + after
        else
          newStr = string.substr(0, dSpace) + after
      else
        newStr = string.substr(0, dSpace) + after

      #пробел найден после максимума
    else if uSpace > 0
      if uSpace < uMax
        newStr = string.substr(0, uSpace) + after
      else
        newStr = string.substr(0, dMax) + after
    else
      if string.length > dMax and string.length < uMax
        newStr = string
      else
        newStr = string.substr(0, dMax) + after
    newStr

  ###*
   * получает ширину символа chart размера fs и шрифта ff
   * в кирилице максимальную букву лучше брать Ю
   * @param   {Number} [fs]    =  11
   * @param   {String} [ff]    =  "Tahoma"
   * @param   {String} [chart] =  "m"
   * @return  Number
   ###
  getCharWidthMax: (fs, ff, chart) ->
    ff = ff or "Tahoma"
    fs = fs or 11
    chart = chart or "m"
    window.charWidth = {}  unless window.charWidth
    window.charWidth[ff] = {}  unless ff of window.charWidth
    unless fs of window.charWidth[ff]
      charEl = @GBI("charEl")
      unless charEl
        charEl = @createElement("#charEl", {innerHTML: chart}, document.body)
      charEl.style.fontFamily = ff
      charEl.style.fontSize = fs + "px"
      window.charWidth[ff][fs] = charEl.offsetWidth
    window.charWidth[ff][fs]

  ###*
   * Добавление сообщения в лог
   * @param   {String}    message
   * @param   {String}    [type] = 'log'
   * @return  Boolean
   ###
  log: (message, type = 'log') ->
    str = ((new Date()).getTime() - @_startLogDate).toString()
    @_stackLog[@_stackLog.length] =
      time: str
      mess: "#{type}: #{message}"

    if "console" of window
      console = window.console
      switch type
        when 'log'
          func = console.log
        when 'info'
          if 'info' of console then func = console.info else str = 'INFO: ' + str
        when 'err', 'error'
          if 'error' of console then func = console.error else str = "ERROR: #{str}"
        when 'warn', 'warning'
          if 'warn' of console then func = console.warn else str = "WARN: #{str}"
        when 'debug'
          if 'debug' of console then func = console.debug else str = "DEBUG: #{str}"
        else
          str = "#{type}: #{str}"
      unless func
        func = console.log
      if typeof func isnt "function" #ie console.log is object
        func str + ": #{message}"
      else
        func.call console, str + ": #{message}"
    else if @_debug
      alert "#{type}: #{str}: #{message}"
    true

  ###*
     * Работает аналогично time в linux: считает кол-во мс, которое тратит на себя функция
     * @param   {String}    message
     * @return  Boolean
     ###
  time: (func, renderAfter) ->
    @log 'start time'
    start = (new Date()).getTime()
    func()
    @log "finish time at #{(new Date()).getTime() - start}ms"
    if renderAfter is true
      @log 'render start'
      start = (new Date()).getTime()
      t = document.body.offsetWidth
      @log "finish render at #{(new Date()).getTime() - start}ms"
    return

  ###*
   * Выводит лог на экран в виде линии событий и времён
   * TODO: сделать наведение более логичным и не зависящим от общей длины шкалы времени
   * @return Boolean
   ###
  printLog: ->
    lenTime = 8
    html = '<table id="printLog" cellpadding="0" cellspacing="0" style="border:0;"><tr><td valign="top" align="left" style="width:40px">'
    tl = ''
    str = '<ul style="font-family:monospace;list-style:none outside none;margin:0;padding:0;">'
    height = 0
    for own time in @_stackLog
      timeString = "#{time.time}"
      timeString += '.' for n in [lenTime..timeString.length]
      tl += "<div id='dotLogPoint#{time}' onmouseover=\"#{@getThis()}.selectLogPoint(this);\" onmouseout=\"#{@getThis()}.unselectLogPoint(this);\" style='position:absolute;right:-4px;top:"+(@toInt(time)-4)+"px;border:1px solid #339;border-radius:3px;width:5px;height:5px;cursor:pointer;z-index:1'></div>"
      str += "<li id='textLogPoint#{time}' onmouseover=\"#{@getThis()}.selectLogPoint(this);\" onmouseout=\"#{@getThis()}.unselectLogPoint(this);\" style='cursor:pointer;text-align:left;'><b>#{timeString}:</b> #{time.mess}</li>"
      height += 20
    str += '</ul>'
    tl0 = "<div style='position:relative;border-right:1px solid #339;width:20px;height:"+parseInt(time*100)+"px'>"
    html += tl0 + tl + "</div></td><td>#{str}</td></tr></table>"
    @createBubble(html,600,50, {resize: on})
    true

  ###*
   * Выделяет определённую строку при наведении на строчку
   * @param   {Element}  el
   * @return  Boolean
   * @private
   ###
  selectLogPoint: (el) ->
    res = el.id.match(/(.*)LogPoint(.*)/)
    return false unless res
    if res[1] is 'dot'
      secEl = @GBI "textLogPoint#{res[2]}"
      secEl.style.textDecoration = 'underline'
      el.style.backgroundColor = '#f0f'
      el.style.borderColor = '#f0f'
      el.style.zIndex = 10
    else
      secEl = @GBI "dotLogPoint#{res[2]}"
      secEl.style.backgroundColor = '#f0f'
      secEl.style.borderColor = '#f0f'
      secEl.style.zIndex = 10
      el.style.textDecoration = 'underline'
    true

  ###*
   * Снимает выделение с определённой строки
   * @param   {Element}  el
   * @return  Boolean
   * @private
   ###
  unselectLogPoint: (el) ->
    res = el.id.match(/(.*)LogPoint(.*)/)
    return false unless res
    if res[1] is 'dot'
      secEl = @GBI "textLogPoint#{res[2]}"
      secEl.style.textDecoration = 'none'
      el.style.backgroundColor = 'transparent'
      el.style.borderColor = '#339'
      el.style.zIndex = 1
    else
      secEl = @GBI "dotLogPoint#{res[2]}"
      secEl.style.backgroundColor = 'transparent'
      secEl.style.borderColor = '#339'
      secEl.style.zIndex = 1
      el.style.textDecoration = 'none'
    true

  ###*
   * Парсит JSON строку в JS объект по RFC 4627 или "родными" средствами
   * @param   {String} text
   * @return  Object|Array|Boolean|Number|String|Null
   ###
  parseJSON: (text) ->
    return JSON.parse(text)  if "JSON" of window and "parse" of JSON
    not (/[^,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]/.test(text.replace(/"(\\.|[^"\\])*"/g, ""))) and eval("(#{text})")

  ###*
   * Преобразует объект в JSON строку
   * @param   {Object|Array|Boolean|Number|String|Null} obj
   * @return  String
   ###
  varToJSON: (obj) ->
    return JSON.stringify(obj) if "JSON" of window and "stringify" of JSON
    _ret = ""
    _a = ""
    switch typeof obj
      when "string"
        return '"' + obj + '"'
      when "number", "boolean"
        return obj.toString()
      when "object"
        if obj instanceof Array
          _ret = "["
          i = 0
          for el in obj
            switch typeof el
              when "string"
                _ret += _a + '"' + el + '"'
              when "boolean", "number"
                _ret += _a + el
              when "object"
                _ret += _a + varToJSON(el)
            _a = ","
            i++
          _ret += "]"
        else if obj is null
          return "null"
        else
          _ret = "{"
          for own i of obj
            continue  unless obj.hasOwnProperty(i)
            _ret2 = null
            switch typeof obj[i]
              when "string"
                _ret2 = '"' + obj[i] + '"'
              when "boolean", "number"
                _ret2 = obj[i]
              when "object"
                _ret2 = varToJSON(obj[i])
            if _ret2?
              _ret += _a + '"' + i + '":' + _ret2
              _a = ","
          _ret += "}"
    _ret

  ###*
   * получает внешнюю обёртку тэга более кроссбраузерно, чем обращение к outerHTML
   * @param {Element} el
   * @return String|Boolean
   ###
  outerHTML: (el) ->
    return el.outerHTML or ('XMLSerializer' of window and new XMLSerializer().serializeToString(el)) or false;

  ###*
   * заполняет спереди нулями number до длины width
   * @param   {Number}  number
   * @param   {Number}  width
   * @return  String
   ###
  zeroFill: (number, width) ->
    width -= number.toString().length
    return new Array(width + ((if /\./.test(number) then 2 else 1))).join("0") + number  if width > 0
    number + "" # always return a string


  ###*
   * блокирует выполнение действия по умолчанию в браузере, включая такие, как ctrl+s и др.
   * @param {Event} event
   * @return Boolean
   ###
  blockEvent: (event = window.event) ->
    if(event.stopPropagation)
      event.stopPropagation()
    else
      event.cancelBubble = true
    if(event.preventDefault)
      event.preventDefault()
    else
      event.returnValue = false

  ###*
   * замещает input полем со стрелочками
   * в опциях можно задать:
   *   step:  {Number} шаг с которым работает колёсико и кнопки
   *   min:   {Number} минимальное значение, ниже которого быть не может
   *   max:   {Number} максимальное значение
   * @param   {Element}   el
   * @param   {Object}    opt
   * @return  Boolean
   ###
  numberInputReplace: (el, opt = {}) ->
    width = el.offsetWidth
    height = el.offsetHeight
    parent = el.parentNode

    return false if el.tagName.toLowerCase() isnt 'input'

    inputWrapperReplase = f.createElement('.inputWrapperReplase', {
      style: {
        width :   "#{width}px"
        height:   "#{height}px"
        position: 'relative'
        display:  'inline-block'
      }
    })
    parent.replaceChild(inputWrapperReplase,el);
    @appendChild(inputWrapperReplase, el)
    @appendChild(inputWrapperReplase, "<div class='nup' style='position: absolute; top: 0; right: 0; cursor: pointer; width: 10px; height: 50%;'></div><div class='ndn' style='position: absolute; bottom: 0; right: 0; cursor: pointer; width: 10px; height: 50%;'></div>")

    el.style.width = width - 12 + 'px';
    el.style.height = height - 2 + 'px';

    opt.step = 1 unless ('step' of opt)

    up = =>
      value = @toInt el.value
      if 'max' of opt and opt.max < value + opt.step
        el.value = opt.max
      else
        el.value = value + opt.step
      true
    down = =>
      value = @toInt el.value
      if 'min' of opt and opt.min > value - opt.step
        el.value = opt.min
      else
        el.value = value - opt.step
      true
    check = =>
      value = @toInt el.value
      if 'max' of opt and opt.max < value
        el.value = opt.max
      else if 'min' of opt and opt.min > value
        el.value = opt.min
      true

    nup = @GBC("nup", inputWrapperReplase)[0]
    ndn = @GBC('ndn', inputWrapperReplase)[0]
    nup.onclick = (e = window.event) =>
      up()
    ndn.onclick = (e = window.event) =>
      down()

    if 'ondblclick' in nup
      nup.ondblclick = ndn.ondblclick = =>
        true
    wheel = (e = window.event) =>
      wheelDelta = 0
      if 'wheelDelta' of e
        wheelDelta = e.wheelDelta / 120
      else wheelDelta = -e.detail / 3  if 'detail' of e

      for num in [wheelDelta..0]
        if num > 0
          up()
        else if num < 0
          down()
      e.preventDefault()  if e.preventDefault
      e.returnValue = false
      @blockEvent e
      false
    if 'addEventListener' of el
      el.addEventListener('DOMMouseScroll', wheel, false)
    el.onmousewheel = wheel;
    @addEvent(el, 'change', check)
    true

  ###*
   * Добавляет слушателя клавиатуры и прерывает действия по умолчанию, если функции не возвращают true
   * @param   {String}    key     название клавиши. См. _keyMap
   * @param   {Function}  func    callback
   * @param   {Boolean}   [ctrl]  =   false
   * @param   {Boolean}   [shift] =   false
   * @param   {Boolean}   [alt]   =   false
   * @return  Boolean
   ###
  keyListener: (key, func, ctrl = false, shift = false, alt = false) ->
    return false if typeof func isnt 'function'
    second = null
    #ищем код в общем списке, если не находим, используем код, переданный в key
    if isNaN(key) or key.toString().length == 1
      keyCode = if key of @_keyMap then @_keyMap[key] else key
    else
      keyCode = key
    #составляем карту альтернативных кодов
    if keyCode == 13 || keyCode == 10
      keyCode = 13
      second = 10
    else if 0 <= key <= 9
      second = @_keyMap["numpad#{key}"]
    #отдельно подарки для оперы
    if @browser().name is 'opera'
      if 96 <= keyCode <= 105 #numKeysNumbers
        keyCode -= 48
      else
        switch keyCode
          when 91 then keyCode = 219    # win
          when 93 then keyCode = 0      # contextWin
          when 106 then keyCode = 42    # num *
          when 107 then keyCode = 43    # num +
          when 109 then keyCode = 45    # num -
          when 110 then keyCode = 78    # num .
          when 111 then keyCode = 47    # num /
          when 186 then keyCode = 59    # ;:
          when 187 then keyCode = 61    # =+
          when 189 then keyCode = 109   # -_
      #и немного подарочков для мозиллы
    else if @browser().name is 'mozilla'
      switch keyCode
        when 186 then keyCode = 59      # ;:
        when 187 then keyCode = 107     # =+
        when 189 then keyCode = 109     # -_
    #разобравшись со всеми исключениями составляем карту событий
    @_keyListMap[keyCode] = [] unless(keyCode of @_keyListMap)
    @_keyListMap[keyCode].push({func: func, ctrl: ctrl, shift: shift, alt: alt})
    if second
      @_keyListMap[second] = [] unless(second of @_keyListMap)
      @_keyListMap[second].push({func: func, ctrl: ctrl, shift: shift, alt: alt})
    true

  ###*
   * Добавляет функцию, которая выполнится при наступлении события построения dom модели
   * @param   {Function} func callback
   * @return  Boolean
   ###
  onDomReady: (func) -> # функция добавления события
    oldonload = @_funcDomReady
    unless typeof @_funcDomReady is "function"
      @_funcDomReady = func
    else
      @_funcDomReady = ->
        oldonload()
        func()
    true

  ###*
   * Запускает цепочку функций
   * @return *
   * @private
   ###
  initOnDomReady: ->
    # выходим, если функция уже выполнялась
    return  if @_ready
    # устанавливаем флаг, чтобы функция не исполнялась дважды
    @_ready = true
    @_funcDomReady()  if @_funcDomReady # вызываем всю цепочку обработчиков

  ###*
   * Подготавливает (расставляет слшателей событий) к загрузке документа
   * @return Boolean
   ###
  prepareOnDocumentReady: ->
    # для Mozilla/Firefox/Opera 9
    if document.addEventListener
      document.addEventListener "DOMContentLoaded", =>
        @initOnDomReady()
      , false
    else if @browser().name is 'ie' # для Internet Explorer
      `/*@cc_on @*/
      /*@if (@_win32)
       document.write("<script id=\"__ie_onload\" defer=\"defer\" src=\"javascript:void(0)\"><\/script>");
       var script = document.getElementById("__ie_onload");
       script.onreadystatechange = function() {
       if (this.readyState == "complete")
       f.initOnDomReady();}; // вызываем обработчик для onload
       /*@end @*/`
    else if /WebKit/i.test(navigator.userAgent) # условие для Safari
      _timer = setInterval(
        ->
          if /loaded|complete/.test(document.readyState)
            clearInterval _timer
            @initOnDomReady()
        10)
    else # для остальных браузеров
      window.onload = =>
        @initOnDomReady()
    true

  ###*
   * Возможность перетаскивания объектов мышью.
   * @param {Element}     element
   * функция проверки принимает 4 аргумента: (element, x/y, 1/0, ev).
   * Если третий аргумент 1, то передаётся x, иначе -- y
   * @param {Function}    funcChecker     функция проверки
   * @param {Function}    funcDragStart   вызывается в начале перетаскивания
   * @param {Function}    funcDragStop    вызывается при окончании перетаскивания (отпускании)
   * @return HSF
   ###
  setDrag: (element, opt) ->
    empty = ->
      true
    xy = (e, v) ->
      (if v then ((if msie then event.clientY + document.body.scrollTop else e.pageY)) else ((if msie then event.clientX + document.body.scrollTop else e.pageX)))
    sy = 0
    sx = 0
    st = 0
    sl = 0
    msie = (if @browser().name is "msie" then 1 else 0)
    opt =
      initThis: opt.initThis || false
      onDragStart: opt.onDragStart || empty
      onDragEnd: opt.onDragEnd || empty
      onDragCheckX: opt.onDragCheckX || empty
      onDragCheckY: opt.onDragCheckY || empty
      onDragOver: opt.onDragOver || false
      onDragOut: opt.onDragOut || false
      onDrop: opt.onDrop || false
      dragOverCheck: false
      dropCheck: false

    if opt.onDragOver or opt.onDragOut
      opt.dragOverCheck = true
      @setMem(element, 'oldDisplay', element.style.display)
      oldOver = null
    if opt.onDrop
      opt.dropCheck = true

    element.ondragstart = ->
      false

    element.onselectstart = ->
      false

    element.onmousedown = (e) =>
      e = e || window.event
      return false  if opt.onDragStart(element, e, opt) is false
      @setTempStyle(document.body, {cursor: f.getStyle(element, 'cursor')}, 'DragStyle')
      target = e.target || e.srcElement
      target.ondragstart = ->
        false

      if opt.dragOverCheck
        element.style.display = 'none'
        oldOver = document.elementFromPoint(e.pageX || e.clientX, e.pageY || e.clientY)
        element.style.display = @getMem(element, 'oldDisplay')

      position = @getStyle(element, "position")
      element.style.position = "relative"  if position isnt "absolute" and position isnt "relative"
      sy = xy(e, 1)
      sx = xy(e, 0)
      if position is 'relative'
        stt = 0
        stl = 0
      else
        stt = element.offsetTop
        stl = element.offsetLeft
      st = @getStyle(element, "top")
      st = if st is 'auto' or st is '' then stt else @toInt(st)
      sl = @getStyle(element, "left")
      sl = if sl is 'auto' or sl is '' then stl else @toInt(sl)
      document.onmousemove = (ev) =>
        ev = window.event  unless ev
        y = xy(ev, 1) - sy + st
        x = xy(ev, 0) - sx + sl
        element.style.top = y + "px"  if opt.onDragCheckY(element, y, ev)
        element.style.left = x + "px"  if opt.onDragCheckX(element, x, ev)
        if opt.dragOverCheck
          element.style.display = 'none'
          elOver = document.elementFromPoint(ev.pageX || ev.clientX, ev.pageY || ev.clientY)
          element.style.display = @getMem(element, 'oldDisplay')
          if oldOver isnt elOver
            opt.onDragOut(oldOver, ev) if opt.onDragOut
            opt.onDragOver(elOver, ev) if opt.onDragOver
            oldOver = elOver
        return
      try
        touchMove = f.addEvent(document, 'touchmove', document.onmousemove)
      document.onmouseup = (eu) =>
        eu = window.event  unless eu
        document.onmousemove = null
        @retTempStyle(document.body, 'DragStyle')
        if typeof touchMove is 'function'
          touchMove()
        if opt.dropCheck
          element.style.display = 'none'
          elOver = document.elementFromPoint(eu.pageX || eu.clientX, eu.pageY || eu.clientY)
          element.style.display = @getMem(element, 'oldDisplay')
          opt.onDrop elOver, eu
        opt.onDragEnd element, eu
        document.onmouseup = null
        if typeof touchEnd is 'function'
          touchEnd()
        true
      try
        touchEnd = f.addEvent(document, 'touchend', document.onmouseup)
      false
    try
      f.addEvent(element, 'touchstart', element.onmousedown)
    @

  ###*
   * Форматирует дату в строку по шаблону. Все одиночные % должны быть экранированы %%, иначе результат непредсказуем
   * d день месяца с ведущими нулями 01-31
   * D день месяца без ведущих нулей 1-31
   * w день недели  1-7
   * l Сокращенное наименование дня недели, 2 символа (из настроек) Сб
   * L Полное наименование дня недели (из настроек) Суббота
   * m месяц с ведущими нулями
   * M месяц без ведущих нулей
   * f Сокращенное наименование месяца, 3 символа (из настроек)
   * F Полное наименование месяца (из настроек)
   * Y последние 2 числа года
   * y год полностью
   *
   * a am/pm в нижнем регистре
   * A AM/PM в верхнем регистре
   *
   * g Часы в 12-часовом формате с ведущими нулями
   * G Часы в 12-часовом формате без ведущих нулей
   * h Часы в 24-часовом формате с ведущими нулями
   * H Часы в 24-часовом формате без ведущих нулей
   * i Минуты с ведущими нулями
   * I Минуты без ведущих нулей
   * s секунды с ведущими нулями
   * S секунды без ведущих нулей
   * p милисекунды с ведущими нулями
   * P милисекунды без ведущих нулей
   *
   * u количество секунд с началы эпохи юникс (1 января 1970, 00:00:00 GMT)
   * U количество милисекунд с началы эпохи юникс
   *
   * c Дата в формате ISO 8601
   * r Дата по rfc 2822
   * O Разница с временем по Гринвичу в часах
   * z порядковый номер дня
   *
   * @param {Date}    date
   * @param {String}  format
   * @return String
   ###
  dateToFormat: (date, format) ->
    percentEcran = false
    if /%%/.test format
      percentEcran = true
      format = format.replace /%%/g, "'%'"
    if /%d/.test format
      t = date.getDate()
      t = '0'+t if t < 10
      format = format.replace /%d/g, t
    if /%D/.test format
      t = date.getDate()
      format = format.replace /%D/g, t
    if /%w/.test format
      t = date.getDay() + 1
      format = format.replace /%w/g, t
    if /%m/.test format
      t = date.getMonth() + 1
      t = '0'+t if t < 10
      format = format.replace /%m/g, t
    if /%M/.test format
      t = date.getMonth() + 1
      format = format.replace /%M/g, t
    if /%y/.test format
      t = date.getFullYear()
      format = format.replace /%y/g, t
    if /%Y/.test format
      t = date.getFullYear().substr(2,2)
      format = format.replace /%Y/g, t
    if /%a/.test format
      t = date.getHours()
      t = if t > 12 then 'pm' else 'am'
      format = format.replace /%a/g, t
    if /%A/.test format
      t = date.getHours()
      t = if t > 12 then 'PM' else 'AM'
      format = format.replace /%A/g, t
    if /%c/.test format
      t = date.toISOString()
      format = format.replace /%c/g, t
    if /%l/.test format
      t = @_dateNames.weekShort[date.getDay()]
      format = format.replace /%l/g, t
    if /%L/.test format
      t = @_dateNames.weekFull[date.getDay()]
      format = format.replace /%L/g, t
    if /%f/.test format
      t = @_dateNames.monthShort[date.getMonth()]
      format = format.replace /%f/g, t
    if /%F/.test format
      t = @_dateNames.monthFull[date.getMonth()]
      format = format.replace /%F/g, t
    if /%g/.test format
      t = date.getHours()
      t -= 12 if t > 12
      format = format.replace /%g/g, t
    if /%G/.test format
      t = date.getHours()
      t -= 12 if t > 12
      t = '0' + t if t < 10
      format = format.replace /%G/g, t
    if /%h/.test format
      t = date.getHours()
      t = '0' + t if t < 10
      format = format.replace /%h/g, t
    if /%H/.test format
      t = date.getHours()
      format = format.replace /%H/g, t
    if /%i/.test format
      t = date.getMinutes()
      t = '0' + t if t < 10
      format = format.replace /%i/g, t
    if /%I/.test format
      t = date.getMinutes()
      format = format.replace /%I/g, t
    if /%s/.test format
      t = date.getSeconds()
      t = '0' + t if t < 10
      format = format.replace /%s/g, t
    if /%S/.test format
      t = date.getSeconds()
      format = format.replace /%S/g, t
    if /%p/.test format
      t = date.getMilliseconds()
      if t < 10
        t = '00' + t
      else if 10 <= t < 100
        t = '0' + t
      format = format.replace /%p/g, t
    if /%P/.test format
      t = date.getMilliseconds()
      format = format.replace /%P/g, t
    if /%r/.test format
      t = @dateToFormat date, '%l, %d %f %y %h:%i:%s %O'
      format = format.replace /%r/g, t
    if /%O/.test format
      t = date.toString()
      t = t.substr(t.indexOf('+'))
      format = format.replace /%O/g, t
    if /%u/.test format
      t = date.getTime()
      t = (t - (t % 1000)) / 1000
      format = format.replace /%u/g, t
    if /%U/.test format
      t = date.getTime()
      format = format.replace /%U/g, t
    if /%z/.test format
      t = date.getTime()
      tmp = new Date(t)
      tmp.setMonth(0)
      tmp.setDate(1)
      tmp.setHours(0)
      tmp.setMinutes(0)
      tmp.setSeconds(0)
      tmp.setMilliseconds(0)
      t = Math.floor((t - tmp.getTime()) / 86400000)
      format = format.replace /%z/g, t
    if percentEcran is true
      format = format.replace /'%'/g, '%'
    format

  ###*
   * Вставляет элемент el после элемента exist
   * @param   {Node} el который вставляем
   * @param   {Node} exist после которого вставляем
   * @return  Node
   ###
  insertAfter: (el, exist) ->
    parent = exist.parentNode
    next = exist.nextSibling
    if next
      parent.insertBefore el, next
    else
      parent.appendChild el
    @

  ###*
   * Вставляет элемент el перед элементом exist
   * @param   {Node} el который вставляем
   * @param   {Node} exist перед которым вставляем
   * @return  Node
   ###
  insertBefore: (el, exist) ->
    exist.parentNode.insertBefore(el, exist)
    @

  ###*
   * Получает рендомное число от min до max включительно
   * @param   {Number} min минимальное значение
   * @param   {Number} max максимальное значение
   * @return  Number
   ###
  random: (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min;

  ###*
     * Замена jQuery селектору и универсализация querySelectorAll
     * @param   {String} queryString селектор
     * @param   {Element} context = document контекст, в котором ищем
     * @return  Array
     ###
  qsa: (queryString, context = document) ->
    if 'querySelectorAll' of context
      return [].take(context.querySelectorAll(queryString))
    if 'jQuery' of window
      return jQuery(queryString, context).get()
    #ie 7 -- 8 (yes, ie 8 support querySelectorAll but ie 8 not support querySelectorAll XD
    s = document.createStyleSheet()
    r = queryString.replace(/\[for\b/gi, "[htmlFor").split(",")
    window.hsfSelectorCollection = []
    if @_scriptPath is ''
      for script in @GBT('script')
        if /hsf\.(min\.|dev\.)?js$/.test(script.src || '')
          @_scriptPath = script.src.replace(/hsf\.(min\.|dev\.)?js$/, '')
          break
      if @_scriptPath is ''
        @_scriptPath = false

    if @_scriptPath is false
      a = context.all
      c = []
      i = r.length
      while i--
        s.addRule r[i], "k:v"
        j = a.length
        while j--
          a[j].currentStyle.k and c.push(a[j])
        s.removeRule 0
      return c
    else
      beh = @_scriptPath + '/ca.htc'
      for selector in r
        s.addRule selector, "behavior: url(#{beh})"
        s.removeRule 0
      s.owningElement.parentNode.removeChild(s.owningElement)
      return window.hsfSelectorCollection
  ###*
   * Получение ширины скроллбара. Взято из MooTools
   * @return  Number
   ###
  getScrollBarWidth: ->
    if @_scrollBarWidth < 0
      @appendChild document.body, "<div id='__HSFscrollbar' style='position:absolute;top:0;left:0;visibility:hidden;width:200px;height:150px;overflow:hidden;'><p style='width:100%;height:200px'></p></div>"
      outer = f.GBI('__HSFscrollbar')
      inner = outer.children[0]

      w1 = inner.offsetWidth
      outer.style.overflow = "scroll"
      w2 = inner.offsetWidth
      w2 = outer.clientWidth  if w1 is w2
      document.body.removeChild outer
      @_scrollBarWidth = w1 - w2
    @_scrollBarWidth

  ###*
   * накладывает объект obj2 на объект obj1
   * если нужно создать третий объект (не трогать obj1) из двух надо использовать f.merge(f.merge({},obj1), obj2)
   * @param {Object} obj1 модифицируемый объект
   * @param {Object} obj2 модифицирующий объект
   * @return  Object
   ###
  merge: (obj1, obj2) ->
    for own p of obj2
      try
      # Property in destination object set; update its value.
        if obj2[p].constructor is Object
          obj1[p] = @merge(obj1[p], obj2[p])
        else
          obj1[p] = obj2[p]
      catch e
      # Property in destination object not set; create it and set its value.
        obj1[p] = obj2[p]
    obj1

  ###*
   * преобразует данные формы в строку. Нет типа файл из-за проблем с кроссбраузерностью
   * @param {HTMLFormElement} form форма
   * @param {Boolean} isGet является ли запрос get-запросом
   * @return  String
   ###
  formToData: (form, isGet) ->
    q = ''
    p = if isGet then '?' else ''
    encodeEl = (el) ->
      r = p + encodeURI(el.name) + '=' + encodeURI(el.value);
      p = '&'
      r
    return false if form.elements.length is 0

    for el in form.elements
      switch el.type
        when "select-one", "select"
        , "password"
        , "textarea"
        , "hidden"
        , "text"
          q += encodeEl(el)
        when "radio", "checkbox"
          q += encodeEl(el)  if el.checked
        else
    q

  ###*
   * Создаёт системный стиль. Если количество стилей зашкаливает (31+), то приклеивается к последнему стилю.
   * @return  HSF
   ###
  createStyleSheet: ->
    return @ if @_systemStyleSheet?
    @_CSSCache =
      index: {}
      rules: []
    if document.styleSheets.length > 30
      @_systemStyleSheet = ss
      @updateStyleSheetIndex()
    else
      if 'createStyleSheet' of document
        ss = document.createStyleSheet()
        @appendChild document.body, ss.owningElement
      else
        ss = f.createElement('style',{},document.body).sheet
      @_systemStyleSheet = ss
    @

  ###*
   * Обновляет индекс стилей или создаёт его
   * @return  HSF
   ###
  updateStyleSheetIndex: ->
    sumaryStyle = []
    indexStyle = {}
    mode = -1
    rules = @_systemStyleSheet.cssRules or @_systemStyleSheet.rules
    for rule in rules
      continue unless 'style' of rule
      cssText = rule.style.cssText
      if cssText.indexOf('{') >= 0 and cssText.charAt(cssText.length - 1) is '}'
        mode = 1
      else
        mode = 0
      break
    for rule, i in rules
      selectorText = rule.selectorText
      unless 'style' of rule
        indexStyle[selectorText] = i
        sumaryStyle[i] = {}
        continue
      indexStyle[selectorText.replace(/(^| |\+|>|~|,)[A-Z]+/g, (c)-> c.toLowerCase())] = i
      sumaryStyle[i] = {} unless selectorText of sumaryStyle
      cssText = rule.style.cssText
      if mode is 1
        cssText = cssText.substr(0, cssText.length - 1).substr(cssText.indexOf('{') + 1).trim()
      for part in cssText.split(';')
        p = part.indexOf(':')
        continue if p is -1
        sumaryStyle[i][part.substr(0,p).trim().toLowerCase()] = part.substring(p+1, part.length).trim()
      @_CSSCache.rules = sumaryStyle
      @_CSSCache.index = indexStyle
    @


  ###*
   * Устанавливает новое CSS правило
   * Если правило существует, то оно дополняется свойствами из prop или prop: value, при чём, если prop строка, а value не указан, будет ошибка
   * Формат prop как строки "-moz-border-radius" или "MozBorderRadius", но правильный первый вариант
   * Формат prop как объекта {"-moz-border-radius": "5px"} или {MozBorderRadius: "5px"}, но правильный первый вариант
   * value только строка и учитывается только, когда prop строка
   * @param {String} selector селектор, имена тегов в нижнем регистре. Иначе поведение непредопределено.
   * @param {String|Object} prop название свойства или объект свойств
   * @param {String|NULL} [value] = null значение
   * @return  HSF
   ###
  setCSS: (selector, prop, value) ->
    selectors = selector.split ','
    props = {}
    switch typeof prop
      when 'string'
        unless value?
          @log 'setCSS: value не задана', 'error'
          return @
        prop = prop.replace(/[A-Z]/g, (c)->'-'+c.toLowerCase())
        props[prop] = value
      when 'object'
        for own p, value of prop
          p = p.replace(/[A-Z]/g, (c)->'-'+c.toLowerCase())
          props[p] = value
      else
        @log 'setCSS: Неизвестный тип prop', 'error'
        return @
    @createStyleSheet() unless @_CSSCache?
    # ------------------------------------------------------------------------------------------
    rules = (@_systemStyleSheet.cssRules or @_systemStyleSheet.rules)
    # проверяем состояние индекса, не сломан ли он.
    reIndexed = false
    if @_CSSCache.rules.length isnt rules.length #длины должны быть одинаковы
      reIndexed = true
    else # если длины целы пошли проверять поселекторно
      for sel in selectors
        sel = sel.trim()
        if sel of @_CSSCache.index
          rule = rules[@_CSSCache.index[sel]]
          # в IE селекторытегов пишутся с больших букв, поэтому для единого поиска они уменьшаются
          if rule.selectorText.replace(/(^| |\+|>|~|,)[A-Z]+/g, (c)-> c.toLowerCase()) isnt sel
            reIndexed = true
            break
    if reIndexed # если таки сломан, переиндексируем
      @updateStyleSheetIndex()
      @log('index is crash', 'warn') # о чём сообщаем в лог

    strProps = ''
    for sel in selectors
      sel = sel.trim()
      i = @_CSSCache.index[sel]
      unless i?
        newIndex = @_CSSCache.rules.length
        if @_systemStyleSheet.addRule
          @_systemStyleSheet.addRule sel, 'abc: dev;', newIndex
        else
          @_systemStyleSheet.insertRule "#{sel} {}", newIndex
        @_CSSCache.rules[newIndex] = {}
        @_CSSCache.index[sel] = newIndex
        i = newIndex
      rule = rules[i]
      eProps = @_CSSCache.rules[i]
      for own p, v of eProps #перебираем все стили, заменяем и удаляем
        if p of props
          pp = props[p]
          if pp isnt null
            strProps += "#{p}: #{pp}; "
            eProps[p] = pp
            delete props[p] # удаляем в пропах
          else
            delete eProps[p] # авось итератор не сглючит
        else
          strProps += "#{p}: #{v}; "
      for own p, v of props # добавляем новые свойства
        strProps += "#{p}: #{v}; "
        eProps[p] = v
      rule.style.cssText = strProps
    @

  ###*
   * Удалает CSS правило из системного styleSheet-та по селектору
   * @param {String} selector селектор, имена тегов в нижнем регистре. Иначе поведение непредопределено.
   * @return  HSF
   ###
  remCSS: (selector) ->
    return @ unless @_systemStyleSheet?
    selectors = selector.split ','
    # ------------------------------------------------------------------------------------------
    rules = (@_systemStyleSheet.cssRules or @_systemStyleSheet.rules)
    # проверяем состояние индекса, не сломан ли он.
    reIndexed = false
    if @_CSSCache.rules.length isnt rules.length #длины должны быть одинаковы
      reIndexed = true
    else # если длины целы пошли проверять поселекторно
      for sel in selectors
        if sel of @_CSSCache.index
          rule = rules[@_CSSCache.index[sel]]
          # в IE селекторытегов пишутся с больших букв, поэтому для единого поиска они уменьшаются
          if rule.selectorText.replace(/(^| |\+|>|~|,)[A-Z]+/g, (c)-> c.toLowerCase()) isnt sel
            reIndexed = true
            break
    if reIndexed # если таки сломан, переиндексируем
      @updateStyleSheetIndex()
      @log('index is crash', 'warn') # о чём сообщаем в лог
    for sel in selectors
      i = @_CSSCache.index[sel]
      continue unless i?
      if 'deleteRule' of @_systemStyleSheet
        @_systemStyleSheet.deleteRule(i)
      else
        @_systemStyleSheet.removeRule(i)
      @_CSSCache.rules.del(i)
      delete @_CSSCache.index[sel]
    @



if 'localStorage' of window
  HSF::setLS = (key, val) ->
    try
      localStorage.setItem key, val
    catch e
      return e
    true
  HSF::getLS = (key) ->
    localStorage.getItem key
  HSF::delLS = (key) ->
    localStorage.removeItem key
  HSF::clearLS = ->
    localStorage.clear()
else if HSF::browser().name is 'msie'
  HSF::_initIeStorage = ->
    @_storage =@createElement('div#__storageElement', {style:{display:'none'}}, document.body)
    unless @_storage.addBehavior
      @log 'Нет поддержки userDara'
    else
      @_storage.addBehavior("#default#userData")
      @_storage.load('hsf')
    @
  HSF::setLS = (key, value) ->
    @_storage.setAttribute key, value
    @_storage.save "hsf"
    @
  HSF::getLS = (key) ->
    @_storage.getAttribute key
  HSF::delLS = (key) ->
    @_storage.removeAttribute key
    @_storage.save "hsf"
    @
  HSF::clearLS = ->
    for v in @_storage.XMLDocument.documentElement.attributes
      @delLS v.name
    @
else
  HSF::setLS =    -> @
  HSF::getLS =    -> null
  HSF::delLS =    -> @
  HSF::clearLS =  -> @

window.f = new HSF({counter:false})