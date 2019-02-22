
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОбъектыИспользующиеДескриптор.Параметры.УстановитьЗначениеПараметра("Дескриптор", Объект.Ссылка);
	УникальныйИдентификаторДескриптора = Объект.Ссылка.УникальныйИдентификатор();
	ЗаполнитьТаблицуПрав();
	ЗаполнитьЗаголовкиСтраниц(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗаголовкиСтраниц(ЗаполнятьСтраницуОбъекты = Ложь)
	
	КоличествоПользователейВПравах = ПраваДоступа.Количество();
	Если КоличествоПользователейВПравах > 0 Тогда
		ЗаголовокПраваДоступа = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Права доступа (%1)'; en = 'Permissions (%1)'"), КоличествоПользователейВПравах);
	Иначе
		ЗаголовокПраваДоступа = НСтр("ru = 'Права доступа'; en = 'Permissions'");
	КонецЕсли;
	
	Если ЗаполнятьСтраницуОбъекты Тогда
		
		Запрос = Новый Запрос(ОбъектыИспользующиеДескриптор.ТекстЗапроса);
		Запрос.Параметры.Вставить("Дескриптор", Объект.Ссылка);
		КоличествоОбъектов = Запрос.Выполнить().Выбрать().Количество();
		
		Если КоличествоОбъектов > 0 Тогда
			ЗаголовокОбъекты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Объекты (%1)'; en = 'Objects (%1)'"), КоличествоОбъектов);
		Иначе
			ЗаголовокОбъекты = НСтр("ru = 'Объекты'; en = 'Objects'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОбновитьПрава(Команда)
	
	ОбновитьПраваНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПраваНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Протокол = Новый Массив;
	
	// Немедленный расчет прав без обновления зависимых прав.
	Справочники.ДескрипторыДоступаОбъектов.РассчитатьПрава(Объект.Ссылка, Протокол);
	
	// Постановка в очередь для расчета прав зависимых объектов.
	Справочники.ДескрипторыДоступаОбъектов.ОбновитьПрава(Объект.Ссылка);
	
	Элементы.ОбъектыИспользующиеДескриптор.Обновить();
	Элементы.СтраницаПротоколРасчетаПрав.Видимость = Истина;
	Элементы.ГруппаПраваДоступаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	
	ПротоколРасчетаПрав.Очистить();
	
	Для Каждого Эл Из Протокол Цикл
		
		ТипЭлемента = ТипЗнч(Эл);
		Строка = ПротоколРасчетаПрав.Добавить();
		Если ТипЭлемента = Тип("Строка") Тогда
			Строка.Описание = Эл;
		ИначеЕсли ТипЭлемента = Тип("Структура") Тогда
			ЗаполнитьЗначенияСвойств(Строка, Эл);
		Иначе
			Строка.Описание = Строка(Эл) + " (" + Строка(ТипЗнч(Эл)) + ")";
			Строка.Элемент = Эл;
		КонецЕсли;	
		
	КонецЦикла;
	
	// Добавление руководителей, делегатов и неограниченных прав в протокол расчета.
	Если Константы.ДобавлятьРуководителямДоступПодчиненных.Получить() Тогда
		Строка = ПротоколРасчетаПрав.Добавить();
		Строка.Элемент = НСтр("ru = 'Руководители'; en = 'Heads'");
		Строка.Описание = НСтр("ru = 'Руководители'; en = 'Heads'");
	КонецЕсли;
	
	Строка = ПротоколРасчетаПрав.Добавить();
	Строка.Элемент = НСтр("ru = 'Делегаты'; en = 'Delegates'");
	Строка.Описание = НСтр("ru = 'Делегаты'; en = 'Delegates'");
	
	Строка = ПротоколРасчетаПрав.Добавить();
	Строка.Элемент = "НеограниченныеПраваНаТаблицу";
	Строка.Описание = НСтр("ru = 'Неограниченные права на таблицу'; en = 'Unlimited permissions to table'");
	
	ЗаполнитьТаблицуПрав();
	ЗаполнитьЗаголовкиСтраниц();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦ ФОРМЫ

&НаКлиенте
Процедура ПраваДоступаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Пользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПротоколРасчетаПравВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ПротоколРасчетаПрав.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТипЭлементаПротокола = ТипЗнч(ТекущиеДанные.Элемент);
	
	Если ТекущиеДанные.Элемент = "Руководители" Тогда
		
		ОткрытьФорму("Справочник.СтруктураПредприятия.ФормаСписка");
		
	ИначеЕсли ТекущиеДанные.Элемент = "Делегаты" Тогда
		
		ОткрытьФорму("Справочник.ДелегированиеПрав.ФормаСписка");
		
	ИначеЕсли ТекущиеДанные.Элемент = "РабочаяГруппа" Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'См. закладку ""Рабочая группа"" на странице ""Дескриптор""'; en = 'See tab. ""Working group"" on the page ""Descriptor""'"));
		
	ИначеЕсли ТекущиеДанные.Элемент = "НеограниченныеПраваНаТаблицу" Тогда
		
		// Открытие отчета по группам с неограниченными правами
		ПараметрыОтчета = Новый Структура("ОбъектМетаданных", Объект.ИдентификаторОбъектаМетаданных);
		ОткрытьФорму("Отчет.НеограниченныеПрава.Форма.ФормаОтчета", ПараметрыОтчета);
		
	ИначеЕсли ТекущиеДанные.Элемент = "НастройкиПравПапки" Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'См. закладку ""Настройка прав"" на странице ""Дескриптор""'; en = 'See tab ""Permissions settings"" on page ""Descriptor""'"));
		
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.Элемент) Тогда
		
		Если ТипЭлементаПротокола = Тип("Строка") Тогда
			ПоказатьПредупреждение(, ТекущиеДанные.Элемент);
		Иначе
			ПоказатьЗначение(, ТекущиеДанные.Элемент);
		КонецЕсли;
			
	Иначе
		
		ПоказатьПредупреждение(, ТекущиеДанные.Описание);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыИспользующиеДескрипторВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Объект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере	
Процедура ЗаполнитьТаблицуПрав()
	
	ТаблицаПрав = ДокументооборотПраваДоступа.ПолучитьТаблицуПравДляОтображенияВИнтерфейсе(Объект.Ссылка);
	ПраваДоступа.Загрузить(ТаблицаПрав);
	
КонецПроцедуры


