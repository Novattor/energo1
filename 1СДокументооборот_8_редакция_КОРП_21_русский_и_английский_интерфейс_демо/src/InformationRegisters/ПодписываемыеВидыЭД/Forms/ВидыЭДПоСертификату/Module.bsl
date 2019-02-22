#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	АктуальныеЭД = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.АктуальныеВидыЭД();
	
	Для Каждого ВидЭД Из АктуальныеЭД Цикл
		Строки = ВидыПодписываемыхЭД.НайтиСтроки(Новый Структура("ВидЭД", ВидЭД));
		Если Строки.Количество() = 0 Тогда
			Если Параметры.Отбор.Свойство("СертификатЭП") Тогда
				НоваяЗапись = ВидыПодписываемыхЭД.Добавить();
				НоваяЗапись.СертификатЭП = Параметры.Отбор.СертификатЭП;
				НоваяЗапись.ВидЭД = ВидЭД;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ВидыПодписываемыхЭД.Сортировать("ВидЭД");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьИзмененияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьИзмененияНаСервере()
	
	Если Не ДанныеИзменены Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ПодписываемыеВидыЭД.СохранитьПодписываемыеВидыЭД(
		ВидыПодписываемыхЭД.Отбор.СертификатЭП.Значение, ВидыПодписываемыхЭД.Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	ИзменитьОтметку(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	ИзменитьОтметку(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОтметку(Пометка)
	
	Для Каждого Строка Из ВидыПодписываемыхЭД Цикл
		Строка.Использовать = Пометка;
	КонецЦикла;
	ДанныеИзменены = Истина;
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИспользоватьПриИзменении(Элемент)
	
	ДанныеИзменены = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		
		УсловноеОформление.Элементы.Очистить();

		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидЭД.Имя);

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидыПодписываемыхЭД.ВидЭД");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Перечисления["ВидыЭД"].СоглашениеОбИзмененииСтоимостиОтправитель;

		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Соглашение об изменении стоимости (отправитель)'; en = 'Price change agreement (sender)'"));
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти






