
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Для Каждого Элемент Из Параметры.СписокЗначений Цикл
		НоваяСтрока = ТаблицаСтрок.Добавить();
		НоваяСтрока.Строка = Элемент.Значение;
		НоваяСтрока.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"""%1""",
			НоваяСтрока.Строка);
		
		Если ТаблицаСтрок.Количество() > 1 Тогда
			ДанныеПредыдущейСтроки = ТаблицаСтрок[ТаблицаСтрок.Количество() - 2];
			ДанныеПредыдущейСтроки.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"""%1"" %2",
				ДанныеПредыдущейСтроки.Строка,
				НСтр("ru = 'или'; en = 'or'"));
		КонецЕсли;
	КонецЦикла;
	
	Если ТаблицаСтрок.Количество() = 0 Тогда
		НоваяСтрока = ТаблицаСтрок.Добавить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ВозвращаемыйСписок = Новый СписокЗначений();
	Для Каждого СтрокаТаблицы Из ТаблицаСтрок Цикл
		ВозвращаемыйСписок.Добавить(СтрокаТаблицы.Строка);
	КонецЦикла;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Список", ВозвращаемыйСписок);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаДляДобавленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыОткрытия = Новый Структура;
	
	ПараметрыОткрытия.Вставить("РежимРаботыФормы", 1);
	ПараметрыОткрытия.Вставить("ОтображатьКонтрагентов", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьЛичныхАдресатов", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьРоли", Истина);
	ПараметрыОткрытия.Вставить("ВыбиратьЭлектронныеАдреса", Истина);
	
	// Открытие формы для редактирования списка адресатов
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СтрокаДляДобавленияНачалоВыбораПродолжение",
		ЭтотОбъект);
	
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыОткрытия, ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаДляДобавленияНачалоВыбораПродолжение(Результат, Параметры) Экспорт
	
	Если (ТипЗнч(Результат) <> Тип("Массив")) И (ТипЗнч(Результат) <> Тип("Соответствие")) Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Количество() > 0 Тогда
		Элементы.ТаблицаСтрок.ТекущиеДанные.Строка = Результат[0].Адрес;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаДляДобавленияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Элементы.ТаблицаСтрок.ТекущиеДанные.Строка = ВыбранноеЗначение.Представление;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаДляДобавленияОкончаниеВводаТекстаПродолжение(РезультатВыбора, Параметры) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
		Элементы.ТаблицаСтрок.ТекущиеДанные.Строка = РезультатВыбора.Значение.Представление;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтрокСтрокаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Текст) Или СтрДлина(Текст) < 2 Тогда
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		Возврат;
	#КонецЕсли
	
	ЭтоВебКлиент = Ложь;
	#Если ВебКлиент Тогда
		ЭтоВебКлиент = Истина;
	#КонецЕсли
	
	ДанныеВыбора = ВстроеннаяПочтаСервер.ПолучитьДанныеВыбораДляЭлектронногоПисьма(Текст, 
		ТекущийПользователь, 
		ЭтоВебКлиент);
	ВстроеннаяПочтаКлиент.ЗаполнитьКартинкиВСпискеВыбора(ДанныеВыбора);		

	Если ДанныеВыбора.Количество() <> 0 Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтрокСтрокаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Текст) Или СтрДлина(Текст) < 2 Тогда
		Возврат;
	КонецЕсли;
	
	НовыйТекст = Текст;
	СтандартнаяОбработка = Ложь;
	ЭтоВебКлиент = Ложь;
	#Если ВебКлиент Тогда
		ЭтоВебКлиент = Истина;
	#КонецЕсли
	
	РезультатВыбора = Неопределено;
	ДанныеВыбора = ВстроеннаяПочтаСервер.ПолучитьДанныеВыбораДляЭлектронногоПисьма(
		Текст, 
		ТекущийПользователь, 
		ЭтоВебКлиент);
	ВстроеннаяПочтаКлиент.ЗаполнитьКартинкиВСпискеВыбора(ДанныеВыбора);	
	
	Если ДанныеВыбора.Количество() = 1 Тогда
		РезультатВыбора = ДанныеВыбора[0];
		Если РезультатВыбора <> Неопределено Тогда
			Элементы.ТаблицаСтрок.ТекущиеДанные.Строка = РезультатВыбора.Значение.Представление;
		КонецЕсли;
	ИначеЕсли ДанныеВыбора.Количество() > 1 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"СтрокаДляДобавленияОкончаниеВводаТекстаПродолжение",
			ЭтотОбъект);
		ПоказатьВыборИзСписка(ОписаниеОповещения, ДанныеВыбора);
	КонецЕсли;
	
КонецПроцедуры


