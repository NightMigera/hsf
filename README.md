HSF
===

Hight Speed Functions <br/> Высокоскоростные функции
---
### Оглавление
 - [Введение](#Введение-)
 - [Array](#array--)
 - [Fucntion](#function--)
 - [String](#string--)

Введение [↑](#Оглавление)
---
  Данные функции были разработаны специально для максимально всокоскоростной работы в браузерах от IE 6, FF 3.5, 
  Opera 10.5, Chrome 1.0, Safari 3.5 и до самых последних версий с учётом различных "аномалий", которые возникают.
  
  Все функции работы с элементами принимают первым аргументом элемент. И только 1 элемент, т.е. не коллекцию. Предполагается, что если Вам требуется перебрать несколько элементов, то ради высокой производительности ничего не стоит пройтись итератором в цикле (например for). Например, чтобы "навесить" event listener на один объект, надо написать
            
      f.addEvent(htmlElement, 'click', f.log.bind(f, 'click'))
            
- f это экземпляр класса HSF, создаваемый по умолчанию с параметрами по умолчанию.
- htmlElement это элемент, который мы создали или получили (например через document.getElementById)
- log универсальная прослойка для console.log: если такого объекта и метода не существует, то логи можно будет просмотреть во внутренней "консоли"
- bind добавлен к прототипу Function, об его работе можно прочитать на MDN.
  <br />
  
Если же имеется коллекция элементов htmlElementsCollection, то чтобы навесить на все элементы обработчик клика можно воспользоваться такой записью:
  
      for (var i = 0, l = htmlElementsCollection; i < l i++) {
    
          f.addEvent(htmlElementsCollection[i], 'click', f.log.bind(f, 'click'));
        
      }
  
  <b>!!! Важно!</b>
  <i>Ради выигрыша в производительности модифицируются прототипы таких базовых классов, как Array, String, Function. По сути, если Вы столкнётесь с ошибками после подключения данной библиотеки, значит код был написан не аккуратно, с переборами через for in в массивах, что при стремлении к максимальной производительности не допустимо.</i>
  
  ---

### Array  [↑](#Оглавление) ###
  `Number array.indexOf (value[, Number startIndex])` <br />
  [MDN array.indexOf](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/indexIf) <br />
  Внедряется в прототип только, когда такого метода нет. 
  Работает, как стандартный метод: возвращает индекс элемента, равного `value`, от позиции `startIndex` или -1, если он не обнаружен. `startIndex` по умолчанию равен 0. Если он отрицательный, то смещение сщитается от конца массива. 

  `void array.forEach (Function callback[, Object scope])` <br>
  [MDN array.forEach](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach)<br />
  Внедряется в прототип только, когда такого метода нет. 
  Работает, как стандартный метод: перебирает все элементы массива `array` вызывая `callback` в контексте `scope` и передавая в него три аргумента: значение элемента, его индекс, сам массив.
  <b>Важно:</b> защит от дурака нет.

  `Array array.take (Array|List|Collection secondArray)` <br />
  Внедряется в прототип всегда.
  Присоединяет все элементы из массива `secondArray` к массиву array. В качестве `secondArray` могут выступать массивы, списки или коллекции. Главное условие, чтобы индексы элементов были положительными, целочисленными, шли подряд и у `secondArray` должен быть `length`. 
  <b>Важно:</b> защит от дурака нет.

  `Array array.del (Number index)` <br />
  Внедрется в прототип всегда.
  Удаляет из массива `array` элемент с индексом `index` и возвращает массив `array`. 
  <b>Важно:</b> защит от дурака нет.
### Function  [↑](#Оглавление) ###
  `Function function.bind(Object scope[, arg1[, arg2[, ...]]])`<br />
  [MDN function.bind](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind)
  Внедряется в прототип только, когда такого метода нет. 
  Возвращает функцию `function2`, с предустановленным контекстом `scope` и аргументами `arg1`, `arg2`, `...`. Аргументы, переданные в функцию  `function2`, будут вызваны после аргументов, переданных в `bind`.
### String  [↑](#Оглавление) ###
  `String string.trim()` <br />
  [MDN string.trim](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/trim) <br />
  Внедряется в прототип только, когда такого метода нет. 
  Удаляет пробельные символы (пробелы, табуляцию, нулевые пробелы, и т.п.) в начале строки `string` и в её конце.
  
  `String string.replace(String|RegExp search, String|Function newString[, String flags])`<br />
  [MDN string.replace](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replace) <br />
  Расширяет метод `replace` всегда, если он не понимает `flags`.
  Заменяет подстроки, равные или удовлетворяющие регулярному выражению `search` на строку `newString`, или на результат выполнения функции `newString`. Флаги `flags` могут быть:
  
  - `g` глобальный поиск
  - `i` без учёта регистра
  - `m` не обращать внимания на переносы строк
  