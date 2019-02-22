
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТаблицаТипов") Тогда 
		
		ТаблицаТипов.Загрузить(ДанныеФормыВЗначение(Параметры.ТаблицаТипов, Тип("ТаблицаЗначений")));
		ЭлементСпискаВыбора = Элементы.ТипДокумента.СписокВыбора;
		
		Для Каждого СтрокаТипа из ТаблицаТипов Цикл
			
			Если ЭлементСпискаВыбора.НайтиПоЗначению(СтрокаТипа.Тип) = Неопределено Тогда
				ПредставлениеТипа = ПолучитьПредставлениеТипа(СтрокаТипа.Тип);
				ЭлементСпискаВыбора.Добавить(СтрокаТипа.Тип, ПредставлениеТипа);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДокументаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ТипДокумента) Тогда
		ЗначениеПоУмолчанию = ?(ТипДокумента = "Строка", "", Новый(ТипДокумента));
		Если ТипЗнч(Документ) <> ТипЗнч(ЗначениеПоУмолчанию) Тогда
			Документ = ЗначениеПоУмолчанию;
		КонецЕсли;
	Иначе
		Документ = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ТипДокумента)
		И ТипДокумента <> "Строка" 
	    И ТипДокумента <> "СправочникСсылка.Файлы" Тогда 
		
		// Заполнение отбора по виду документа
		МассивВидовДокументов = Новый Массив;
		СтрокиТипа = ТаблицаТипов.НайтиСтроки(Новый Структура("Тип", ТипДокумента));
		Для Каждого СтрокаТипа Из СтрокиТипа Цикл 
			
			Если ЗначениеЗаполнено(СтрокаТипа.Вид) Тогда 
				Если МассивВидовДокументов.Найти(СтрокаТипа.Вид) = Неопределено Тогда
					МассивВидовДокументов.Добавить(СтрокаТипа.Вид);
				КонецЕсли;
			Иначе
				// Настройка предусматривает любой вид документа, отбор не нужен
				МассивВидовДокументов.Очистить();
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Поз = Найти(ТипДокумента, ".");
		ИмяФормыВыбора = "Справочник." + Сред(ТипДокумента, Поз + 1) + ".ФормаВыбора";
		
		ПараметрыФормы = Новый Структура;
		Если МассивВидовДокументов.Количество() > 0 Тогда
			ПараметрыФормы.Вставить("Отбор", Новый Структура("ВидДокумента", МассивВидовДокументов));
		КонецЕсли;
		
		ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, Элемент);
		
	ИначеЕсли ТипДокумента = "СправочникСсылка.Файлы" Тогда 
		
		ПараметрыФормы = Новый Структура("ТекущаяСтрока", Документ);
		ОткрытьФорму("Справочник.Файлы.Форма.ФормаВыбораФайлаВПапках", ПараметрыФормы, Элемент);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	Закрыть(Документ);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПредставлениеТипа(Значение)
	
	Если Значение = "Строка" Тогда 
		ПредставлениеТипа = НСтр("ru = 'Внешняя ссылка'; en = 'External link'");
	ИначеЕсли Значение = "СправочникСсылка.ВходящиеДокументы" Тогда 
		ПредставлениеТипа = НСтр("ru = 'Входящий документ'; en = 'Incoming document'");
	ИначеЕсли Значение = "СправочникСсылка.ИсходящиеДокументы" Тогда 
		ПредставлениеТипа = НСтр("ru = 'Исходящий документ'; en = 'Outgoing document'");
	ИначеЕсли Значение = "СправочникСсылка.ВнутренниеДокументы" Тогда 
		ПредставлениеТипа = НСтр("ru = 'Внутренний документ'; en = 'Internal document'");
	ИначеЕсли Значение = "СправочникСсылка.Файлы" Тогда 
		ПредставлениеТипа = НСтр("ru = 'Файл'; en = 'File'");
	Иначе	
		ПредставлениеТипа = "";
	КонецЕсли;
	
	Возврат ПредставлениеТипа;
	
КонецФункции


