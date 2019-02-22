
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Автор = ПараметрыСеанса.ТекущийПользователь;
		Объект.ДатаСоздания = ТекущаяДатаСеанса();
		Объект.Используется = Истина;
		Если Параметры.Свойство("Категория")
			И Параметры.Категория <> Неопределено
			И НЕ Параметры.Категория.Пустая() Тогда
			Объект.Категория = Параметры.Категория;
		КонецЕсли;

		Для Каждого Тип Из Перечисления.ТипыОбъектов Цикл
			НоваяСтрока = ТипыДанныхДляПравила.Добавить();
			НоваяСтрока.Выбран = Ложь;
			НоваяСтрока.ТипДанных = Тип;
			Если Параметры.Свойство("ЗначениеКопирования")
				И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
				Для Каждого ТипОбъекта Из Параметры.ЗначениеКопирования.ТипыОбъектов Цикл
					Если ТипОбъекта.ТипДанных = Тип Тогда
						НоваяСтрока.Выбран = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		Для Каждого Тип Из Перечисления.ТипыОбъектов Цикл
			Если Тип = Перечисления.ТипыОбъектов.Контрагенты Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока = ТипыДанныхДляПравила.Добавить();
			НоваяСтрока.ТипДанных = Тип;
			НоваяСтрока.Выбран = Ложь;
			Для Каждого ТипОбъекта Из Объект.ТипыОбъектов Цикл
				Если ТипОбъекта.ТипДанных = Тип Тогда
					НоваяСтрока.Выбран = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Если Объект.Используется Тогда
		Элементы.Используется.Подсказка = НСтр("ru = 'Данное правило будет использоваться при автокатегоризации.'; en = 'This rule will be used for automatic categorization.'");
	Иначе
		Элементы.Используется.Подсказка = НСтр("ru = 'Данное правило не будет использоваться при автокатегоризации.'; en = 'This rule will not be used for automatic categorization.'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОписаниеОповещения = Новый ОписаниеОповещения("УсловияПередНачаломИзмененияПродолжение",
		ЭтотОбъект,
		Новый Структура("Элемент", Элемент));

	ОткрытьФормуРедактированияУсловия(Элемент, Ложь, ОписаниеОповещения);
		
КонецПроцедуры

&НаКлиенте
Процедура УсловияПередНачаломИзмененияПродолжение(Результат, Параметры)Экспорт 

	Если Результат <> Неопределено Тогда
		Элемент = Параметры.Элемент;
		Модифицированность = НЕ (Элемент.ТекущиеДанные.ВидУсловия = Результат.ВидУсловия 
			И Элемент.ТекущиеДанные.Выражение = Результат.ЗначениеУсловия);  
		Элемент.ТекущиеДанные.ВидУсловия = Результат.ВидУсловия;
		Элемент.ТекущиеДанные.Выражение = Результат.ЗначениеУсловия;
		ТекстУсловия = Элемент.ТекущиеДанные.Выражение;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияУсловия(Элемент, СозданиеНового, ОписаниеОповещения)
	
	ДанныеУсловия = Неопределено;
	Если НЕ СозданиеНового Тогда
		ДанныеУсловия = Новый Структура("ВидУсловия, Выражение", 
			Элемент.ТекущиеДанные.ВидУсловия, Элемент.ТекущиеДанные.Выражение);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.правилаАвтоматическойКатегоризацииДанных.Форма.ФормаНастройкиУсловия",
		ДанныеУсловия,
		Элемент,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура УсловияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ОписаниеОповещения = Новый ОписаниеОповещения("УсловияПередНачаломДобавленияПродолжение",
		ЭтотОбъект,
		Новый Структура("Элемент", Элемент));

	ОткрытьФормуРедактированияУсловия(Элемент, Не Копирование, ОписаниеОповещения);
	
 КонецПроцедуры

&НаКлиенте
Процедура УсловияПередНачаломДобавленияПродолжение(Результат, Параметры)Экспорт 

	Если Результат <> Неопределено Тогда
		Модифицированность = Истина;
		НоваяСтрока = Объект.Условия.Добавить();
		НоваяСтрока.ВидУсловия = Результат.ВидУсловия;
		НоваяСтрока.Выражение = Результат.ЗначениеУсловия;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
 Процедура УсловияОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	 
	СтандартнаяОбработка = Ложь;
	Если НовыйОбъект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НовыйОбъект.ДобавлениеНового Тогда
		Строка = Объект.Условия.Добавить();
		Строка.ВидУсловия = НовыйОбъект.ВидУсловия;
		Строка.Выражение = НовыйОбъект.ЗначениеУсловия;
	Иначе
		Элементы.Условия.ТекущиеДанные.ВидУсловия = НовыйОбъект.ВидУсловия;
		Элементы.Условия.ТекущиеДанные.Выражение = НовыйОбъект.ЗначениеУсловия;
	КонецЕсли;
	
	ТекстУсловия = НовыйОбъект.ЗначениеУсловия;
	
	Модифицированность = Истина;
	
 КонецПроцедуры

&НаКлиенте
 Процедура УсловияПриАктивизацииСтроки(Элемент)
	 
	 Если НЕ Элемент.ТекущиеДанные = Неопределено Тогда
	 	ТекстУсловия = Элемент.ТекущиеДанные.Выражение;
	 КонецЕсли;
	 
 КонецПроцедуры

&НаКлиенте
Процедура УсловияПослеУдаления(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ТекстУсловия = Элемент.ТекущиеДанные.Выражение;
	Иначе
		ТекстУсловия = "";
	КонецЕсли;
	
	Модифицированность = Истина;
	
 КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	 
	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КатегорииОбъектов.ОбъектДанных,
		|	КатегорииОбъектов.КатегорияДанных
		|ИЗ
		|	РегистрСведений.КатегорииОбъектов КАК КатегорииОбъектов
		|ГДЕ
		|	КатегорииОбъектов.Автор = &Автор";

	Запрос.УстановитьПараметр("Автор", Объект.Ссылка);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаписьОКатегории = РегистрыСведений.КатегорииОбъектов.СоздатьМенеджерЗаписи();
		ЗаписьОКатегории.ОбъектДанных = ВыборкаДетальныеЗаписи.ОбъектДанных;
		ЗаписьОКатегории.КатегорияДанных = ВыборкаДетальныеЗаписи.КатегорияДанных;
		ЗаписьОКатегории.Прочитать();
		Если ЗаписьОКатегории.Выбран() Тогда
			ЗаписьОКатегории.Автор = Справочники.ПравилаАвтозаполненияФайлов.ПустаяСсылка();
			ЗаписьОКатегории.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
 Процедура ПроверитьПравило(Команда)
	 
	 ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПравилоПродолжение",
		ЭтотОбъект);

	Если Модифицированность Или Объект.Ссылка.Пустая() Тогда
		ТекстВопроса = НСтр("ru = 'Данные формы не сохранены. Перед выполнением проверки необходимо сохранить правило.
			|Выполнить сохранение?';
			|en = 'The form data is not saved. Before starting verfication you must save the rule.
			|Save?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	Иначе 
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.ОК);
	КонецЕсли;
	 
КонецПроцедуры
	
&НаКлиенте
Процедура ПроверитьПравилоПродолжение(Результат, Параметры)Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
    ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ПравилоАК", Объект.Ссылка);
	ОткрытьФорму("Справочник.ПравилаАвтоматическойКатегоризацииДанных.Форма.ФормаПроверкаПравила",
		ПараметрыФормы,,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
		
	СписокДопустимыхТипов = "";
	ТекущийОбъект.ТипыОбъектов.Очистить();
	Для Каждого ТипОбъектов Из ТипыДанныхДляПравила Цикл
		Если ТипОбъектов.Выбран Тогда
			НоваяСтрока = ТекущийОбъект.ТипыОбъектов.Добавить();
			НоваяСтрока.ТипДанных = ТипОбъектов.ТипДанных;
			Если ПустаяСтрока(СписокДопустимыхТипов) Тогда
				СписокДопустимыхТипов = Строка(ТипОбъектов.ТипДанных);
			Иначе
				СписокДопустимыхТипов = СписокДопустимыхТипов + ", " + Строка(ТипОбъектов.ТипДанных);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если НЕ ЗначениеЗаполнено(СписокДопустимыхТипов) Тогда
		Текст = НСтр("ru = 'Не отмечено ни одного типа объектов для правила'; en = 'Not a single object type is marked for the rule'");	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,, "ТипыДанныхДляПравила",, Отказ);
	КонецЕсли;
	ТекущийОбъект.СписокДопустимыхТипов = СписокДопустимыхТипов;
	ТекущийОбъект.КоличествоУсловий = ТекущийОбъект.Условия.Количество();
	
	Если Объект.Условия.Количество() = 0 Тогда
		Текст = НСтр("ru = 'Не задано ни одного условия'; en = 'Not a single condition is specified'");	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,, "Объект.Условия",, Отказ);	
	КонецЕсли;
		
КонецПроцедуры 

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Текст = НСтр("ru = 'Идет обновление признака автоматической категоризации данных. Пожалуйста, подождите...'; en = 'Mark of automatic categorization is being updated. Please wait...'");
	Состояние(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипыДанныхДляПравилаВыбранПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользуетсяПриИзменении(Элемент)
	
	Если Объект.Используется Тогда
		Элементы.Используется.Подсказка = НСтр("ru = 'Данное правило будет использоваться при автокатегоризации.'; en = 'This rule will be used for automatic categorization.'");
	Иначе
		Элементы.Используется.Подсказка = НСтр("ru = 'Данное правило не будет использоваться при автокатегоризации.'; en = 'This rule will not be used for automatic categorization.'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КатегорияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗапрещеноВыбиратьВсеКатегории", Истина);
	ОткрытьФорму("Справочник.КатегорииДанных.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

