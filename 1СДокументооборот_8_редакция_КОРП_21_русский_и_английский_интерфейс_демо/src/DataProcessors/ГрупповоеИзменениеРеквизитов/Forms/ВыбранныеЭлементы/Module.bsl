#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВыбранныеТипы = Параметры.ВыбранныеТипы;
	
	ОбъектОбработка = РеквизитФормыВЗначение("Объект");
	ТекстЗапроса = ОбъектОбработка.ТекстЗапроса(ВыбранныеТипы);
	
	ИнициализироватьКомпоновщикНастроек();
	КомпоновщикНастроек.ЗагрузитьНастройки(Параметры.Настройки);
	
	Список.ТекстЗапроса = ТекстЗапроса;
	
	ОбновитьСписокВыбранныхНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомпоновщикНастроекНастройкиОтбор

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ИнициализироватьОбновлениеСпискаВыбранных();
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПослеУдаления(Элемент)
	ИнициализироватьОбновлениеСпискаВыбранных();
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	ОтключитьОбработчикОжидания("ОбновитьСписокВыбранных");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Результат = КомпоновщикНастроек.Настройки;
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЭлемент(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьКомпоновщикНастроек()
	Если Не ПустаяСтрока(Параметры.ВыбранныеТипы) Тогда
		СхемаКомпоновкиДанных = СхемаКомпоновкиДанных(ТекстЗапроса);
		АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СхемаКомпоновкиДанных(ТекстЗапроса)
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ОбработкаОбъект.СхемаКомпоновкиДанных(ТекстЗапроса);
КонецФункции

&НаСервере
Процедура ОбновитьСписокВыбранныхНаСервере()
	
	Список.КомпоновщикНастроек.ЗагрузитьНастройки(КомпоновщикНастроек.Настройки);
	
	Структура = Список.КомпоновщикНастроек.Настройки.Структура;
	Структура.Очистить();
	ГруппировкаКомпоновкиДанных = Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ГруппировкаКомпоновкиДанных.Использование = Истина;
	
	Выбор = Список.КомпоновщикНастроек.Настройки.Выбор;
	ПолеВыбора = Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	ПолеВыбора.Использование = Истина;
	
	Элементы.ГруппаВыбранныеОбъекты.Заголовок = ПодставитьПараметрыВСтроку(НСтр("ru = 'Выбранные элементы (%1)'; en = 'Selected items (%1)'"), ВыбранныеОбъекты().Строки.Количество());
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьОбновлениеСпискаВыбранных()
	ОтключитьОбработчикОжидания("ОбновитьСписокВыбранных");
	Если Элементы.ГруппаВыбранныеОбъекты.Видимость Тогда
		ПодключитьОбработчикОжидания("ОбновитьСписокВыбранных", 1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокВыбранных()
	ОбновитьСписокВыбранныхНаСервере();
КонецПроцедуры

&НаСервере
Функция ВыбранныеОбъекты()
	
	Результат = Новый ДеревоЗначений;
	
	Если Не ПустаяСтрока(ВыбранныеТипы) Тогда
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		ТекстЗапроса = ОбработкаОбъект.ТекстЗапроса(ВыбранныеТипы);
		СхемаКомпоновкиДанных = СхемаКомпоновкиДанных(ТекстЗапроса);
		
		КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
		АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
		КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
		КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(КомпоновщикНастроек.Настройки);
		
		Результат = Новый ДеревоЗначений;
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		Попытка
			МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
				КомпоновщикНастроекКомпоновкиДанных.Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		Исключение
			Возврат Результат;
		КонецПопытки;
		
		ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);

		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ПроцессорВывода.УстановитьОбъект(Результат);
		ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		АдресСпискаВыбранных = ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено)
	
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%1", Параметр1);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%2", Параметр2);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%3", Параметр3);
	
	Возврат СтрокаПодстановки;
КонецФункции

#КонецОбласти
