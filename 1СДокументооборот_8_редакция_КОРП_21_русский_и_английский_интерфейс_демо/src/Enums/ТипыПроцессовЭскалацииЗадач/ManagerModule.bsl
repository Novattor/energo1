#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует имя справочника и типа шаблона по типу процесса.
//
// Параметры:
//  ТипПроцесса - ПеречислениеСсылка.ТипыПроцессовЭскалацииЗадач - Тип процесса.
//
// Возвращаемое значение:
//  Структура - Имя справочника и тип шаблона.
//   * ИмяСправочника - Строка - Имя справочника.
//   * ТипШаблона - Строка - Тип шаблона составного процесса.
//
Функция ДанныеШаблона(ТипПроцесса) Экспорт
	
	ДанныеШаблона = Новый Структура;
	ДанныеШаблона.Вставить("ТипПроцесса", ТипПроцесса);
	ДанныеШаблона.Вставить("ИмяСправочника", Неопределено);
	ДанныеШаблона.Вставить("Тип", Неопределено);
	ДанныеШаблона.Вставить("ТипШаблона", Неопределено);
	ДанныеШаблона.Вставить("ПустаяСсылка", Неопределено);
	
	Если ТипПроцесса = Исполнение Тогда
		ДанныеШаблона.ИмяСправочника = "ШаблоныИсполнения";
		ДанныеШаблона.Тип = Тип("СправочникСсылка.ШаблоныИсполнения");
		ДанныеШаблона.ПустаяСсылка = Справочники.ШаблоныИсполнения.ПустаяСсылка();
	ИначеЕсли ТипПроцесса = КомплексныйПроцесс Тогда
		ДанныеШаблона.ИмяСправочника = "ШаблоныКомплексныхБизнесПроцессов";
		ДанныеШаблона.Тип = Тип("СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов");
		ДанныеШаблона.ПустаяСсылка = Справочники.ШаблоныКомплексныхБизнесПроцессов.ПустаяСсылка();
	ИначеЕсли ТипПроцесса = Ознакомление Тогда
		ДанныеШаблона.ИмяСправочника = "ШаблоныОзнакомления";
		ДанныеШаблона.Тип = Тип("СправочникСсылка.ШаблоныОзнакомления");
		ДанныеШаблона.ПустаяСсылка = Справочники.ШаблоныОзнакомления.ПустаяСсылка();
	ИначеЕсли ТипПроцесса = Приглашение Тогда
		ДанныеШаблона.ИмяСправочника = "ШаблоныПриглашения";
		ДанныеШаблона.Тип = Тип("СправочникСсылка.ШаблоныПриглашения");
		ДанныеШаблона.ПустаяСсылка = Справочники.ШаблоныПриглашения.ПустаяСсылка();
	ИначеЕсли ТипПроцесса = Рассмотрение Тогда
		ДанныеШаблона.ИмяСправочника = "ШаблоныРассмотрения";
		ДанныеШаблона.Тип = Тип("СправочникСсылка.ШаблоныРассмотрения");
		ДанныеШаблона.ПустаяСсылка = Справочники.ШаблоныРассмотрения.ПустаяСсылка();
	ИначеЕсли ТипПроцесса = Регистрация Тогда
		ДанныеШаблона.ИмяСправочника = "ШаблоныРегистрации";
		ДанныеШаблона.Тип = Тип("СправочникСсылка.ШаблоныРегистрации");
		ДанныеШаблона.ПустаяСсылка = Справочники.ШаблоныРегистрации.ПустаяСсылка();
	ИначеЕсли ТипПроцесса = Согласование Тогда
		ДанныеШаблона.ИмяСправочника = "ШаблоныСогласования";
		ДанныеШаблона.Тип = Тип("СправочникСсылка.ШаблоныСогласования");
		ДанныеШаблона.ПустаяСсылка = Справочники.ШаблоныСогласования.ПустаяСсылка();
	ИначеЕсли ТипПроцесса = Утверждение Тогда
		ДанныеШаблона.ИмяСправочника = "ШаблоныУтверждения";
		ДанныеШаблона.Тип = Тип("СправочникСсылка.ШаблоныУтверждения");
		ДанныеШаблона.ПустаяСсылка = Справочники.ШаблоныУтверждения.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ДанныеШаблона;
	
КонецФункции

// Формирует массив точек маршрута, доступных для эскалации по типу процесса.
//
// Параметры:
//  ТипПроцесса - ПеречислениеСсылка.ТипыПроцессовЭскалацииЗадач - Тип процесса.
//  ПоУмолчанию - Булево - По умолчанию.
// 
// Возвращаемое значение:
//  Массив - Точки маршрута.
//
Функция ТочкиМаршрутаПоТипуПроцесса(ТипПроцесса, ПоУмолчанию) Экспорт
	
	ТочкиМаршрута = Новый Массив;
	Если ТипПроцесса = Исполнение Тогда
		ТочкиМаршрута.Добавить(БизнесПроцессы.Исполнение.ТочкиМаршрута.ОтветственноеИсполнение);
		ТочкиМаршрута.Добавить(БизнесПроцессы.Исполнение.ТочкиМаршрута.Исполнить);
		Если Не ПоУмолчанию Тогда
			ТочкиМаршрута.Добавить(БизнесПроцессы.Исполнение.ТочкиМаршрута.Проверить);
		КонецЕсли;
	ИначеЕсли ТипПроцесса = Ознакомление Тогда
		ТочкиМаршрута.Добавить(БизнесПроцессы.Ознакомление.ТочкиМаршрута.Ознакомиться);
	ИначеЕсли ТипПроцесса = Приглашение Тогда
		ТочкиМаршрута.Добавить(БизнесПроцессы.Приглашение.ТочкиМаршрута.Пригласить);
		Если Не ПоУмолчанию Тогда
			ТочкиМаршрута.Добавить(БизнесПроцессы.Приглашение.ТочкиМаршрута.Ознакомиться);
			ТочкиМаршрута.Добавить(БизнесПроцессы.Приглашение.ТочкиМаршрута.Оповестить);
		КонецЕсли;
	ИначеЕсли ТипПроцесса = Рассмотрение Тогда
		ТочкиМаршрута.Добавить(БизнесПроцессы.Рассмотрение.ТочкиМаршрута.Рассмотреть);
		Если Не ПоУмолчанию Тогда
			ТочкиМаршрута.Добавить(БизнесПроцессы.Рассмотрение.ТочкиМаршрута.Ознакомиться);
		КонецЕсли;
	ИначеЕсли ТипПроцесса = Регистрация Тогда
		ТочкиМаршрута.Добавить(БизнесПроцессы.Регистрация.ТочкиМаршрута.Зарегистрировать);
		Если Не ПоУмолчанию Тогда
			ТочкиМаршрута.Добавить(БизнесПроцессы.Регистрация.ТочкиМаршрута.Ознакомиться);
		КонецЕсли;
	ИначеЕсли ТипПроцесса = Согласование Тогда
		ТочкиМаршрута.Добавить(БизнесПроцессы.Согласование.ТочкиМаршрута.Согласовать);
		Если Не ПоУмолчанию Тогда
			ТочкиМаршрута.Добавить(БизнесПроцессы.Согласование.ТочкиМаршрута.Ознакомиться);
		КонецЕсли;
	ИначеЕсли ТипПроцесса = Утверждение Тогда
		ТочкиМаршрута.Добавить(БизнесПроцессы.Утверждение.ТочкиМаршрута.Утвердить);
		Если Не ПоУмолчанию Тогда
			ТочкиМаршрута.Добавить(БизнесПроцессы.Утверждение.ТочкиМаршрута.Ознакомиться);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТочкиМаршрута;
	
КонецФункции

// Определяет по типу шаблона тип процесса.
//
// Параметры:
//  Шаблон - СправочникСсылка - Шаблон.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыПроцессовЭскалацииЗадач - Тип процесса.
//
Функция ТипПроцессаПоШаблону(Шаблон) Экспорт
	
	ТипПроцесса = Неопределено;
	ТипШаблона = ТипЗнч(Шаблон);
	Если ТипШаблона = Тип("СправочникСсылка.ШаблоныИсполнения") Тогда
		ТипПроцесса = Исполнение;
	ИначеЕсли ТипШаблона = Тип("СправочникСсылка.ШаблоныОзнакомления") Тогда
		ТипПроцесса = Ознакомление;
	ИначеЕсли ТипШаблона = Тип("СправочникСсылка.ШаблоныПриглашения") Тогда
		ТипПроцесса = Приглашение;
	ИначеЕсли ТипШаблона = Тип("СправочникСсылка.ШаблоныРассмотрения") Тогда
		ТипПроцесса = Рассмотрение;
	ИначеЕсли ТипШаблона = Тип("СправочникСсылка.ШаблоныРегистрации") Тогда
		ТипПроцесса = Регистрация;
	ИначеЕсли ТипШаблона = Тип("СправочникСсылка.ШаблоныСогласования") Тогда
		ТипПроцесса = Согласование;
	ИначеЕсли ТипШаблона = Тип("СправочникСсылка.ШаблоныУтверждения") Тогда
		ТипПроцесса = Утверждение;
	ИначеЕсли ТипШаблона = Тип("СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов") Тогда
		ТипПроцесса = КомплексныйПроцесс;
	КонецЕсли;
	
	Возврат ТипПроцесса;
	
КонецФункции

// Возвращает признак того, что переданный тип процесса является комплексным.
//
// Параметры:
//  ТипПроцесса - ПеречислениеСсылка.ТипыПроцессовЭскалацииЗадач - Тип процесса.
//
// Возвращаемое значение:
//  Булево - Это комплекнсый процесс.
//
Функция ЭтоКомплексныйПроцесс(ТипПроцесса) Экспорт
	
	ТипыПроцессов = Новый Массив;
	ТипыПроцессов.Добавить(ТипПроцесса);
	Набор = НаборТиповПроцессов(ТипыПроцессов);
	
	Возврат (Набор = "Комплексные");
	
КонецФункции

// Возвращает признак того, что переданный тип процесса является обычным.
//
// Параметры:
//  ТипПроцесса - ПеречислениеСсылка.ТипыПроцессовЭскалацииЗадач - Тип процесса.
//
// Возвращаемое значение:
//  Булево - Это обычный процесс.
//
Функция ЭтоОбычныйПроцесс(ТипПроцесса) Экспорт
	
	ТипыПроцессов = Новый Массив;
	ТипыПроцессов.Добавить(ТипПроцесса);
	Набор = НаборТиповПроцессов(ТипыПроцессов);
	
	Возврат (Набор = "Обычные");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает набор типов процессов.
//
// Параметры:
//  УсловияТипыПроцессов - Массив - Типы процессов.
//
// Возвращаемое значение:
//  Строка - Набор типов процессов.
//
Функция НаборТиповПроцессов(ТипыПроцессов)
	
	// Набор "Обычные".
	Для Каждого ТипПроцесса Из ТипыПроцессовОбычные() Цикл
		Если ТипыПроцессов.Найти(ТипПроцесса) <> Неопределено Тогда
			Возврат "Обычные";
		КонецЕсли;
	КонецЦикла;
	
	// Набор "Комплексные".
	Для Каждого ТипПроцесса Из ТипыПроцессовКомплексные() Цикл
		Если ТипыПроцессов.Найти(ТипПроцесса) <> Неопределено Тогда
			Возврат "Комплексные";
		КонецЕсли;
	КонецЦикла;
	
	// Набор "Все".
	Набор = "Все";
	
	Возврат Набор;
	
КонецФункции

// Возвращает типы процессов набора "Обычные".
//
// Возвращаемое значение:
//  Массив - Типы процессов набора.
//
Функция ТипыПроцессовОбычные()
	
	ТипыПроцессов = Новый Массив;
	ТипыПроцессов.Добавить(Исполнение);
	ТипыПроцессов.Добавить(Ознакомление);
	ТипыПроцессов.Добавить(Приглашение);
	ТипыПроцессов.Добавить(Рассмотрение);
	ТипыПроцессов.Добавить(Регистрация);
	ТипыПроцессов.Добавить(Согласование);
	ТипыПроцессов.Добавить(Утверждение);
	
	Возврат ТипыПроцессов;
	
КонецФункции

// Возвращает типы процессов набора "Комплексные".
//
// Возвращаемое значение:
//  Массив - Типы процессов набора.
//
Функция ТипыПроцессовКомплексные()
	
	ТипыПроцессов = Новый Массив;
	ТипыПроцессов.Добавить(КомплексныйПроцесс);
	
	Возврат ТипыПроцессов;
	
КонецФункции

#КонецОбласти

#КонецЕсли
