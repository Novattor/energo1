#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.ЗначениеДоступа) Тогда
		// При открытии из истории параметр может быть пустым.
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Заголовок = НСтр("ru = 'Политики доступа'; en = 'Access policies'") + " (" + Параметры.ЗначениеДоступа + ")"; 
	
	МетаданныеЗначенияДоступа = Параметры.ЗначениеДоступа.Метаданные();
	ПолноеИмяСправочника = МетаданныеЗначенияДоступа.ПолноеИмя();
	
	РодителиЗначенияДоступа = Новый Массив;
	Если МетаданныеЗначенияДоступа.Иерархический Тогда
		Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ЗначениеДоступа, "Родитель");
		Пока ЗначениеЗаполнено(Родитель) Цикл
			РодителиЗначенияДоступа.Добавить(Родитель);
			Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "Родитель");
		КонецЦикла;
	КонецЕсли;
	
	ВидДоступа = Неопределено;
	ТаблицаРазрезовДоступа = ДокументооборотПраваДоступаПовтИсп.ТаблицаРазрезовДоступа();
	Для Каждого Стр Из ТаблицаРазрезовДоступа Цикл
		Если Стр.ИмяТаблицыЗначенийДоступа = ПолноеИмяСправочника Тогда
			ВидДоступа = Стр.ВидДоступа;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РазрешенияДоступаОбщие.Пользователь,
		|	РазрешенияДоступаОбщие.УровеньДоступа,
		|	ЛОЖЬ КАК Унаследован,
		|	РазрешенияДоступаОбщие.Пользователь.Наименование КАК ПредставлениеПользователя
		|ИЗ
		|	РегистрСведений.РазрешенияДоступаОбщие КАК РазрешенияДоступаОбщие
		|ГДЕ
		|	РазрешенияДоступаОбщие.ЗначениеДоступа = &ЗначениеДоступа
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	РазрешенияДоступаОбщие.Пользователь,
		|	РазрешенияДоступаОбщие.УровеньДоступа,
		|	ИСТИНА,
		|	РазрешенияДоступаОбщие.Пользователь.Наименование
		|ИЗ
		|	РегистрСведений.РазрешенияДоступаОбщие КАК РазрешенияДоступаОбщие
		|ГДЕ
		|	РазрешенияДоступаОбщие.ЗначениеДоступа В(&РодителиЗначенияДоступа)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	РазрешенияДоступаОбщие.Пользователь,
		|	РазрешенияДоступаОбщие.УровеньДоступа,
		|	ИСТИНА,
		|	РазрешенияДоступаОбщие.Пользователь.Наименование
		|ИЗ
		|	РегистрСведений.РазрешенияДоступаОбщие КАК РазрешенияДоступаОбщие
		|ГДЕ
		|	РазрешенияДоступаОбщие.ЗначениеДоступа = &ВидДоступа
		|
		|УПОРЯДОЧИТЬ ПО
		|	Унаследован УБЫВ,
		|	ПредставлениеПользователя");
	
	Запрос.УстановитьПараметр("ЗначениеДоступа", Параметры.ЗначениеДоступа);
	Запрос.УстановитьПараметр("РодителиЗначенияДоступа", РодителиЗначенияДоступа);
	Запрос.УстановитьПараметр("ВидДоступа", ВидДоступа);
	
	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(), "ТаблицаРазрешений");
	
	// Список выбора уровня доступа.
	СписокВыбора = Элементы.ТаблицаРазрешенийУровеньДоступа.СписокВыбора;
	СписокВыбора.Очистить();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	УровниДоступа.Ссылка
		|ИЗ
		|	Справочник.УровниДоступа КАК УровниДоступа
		|ГДЕ
		|	(&РазрешенаРегистрация
		|			ИЛИ УровниДоступа.Ссылка <> &Регистрация)
		|
		|УПОРЯДОЧИТЬ ПО
		|	УровниДоступа.Приоритет");
	
	Запрос.УстановитьПараметр("Регистрация", Справочники.УровниДоступа.Регистрация);
	Запрос.УстановитьПараметр("РазрешенаРегистрация", 
		НастройкиДоступаКлиентСервер.ВидыДоступаИспользующиеРегистрацию().Найти(ВидДоступа) <> Неопределено);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРазрешенийПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ТолькоПросмотрСтроки = Элемент.ТекущиеДанные.Унаследован;
		Элементы.ТаблицаРазрешенийУровеньДоступа.ТолькоПросмотр = ТолькоПросмотрСтроки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРазрешенийПередУдалением(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.Унаследован Тогда
		ТекстПредупреждения =
			НСтр("ru = 'Это разрешение нельзя удалить, т.к. оно унаследовано от вышестоящего элемента.'; en = 'This permission cannot be deleted, because it is inherited from a parent element.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРазрешенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("ВыборГруппПользователей", Истина);
	ПараметрыОткрытия.Вставить("РасширенныйПодбор", Ложь);
	
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРазрешенийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТипВыбранногоЗначения = ТипЗнч(ВыбранноеЗначение);
	
	Если ТипВыбранногоЗначения = Тип("СправочникСсылка.Пользователи")
		Или ТипВыбранногоЗначения = Тип("СправочникСсылка.РабочиеГруппы")
		Или ТипВыбранногоЗначения = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		
		НайденныеСтроки = ТаблицаРазрешений.НайтиСтроки(
			Новый Структура("Пользователь, Унаследован", ВыбранноеЗначение, Ложь));
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			Элементы.ТаблицаРазрешений.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
			Возврат;
		КонецЕсли;
		
		Стр = ТаблицаРазрешений.Добавить();
		Стр.Пользователь = ВыбранноеЗначение;
		Стр.УровеньДоступа = ПредопределенноеЗначение("Справочник.УровниДоступа.Редактирование");
		Стр.Унаследован = Ложь;
		
		ИдНовойСтроки = Стр.ПолучитьИдентификатор();
		ПодключитьОбработчикОжидания("УстановитьТекущуюСтроку", 0.1, Истина);
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущуюСтроку()
	
	Элементы.ТаблицаРазрешений.ТекущаяСтрока = ИдНовойСтроки;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРазрешенийУровеньДоступаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если Модифицированность Тогда
		ЗаписатьИЗакрытьНаСервере();
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере()
	
	Набор = РегистрыСведений.РазрешенияДоступаОбщие.СоздатьНаборЗаписей();
	Набор.Отбор.ЗначениеДоступа.Установить(Параметры.ЗначениеДоступа);
	
	Для Каждого Стр Из ТаблицаРазрешений Цикл
		Если Не Стр.Унаследован Тогда
			СтрокаНабора = Набор.Добавить();
			СтрокаНабора.Пользователь = Стр.Пользователь;
			СтрокаНабора.УровеньДоступа = Стр.УровеньДоступа;
			СтрокаНабора.ЗначениеДоступа = Параметры.ЗначениеДоступа;
		КонецЕсли;
	КонецЦикла;
	
	Набор.Записать();
	
КонецПроцедуры

#КонецОбласти
