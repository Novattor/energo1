
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ОбязательныеСвязи.Количество() = 1 Тогда
		
		Строка = Параметры.ОбязательныеСвязи[0];
		
		ТипСвязи = Строка.ТипСвязи;
		СсылкаНа = Строка.СсылкаНа;
		
	КонецЕсли;	
	
	Элементы.ДекорацияОписание.Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Чтобы завершить создание документа, необходимо указать связь ""%1"". 
			|Выберите проект для создания связи.';
			|en = 'To complete creating the document you must establish relation ""%1"".
			|Select the project to establish the relation.'"),
			ТипСвязи);
	
	Делопроизводство.СписокДокументовУсловноеОформлениеПомеченныхНаУдаление(Список);
	ПоказатьУдаленные();
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВозврата = Новый Структура("ТипСвязи, СсылкаНа, СвязанныйДокумент, Комментарий", 
		ТипСвязи, СсылкаНа, Элементы.Список.ТекущаяСтрока, "");
		
	МассивВозврата = Новый Массив;
	МассивВозврата.Добавить(ПараметрыВозврата);
	
	Закрыть(МассивВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВозврата = Новый Структура("ТипСвязи, СсылкаНа, СвязанныйДокумент, Комментарий", 
		ТипСвязи, СсылкаНа, Элементы.Список.ТекущаяСтрока, "");
		
	МассивВозврата = Новый Массив;
	МассивВозврата.Добавить(ПараметрыВозврата);
	
	Закрыть(МассивВозврата);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьУдаленные()
	
	Если ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь);
	КонецЕсли;	
	
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры          

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	
	ПоказатьУдаленные();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
	ПоказатьУдаленные();
	
КонецПроцедуры

