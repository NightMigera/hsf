**Author:** Louter

<b>HSF</b> это hight speed function (высокоскоростные функции).
Функции, ориентированные на скорость выполнения в зависимости от задач.
Созданный класс вносит корректировки в прототипы базовых классов и сильно
расширяет базовый функционал, позволяя использовать функии со скоростью превосходящей jQuery,
но уступающей по кросбраузерности
+getScrollBarWidth
+random
+qsa
+insertAfter, +insertBefore
+clearElement
~setDrag add dragOver, gragOut, drop and change arguments mix
~openWin add callback
+formToData
+removeElement
~appendChild
+setStyle
+getIndexElement
~createLoaderBubble
~setMem,buttonClick,hover (return this)
~retTempStyle
~load
~setDrag add touch
+setCSSS
+remCSSS
+updateStyleSheetIndex
+createStyleSheet
+Function::bind
~openWin
~load
~log, printLog
~qsa
~updateStyleSheetIndex
~addEvent


module Global
=============
HSF(options)
------------
Параметры:
- debug: true|false режим отладки
- ajaxPoolLength: {numeric} длина пула ajax
- counter: (bool) включено ли добавление параметра, защищающего от кешированного ответа
- dateNames: (Object) Названия месяцев и недель в календарях


**Parameters**

**options**:  *Object*,  


trim()
------
Добавляет функцию trim в String там, где этого нет (IE)


**Returns**

String

forEach(fn, \[scope\])
----------------------
forEach executes the provided callback once for each element of
the array with an assigned value. It is not invoked for indexes
which have been deleted or which have been initialized to undefined.



**Parameters**

**fn**:  *Function*,  Function to execute for each element.

**[scope]**:  *Object*,  Object to use as this when executing callback.

take(array)
-----------
Присоединяет значения массива или списка к текущему массиву
Если ничего не переданно, равно как и null, то будет ошибка.
Если будет переданн посторонний объект без свойства `length`, то массив изменён не будет,
если же у объекта будет `length` то будет прибавденно `length` элементов в конец массива



**Parameters**

**array**:  *Array|String||NodeList|HTMLCollection*,  любой массивоподобный объект

**Returns**

Array

del(index)
----------
Удаляем элемент из массива


**Parameters**

**index**:  *Number*,  индекс элемента

**Returns**

Array

indexOf(item, \[startIndex\])
-----------------------------
Получаем элемент в массиве или -1, если его нет. Фикс для старых браузеров


**Parameters**

**item**:  ***,  элемент массива

**[startIndex]**:  *Number*,  = 0 начальный индекс

**Returns**

Number

getThis()
---------
Получает строку для обращения из глобальной области видимости для inline функций


class HSF
---------
**Methods**

HSF.toSource(o, \[level\])
--------------------------
Возвращает структуру объекта `o` с глубиной рекурсии `level`.



**Parameters**

**o**:  *Object*,  объект, который нам нужен

**[level]**:  *Number*,  глубина рекурсивного перебора, по умолчанию 0

**Returns**

*String*,  структура объекта

HSF.oSize(o)
------------
Возвращает количество свойств и методов объекта `o`



**Parameters**

**o**:  *Object*,  


**Returns**

Number

HSF.oKeys(o)
------------
Возвращает ключи объекта `o`



**Parameters**

**o**:  *Object*,  


**Returns**

Array

module var
==========
Возвращает структуру объекта `o` с глубиной рекурсии `level`.

module var
==========
Возвращает количество свойств и методов объекта `o`

module var
==========
Возвращает ключи объекта `o`

var.GBI(el)
-----------
синоним для document.getElementById


**Parameters**

**el**:  *String*,  


var.GBC(classname, \[node\])
----------------------------
кросс-браузерная версия для получения элементов по имени класса classname внутри node


**Parameters**

**classname**:  *String*,  


**[node]**:  *Element*,  = document

**Returns**

Array|NodeList

var.GBT(tagName, \[node\])
--------------------------
синоним для node.getElementsByTagName


**Parameters**

**tagName**:  *String*,  


**[node]**:  *Node*,  = document

**Returns**

NodeList

var.openWin(url, \[title\], \[width\], \[height\], \[option\])
--------------------------------------------------------------
создаём окно по центру с заданной ссылкой и названием.
Размеры, а так же различные элементы определяются отдельно


**Parameters**

**url**:  *String*,  


**[title]**:  *String*,  


**[width]**:  *Number*,  = 902

**[height]**:  *Number*,  = 700

**[option]**:  *Object*,  


**Returns**

window

var.getPos(el, parent=document)
-------------------------------
получается позиция объекта в документе. Некоторые баги в ИЕ


**Parameters**

**el**:  *Element*,  


**parent=document**:  *Element*,  


var.getMousePos(e)
------------------
получается позиция event-a


**Parameters**

**e**:  *Event*,  


var.GMP(e)
----------
alias to getMousePos


**Parameters**

**e**:  *Event*,  


**Returns**

*Object*,  {x:(number),y:(number)}

var.getScreenPos(el)
--------------------
получается позиция объекта на экране.


**Parameters**

**el**:  *Element*,  


**Returns**

*Object*,  {x:(number),y:(number)}

var.getSize()
-------------
получение размеров экрана, возвращается объект с свойствами:
w ширина экрана,
h высота экрана,
s величина прокрутки сверху,
sl величина прокрутки слева,
sw ширина прокручиваемой области,
sh высота документа


**Returns**

Object

var.getStyle(el, styleName)
---------------------------
получаем значение стиля элемента по его DOM-имени


**Parameters**

**el**:  *Element*,  


**styleName**:  *String*,  


**Returns**

String

var.setStyle(el, style)
-----------------------
Выставляет стиль, в основном призвын перебирать стили в объекте


**Parameters**

**el**:  *Element*,  


**style**:  *String|Object*,  


**Returns**

HSF

var.getIndexElement(el, node)
-----------------------------
Получает индекс элемента у родительского элемента.


**Parameters**

**el**:  *Element*,  


**node**:  *Boolean*,  = false считать ли среди всех дочерних элементов или только среди тэгов (по умолчанию)

**Returns**

Number

var.browser()
-------------
определяет название браузера и версию


var.setMem(el, prop, val, nameSpace)
------------------------------------
устанавливаем "память" объекту.
пока он будет жив, память можно будет получить



**Parameters**

**el**:  *Element*,  


**prop**:  *String*,  properties

**val**:  *String*,  value of properties

**nameSpace**:  *String*,  = 'HSF' name space, of our params

**Returns**

Element

var.getMem(el, prop, nameSpace)
-------------------------------
получаем "память" объекта.
пока он будет жив, память можно будет получить



**Parameters**

**el**:  *Element*,  


**prop**:  *String*,  properties

**nameSpace**:  *String*,  = 'HSF' name space, of our params

**Returns**

Mixed

var.getMemList(el, nameSpace)
-----------------------------
получаем всю память с установленным префиксом



**Parameters**

**el**:  *Element*,  


**nameSpace**:  *String*,  = 'HSF'

**Returns**

Object

var.clearMem(el, nameSpace)
---------------------------
очищаем всю память с установленным префиксом



**Parameters**

**el**:  *Element*,  


**nameSpace**:  *String*,  = 'HSF'

**Returns**

Boolean

var.toInt(value)
----------------
возвращает число или 0 (вместо NaN)


**Parameters**

**value**:  ***,  


**Returns**

Number

var.mLog(a, b)
--------------
Берёт логарифм от a по основанию b. По умолчанию натуральный.


**Parameters**

**a**:  *Number*,  


**b**:  *Number*,  = Math.E

**Returns**

Number

var.buttonClick(el, props, opt={})
----------------------------------
Описываем, что в кнопке должно измениться и какие функции произойти, когда на неё нажимают,
прописываем функцию, срабатывающую при отпускании.


**Parameters**

**el**:  *Element*,  


**props**:  *Object*,  css property

**opt={}**:  *Object*,  {[down:handler(el)],[up:handler(el)]}

**Returns**

Boolean

var.hover(el, props, opt={})
----------------------------
Описываем, что в кнопке должно измениться и какие функции произойти, когда на неё наводят,
прописываем функцию, срабатывающую при отведении.


**Parameters**

**el**:  *Element*,  


**props**:  *Object*,  css property

**opt={}**:  *Object*,  {[down:handler],[up:handler]}

**Returns**

Boolean

var.setTempStyle(el, props, state)
----------------------------------
Устанавливает временный стиль, записывая старый стиль в память объекта


**Parameters**

**el**:  *Element*,  


**props**:  *Object*,  css property

**state**:  *String*,  имя блока стилей

**Returns**

HSF

var.retTempStyle(el, props, state)
----------------------------------
Восстанавливает указанные в props ывойства из state блока


**Parameters**

**el**:  *Element*,  


**props**:  *Object*,  css property

**state**:  *String*,  имя блока стилей

**Returns**

HSF

var.addEvent(elem, evType, fn)
------------------------------
Добавление функции для действия


**Parameters**

**elem**:  *Element*,  


**evType**:  *String*,  


**fn**:  *Function*,  имя блока стилей

**Returns**

Boolean|Function функция для удаления эвента или false

var.removeEvent(elem, evType, fn)
---------------------------------
Удаление функции из слушателей


**Parameters**

**elem**:  *Element*,  


**evType**:  *String*,  


**fn**:  *Function*,  имя блока стилей

**Returns**

Boolean

var.load(url, \[func\], \[data|err\], \[data\])
-----------------------------------------------
AJAX запрос
может принять необходимые аргументы, а может и объект, где:
url: String собственно адрес
scs: function(data) вызывается при успешном выполнении
err: function(data) вызывается при неудачном выполнении
data: String данные для POST метода
method: String
header: Object вида {header1Name: header1Value[, headerXName: headerXValue]...}


**Parameters**

**url**:  *String|Object*,  к какому URL

**[func]**:  *Function*,  


**[data|err]**:  *String*,  


**[data]**:  *String*,  


**Returns**

String|XMLHttpRequest|ActiveXObject

var.createBubble(html, \[w\], \[h\], \[options\])
-------------------------------------------------
Создаём бабл в центре экрана с шириной w и высотой h, с содержимым html
В опции можно передать:
close: function наступает при закрытии окна
resize: Boolean определяет, подгонять ли высоту по содержимому, если не умещается внутри



**Parameters**

**html**:  *string*,  


**[w]**:  *Number*,  = 300

**[h]**:  *Number*,  = 200

**[options]**:  *Object*,  см выше

**Returns**

Boolean|HSF

var.closeBubble()
-----------------
закрывает бабл


**Returns**

Boolean|Element

var.getBubble()
---------------
Возвращает бабл, если он есть или null


**Returns**

Element|NULL

var.createLoaderBubble(img)
---------------------------
Создаёт бабл, который появляется при загрузке.
TODO: сделать так, чтобы в качестве img можно было передавать Element


**Parameters**

**img**:  *string*,  


**Returns**

Boolean|HSF

var.createAlertBubble(text)
---------------------------
аналог alert, но не блокирует все скрипты.


**Parameters**

**text**:  *String*,  путь к картинке

**Returns**

Boolean|HSF

var.md5(str)
------------
md5 сумму подсчитывает по строке.


**Parameters**

**str**:  *String*,  


**Returns**

String

var.utf8_encode(str_data)
-------------------------
Функция кодирует в utf8 нужна для md5


**Parameters**

**str_data**:  *String*,  


**Returns**

String

var.createElement(tag, \[option\], \[parent\])
----------------------------------------------
Создаёт элемент по шаблону tag с свойствами из option и прикрепляет в parent
последовательность важна! Сначала тэг, потом ID и уже потом имена классов


**Parameters**

**tag**:  *String*,  [tagName][#tagId][.tagClass1][.tagClass2][...]

**[option]**:  *Object*,  ограничение на вложенные свойство. Не распространяется на style

**[parent]**:  *Element*,  


**Returns**

Element

var.appendChild(parent, el)
---------------------------
прикрепляет к parent ребёнка из дочерний элемент el
Если el строка, то это равносильно parent.innerHTML += el, но не ломается DOM-модель


**Parameters**

**parent**:  *Element*,  


**el**:  *Element|String*,  


**Returns**

Array массив элементов

var.removeElement(el)
---------------------
удаляет элемент el из общего DOM


**Parameters**

**el**:  *Element*,  


var.replaceElement(el, newEl)
-----------------------------
заменяет элемент el на newEl


**Parameters**

**el**:  *Element*,  


**newEl**:  *Element*,  


var.clearElement(el)
--------------------
Очищает элемент. Как оказалось innerHTML = '' довольно затратная операция


**Parameters**

**el**:  *Element*,  


var.setUniversalStyle(el, name, value)
--------------------------------------
Устанавливает стиль по имени вне зависимости от префиксов, если стиль вообще существует.
имя стилей следует преобразовывать в CamelCase c маленькой буквы


**Parameters**

**el**:  *Element*,  


**name**:  *String*,  имя в стиле borderRadius

**value**:  *String|Number*,  


**Returns**

Boolean

var.hasElement(el, child)
-------------------------
Устанавливает, есть ли в элементе el потомок child


**Parameters**

**el**:  *Element*,  


**child**:  *Element*,  


**Returns**

Boolean

var.setOnResize(el, \[funcName\])
---------------------------------
Устанавливает отслеживание изменение размеров элементов в документе.
Работает через единый таймер или через onresize
Если объект активируется повторно и нет funcName, то использыется прежняяфункция


**Parameters**

**el**:  *Element*,  элемент

**[funcName]**:  *Function*,  callback фенкция, вызываемая при изменении размеров

**Returns**

Number|Boolean

var.resizeObjects()
-------------------
Таймер отслеживает изменения по номерам позиции.


var.offOnResize(pos)
--------------------
Выключает таймер по позиции, которая возвращалась в setOnResize


**Parameters**

**pos**:  *Number*,  


**Returns**

Object

var.addClassName(el, className)
-------------------------------
Добавляет к элементу название класса


**Parameters**

**el**:  *Element*,  


**className**:  *String*,  


**Returns**

Element

var.hasClassName(el, className)
-------------------------------
Определяет, имеет ли документ определённый класс


**Parameters**

**el**:  *Element*,  


**className**:  *String*,  


**Returns**

Boolean

var.removeClassName(el, className)
----------------------------------
Удаляет у элемента название класса


**Parameters**

**el**:  *Element*,  


**className**:  *String*,  


**Returns**

Element

var.delClassName(el, className)
-------------------------------
синоним для removeClassName


**Parameters**

**el**:  *Element*,  


**className**:  *String*,  


**Returns**

Element

var.GPT(el, tagName)
--------------------
Получить родителя по тэгу


**Parameters**

**el**:  *Element*,  


**tagName**:  *String*,  


**Returns**

Element|Null

var.GPC(el, className)
----------------------
Получить родителя по имени класса


**Parameters**

**el**:  *Element*,  


**className**:  *String*,  


**Returns**

Element|Null

var.truncateStringMin(string, len, \[after\])
---------------------------------------------
Обрезает строку, если она больше и прибавляет к ней многоточие


**Parameters**

**string**:  *String*,  


**len**:  *Number*,  


**[after]**:  *String*,  что ставится после обрезанной строки

**Returns**

String

var.truncateString(string, dMax, uMax, \[after\])
-------------------------------------------------
Более умное обрезание строки: ищет пробелы в промежутке от dMax до uMax.
Если пробел не найден в этом промежутке, то ищет его в меньшую сторону
TODO: могут быть не только пробелы, а любые разделяющие символы и при этом скорость не должна упасть


**Parameters**

**string**:  *String*,  


**dMax**:  *Number*,  


**uMax**:  *Number*,  


**[after]**:  *String*,  


**Returns**

String

var.getCharWidthMax(\[fs\], \[ff\], \[chart\])
----------------------------------------------
получает ширину символа chart размера fs и шрифта ff
в кирилице максимальную букву лучше брать Ю


**Parameters**

**[fs]**:  *Number*,  =  11

**[ff]**:  *String*,  =  "Tahoma"

**[chart]**:  *String*,  =  "m"

**Returns**

Number

var.log(message, \[type\])
--------------------------
Добавление сообщения в лог


**Parameters**

**message**:  *String*,  


**[type]**:  *String*,  = 'log'

**Returns**

Boolean

var.time(message)
-----------------
Работает аналогично time в linux: считает кол-во мс, которое тратит на себя функция


**Parameters**

**message**:  *String*,  


**Returns**

Boolean

var.printLog()
--------------
Выводит лог на экран в виде линии событий и времён
TODO: сделать наведение более логичным и не зависящим от общей длины шкалы времени


**Returns**

Boolean

var.selectLogPoint(el)
----------------------
Выделяет определённую строку при наведении на строчку


**Parameters**

**el**:  *Element*,  


**Returns**

Boolean

var.unselectLogPoint(el)
------------------------
Снимает выделение с определённой строки


**Parameters**

**el**:  *Element*,  


**Returns**

Boolean

var.parseJSON(text)
-------------------
Парсит JSON строку в JS объект по RFC 4627 или "родными" средствами


**Parameters**

**text**:  *String*,  


**Returns**

Object|Array|Boolean|Number|String|Null

var.varToJSON(obj)
------------------
Преобразует объект в JSON строку


**Parameters**

**obj**:  *Object|Array|Boolean|Number|String|Null*,  


**Returns**

String

var.outerHTML(el)
-----------------
получает внешнюю обёртку тэга более кроссбраузерно, чем обращение к outerHTML


**Parameters**

**el**:  *Element*,  


**Returns**

String|Boolean

var.zeroFill(number, width)
---------------------------
заполняет спереди нулями number до длины width


**Parameters**

**number**:  *Number*,  


**width**:  *Number*,  


**Returns**

String

var.blockEvent(event)
---------------------
блокирует выполнение действия по умолчанию в браузере, включая такие, как ctrl+s и др.


**Parameters**

**event**:  *Event*,  


**Returns**

Boolean

var.numberInputReplace(el, opt)
-------------------------------
замещает input полем со стрелочками
в опциях можно задать:
step:  {Number} шаг с которым работает колёсико и кнопки
min:   {Number} минимальное значение, ниже которого быть не может
max:   {Number} максимальное значение


**Parameters**

**el**:  *Element*,  


**opt**:  *Object*,  


**Returns**

Boolean

var.keyListener(key, func, \[ctrl\], \[shift\], \[alt\])
--------------------------------------------------------
Добавляет слушателя клавиатуры и прерывает действия по умолчанию, если функции не возвращают true


**Parameters**

**key**:  *String*,  название клавиши. См. _keyMap

**func**:  *Function*,  callback

**[ctrl]**:  *Boolean*,  =   false

**[shift]**:  *Boolean*,  =   false

**[alt]**:  *Boolean*,  =   false

**Returns**

Boolean

var.onDomReady(func)
--------------------
Добавляет функцию, которая выполнится при наступлении события построения dom модели


**Parameters**

**func**:  *Function*,  callback

**Returns**

Boolean

var.initOnDomReady()
--------------------
Запускает цепочку функций


**Returns**

*

var.prepareOnDocumentReady()
----------------------------
Подготавливает (расставляет слшателей событий) к загрузке документа


**Returns**

Boolean

var.setDrag(element, funcChecker, funcDragStart, funcDragStop)
--------------------------------------------------------------
Возможность перетаскивания объектов мышью.
функция проверки принимает 4 аргумента: (element, x/y, 1/0, ev).
Если третий аргумент 1, то передаётся x, иначе -- y


**Parameters**

**element**:  *Element*,  


**funcChecker**:  *Function*,  функция проверки

**funcDragStart**:  *Function*,  вызывается в начале перетаскивания

**funcDragStop**:  *Function*,  вызывается при окончании перетаскивания (отпускании)

**Returns**

HSF

var.dateToFormat(date, format)
------------------------------
Форматирует дату в строку по шаблону. Все одиночные % должны быть экранированы %%, иначе результат непредсказуем

- d день месяца с ведущими нулями 01-31
- D день месяца без ведущих нулей 1-31
- w день недели  1-7
- l Сокращенное наименование дня недели, 2 символа (из настроек) Сб
- L Полное наименование дня недели (из настроек) Суббота
- m месяц с ведущими нулями
- M месяц без ведущих нулей
- f Сокращенное наименование месяца, 3 символа (из настроек)
- F Полное наименование месяца (из настроек)
- Y последние 2 числа года
- y год полностью
- &nbsp;
- a am/pm в нижнем регистре
- A AM/PM в верхнем регистре
- &nbsp;
- g Часы в 12-часовом формате с ведущими нулями
- G Часы в 12-часовом формате без ведущих нулей
- h Часы в 24-часовом формате с ведущими нулями
- H Часы в 24-часовом формате без ведущих нулей
- i Минуты с ведущими нулями
- I Минуты без ведущих нулей
- s секунды с ведущими нулями
- S секунды без ведущих нулей
- p милисекунды с ведущими нулями
- P милисекунды без ведущих нулей
- &nbsp;
- u количество секунд с началы эпохи юникс (1 января 1970, 00:00:00 GMT)
- U количество милисекунд с началы эпохи юникс
- &nbsp;
- c Дата в формате ISO 8601
- r Дата по rfc 2822
- O Разница с временем по Гринвичу в часах
- z порядковый номер дня



**Parameters**

**date**:  *Date*,  


**format**:  *String*,  


**Returns**

String

var.insertAfter(el, exist)
--------------------------
Вставляет элемент el после элемента exist


**Parameters**

**el**:  *Node*,  который вставляем

**exist**:  *Node*,  после которого вставляем

**Returns**

Node

var.insertBefore(el, exist)
---------------------------
Вставляет элемент el перед элементом exist


**Parameters**

**el**:  *Node*,  который вставляем

**exist**:  *Node*,  перед которым вставляем

**Returns**

Node

var.random(min, max)
--------------------
Получает рендомное число от min до max включительно


**Parameters**

**min**:  *Number*,  минимальное значение

**max**:  *Number*,  максимальное значение

**Returns**

Number

var.qsa(queryString, context)
-----------------------------
Замена jQuery селектору и универсализация querySelectorAll


**Parameters**

**queryString**:  *String*,  селектор

**context**:  *Element*,  = document контекст, в котором ищем

**Returns**

Array

var.getScrollBarWidth()
-----------------------
Получение ширины скроллбара. Взято из MooTools


**Returns**

Number

var.merge(obj1, obj2)
---------------------
накладывает объект obj2 на объект obj1
если нужно создать третий объект (не трогать obj1) из двух надо использовать f.merge(f.merge({},obj1), obj2)


**Parameters**

**obj1**:  *Object*,  модифицируемый объект

**obj2**:  *Object*,  модифицирующий объект

**Returns**

Object

var.formToData(form, isGet)
---------------------------
преобразует данные формы в строку. Нет типа файл из-за проблем с кроссбраузерностью


**Parameters**

**form**:  *HTMLFormElement*,  форма

**isGet**:  *Boolean*,  является ли запрос get-запросом

**Returns**

String

var.createStyleSheet()
----------------------
Создаёт системный стиль. Если количество стилей зашкаливает (31+), то приклеивается к последнему стилю.


**Returns**

HSF

var.updateStyleSheetIndex()
---------------------------
Обновляет индекс стилей или создаёт его


**Returns**

HSF

var.setCSS(selector, prop, \[value\])
-------------------------------------
Устанавливает новое CSS правило
Если правило существует, то оно дополняется свойствами из prop или prop: value, при чём, если prop строка, а value не указан, будет ошибка
Формат prop как строки "-moz-border-radius" или "MozBorderRadius", но правильный первый вариант
Формат prop как объекта {"-moz-border-radius": "5px"} или {MozBorderRadius: "5px"}, но правильный первый вариант
value только строка и учитывается только, когда prop строка


**Parameters**

**selector**:  *String*,  селектор, имена тегов в нижнем регистре. Иначе поведение непредопределено.

**prop**:  *String|Object*,  название свойства или объект свойств

**[value]**:  *String|NULL*,  = null значение

**Returns**

HSF

var.remCSS(selector)
--------------------
Удалает CSS правило из системного styleSheet-та по селектору


**Parameters**

**selector**:  *String*,  селектор, имена тегов в нижнем регистре. Иначе поведение непредопределено.

**Returns**

HSF

