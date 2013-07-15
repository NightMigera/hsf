HSF
===

###Hight Speed Functions <br/> Высокоскоростные функции

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
  
####!!! Важно!
  Ради выигрыша в производительности модифицируются прототипы таких базовых классов, как Array, String, Function. По сути, если Вы столкнётесь с ошибками после подключения данной библиотеки, значит код был написан не аккуратно, с переборами через for in в массивах, что при стремлении к максимальной производительности не допустимо.
  