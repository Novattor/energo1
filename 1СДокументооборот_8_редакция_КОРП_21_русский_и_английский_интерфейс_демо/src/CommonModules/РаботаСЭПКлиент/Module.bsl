////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции для работы с электронными подписями.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область РаботаСЭлектроннымиПодписями

Процедура ПроверитьПодписиОбъекта(Форма, ВыделенныеСтроки = Неопределено, ОбработчикЗавершения = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	ДополнительныеПараметры.Вставить("ИдентификаторФормы", Форма.УникальныйИдентификатор);
	
	Если ВыделенныеСтроки = Неопределено Тогда
		Коллекция = ПолучитьМассивДанныхПодписей(Форма.ЭлектронныеПодписи);
	Иначе
		Коллекция = ВыделенныеСтроки;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ВыделенныеСтроки", Коллекция);
	
	КоллекцияОбъектов = Новый Массив;
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		Если ТипЗнч(ЭлементКоллекции) = Тип("Число") Тогда
			Данные = Форма.ЭлектронныеПодписи.НайтиПоИдентификатору(ЭлементКоллекции);
		Иначе
			Данные = ЭлементКоллекции;
		КонецЕсли;
		Если КоллекцияОбъектов.Найти(Данные.Объект) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Данные.УникальныйИдентификатор) Тогда
			Продолжить;
		КонецЕсли;
		КоллекцияОбъектов.Добавить(Данные.Объект);
	КонецЦикла;
	
	ДополнительныеПараметры.Вставить("КоллекцияОбъектов", КоллекцияОбъектов);
	
	ДополнительныеПараметры.Вставить("ИндексОбъекта", -1);
	ПроверитьПодписиОбъектаЦиклОбъектовНачало(ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписиОбъекта.
Процедура ПроверитьПодписиОбъектаЦиклОбъектовНачало(ДополнительныеПараметры)
	
	Если ДополнительныеПараметры.КоллекцияОбъектов.Количество() <= ДополнительныеПараметры.ИндексОбъекта + 1 Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОбработчикЗавершения, Истина);
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.ИндексОбъекта = ДополнительныеПараметры.ИндексОбъекта + 1;
	Элемент = ДополнительныеПараметры.КоллекцияОбъектов[ДополнительныеПараметры.ИндексОбъекта];
	
	КоллекцияПодписей = Новый Массив;
	Для Каждого ЭлементКоллекции Из ДополнительныеПараметры.ВыделенныеСтроки Цикл
		Если ТипЗнч(ЭлементКоллекции) = Тип("Число") Тогда
			Данные = ДополнительныеПараметры.Форма.ЭлектронныеПодписи.НайтиПоИдентификатору(ЭлементКоллекции);
		Иначе
			Данные = ЭлементКоллекции;
		КонецЕсли;
		Если Данные.Объект <> Элемент Тогда
			Продолжить;
		КонецЕсли;
		КоллекцияПодписей.Добавить(ЭлементКоллекции);
	КонецЦикла;
	ДополнительныеПараметры.Вставить("Коллекция", КоллекцияПодписей);
	
	Если ТипЗнч(Элемент) = Тип("СправочникСсылка.ВерсииФайлов") Тогда
		
		СтруктураВозврата = РаботаСФайламиВызовСервера.ДанныеФайлаИДвоичныеДанные(, Элемент);
		ДвоичныеДанные = СтруктураВозврата.ДвоичныеДанные;
		
		Если СтруктураВозврата.ДанныеФайла.Зашифрован Тогда
			
			Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
				Возврат;
			КонецЕсли;
			
			ОписаниеДанных = Новый Структура;
			ОписаниеДанных.Вставить("ИдентификаторФормы",    ДополнительныеПараметры.Форма.УникальныйИдентификатор);
			ОписаниеДанных.Вставить("Операция",              НСтр("ru = 'Расшифровка файла'; en = 'Decrypting files'"));
			ОписаниеДанных.Вставить("ЗаголовокДанных",       НСтр("ru = 'Файл'; en = 'File'"));
			ОписаниеДанных.Вставить("Данные",                ДвоичныеДанные);
			ОписаниеДанных.Вставить("Представление",         СтруктураВозврата.ДанныеФайла.Ссылка);
			ОписаниеДанных.Вставить("СертификатыШифрования", СтруктураВозврата.ДанныеФайла.Ссылка);
			ОписаниеДанных.Вставить("СообщитьОЗавершении",   Ложь);
			
			ОбработчикПродолжения = Новый ОписаниеОповещения("ПроверитьПодписиОбъектаПослеРасшифровкиФайла", ЭтотОбъект, ДополнительныеПараметры);
			
			МодульЭлектроннаяПодписьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиент");
			МодульЭлектроннаяПодписьКлиент.Расшифровать(ОписаниеДанных, , ОбработчикПродолжения);
			
			Возврат;
			
		КонецЕсли;
		
	ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоДокумент(Элемент) Тогда
		
		ДвоичныеДанные = Элемент;
		
	Иначе
		
		ДвоичныеДанные = РаботаСЭП.ПолучитьДвоичныеДанныеОбъекта(Элемент);
		
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("Индекс", -1);
	
	ПроверитьПодписиОбъектаПослеПодготовкиДанных(ДвоичныеДанные, ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписиОбъекта.
Процедура ПроверитьПодписиОбъектаПослеРасшифровкиФайла(ОписаниеДанных, ДополнительныеПараметры) Экспорт
	
	Если Не ОписаниеДанных.Успех Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьПодписиОбъектаПослеПодготовкиДанных(ОписаниеДанных.РасшифрованныеДанные, ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписиОбъекта.
Процедура ПроверитьПодписиОбъектаПослеПодготовкиДанных(Данные, ДополнительныеПараметры)
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		Возврат;
	КонецЕсли;
	МодульЭлектроннаяПодписьКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиентСервер");
	
	ПроверятьЭлектронныеПодписиНаСервере = МодульЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки(
		).ПроверятьЭлектронныеПодписиНаСервере;
	
	Если Не ПроверятьЭлектронныеПодписиНаСервере Тогда
		МодульЭлектроннаяПодписьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиент");
		ДополнительныеПараметры.Вставить("Данные", Данные);
		ДополнительныеПараметры.Вставить("МодульЭлектроннаяПодписьКлиент", МодульЭлектроннаяПодписьКлиент);
		МодульЭлектроннаяПодписьКлиент.СоздатьМенеджерКриптографии(
			Новый ОписаниеОповещения("ПроверитьПодписиОбъектаПослеСозданияМенеджераКриптографии",
				ЭтотОбъект, ДополнительныеПараметры),
			"ПроверкаПодписи");
		Возврат;
	КонецЕсли;
	
	ДанныеСтрок = Новый Массив;
	
	Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Данные) Тогда
		
		Для Каждого Элемент Из ДополнительныеПараметры.Коллекция Цикл
			СтрокаПодписи = ?(ТипЗнч(Элемент) <> Тип("Число"), Элемент,
				ДополнительныеПараметры.Форма.ЭлектронныеПодписи.НайтиПоИдентификатору(Элемент));
			
			АдресДанных = РаботаСЭП.ПолучитьДвоичныеДанныеОбъекта(Данные, СтрокаПодписи.Версия);
			ДанныеСтрокНаИтерацию = Новый Массив;
			
			ДанныеСтроки = Новый Структура;
			ДанныеСтроки.Вставить("АдресПодписи", СтрокаПодписи.АдресПодписи);
			ДанныеСтроки.Вставить("Статус",       СтрокаПодписи.Статус);
			ДанныеСтроки.Вставить("ПодписьВерна", СтрокаПодписи.ПодписьВерна);
			ДанныеСтроки.Вставить("ДатаПодписи", СтрокаПодписи.ДатаПодписи);
			ДанныеСтроки.Вставить("ДатаПроверкиПодписи", СтрокаПодписи.ДатаПроверкиПодписи);
			ДанныеСтроки.Вставить("Версия", СтрокаПодписи.Версия);
			ДанныеСтрокНаИтерацию.Добавить(ДанныеСтроки);
			
			ФайловыеФункцииСлужебныйВызовСервера.ПроверитьПодписи(АдресДанных, ДанныеСтрокНаИтерацию);
			
			// Повторная проверка подписи для случаев, когда подпись была создана до включения учета по организациям.
			Если ДанныеСтроки.Версия > 1 И Не ДанныеСтрокНаИтерацию[0].ПодписьВерна Тогда
				ДополнительныеПараметрыПроверки = Новый Структура;
				ДополнительныеПараметрыПроверки.Вставить("РеквизитОрганизацияНеЗаполнен", Истина);
				АдресДанных = РаботаСЭП.ПолучитьДвоичныеДанныеОбъекта(Данные, СтрокаПодписи.Версия,
					ДополнительныеПараметрыПроверки);
				ФайловыеФункцииСлужебныйВызовСервера.ПроверитьПодписи(АдресДанных, ДанныеСтрокНаИтерацию);
			КонецЕсли;
			
			ДанныеСтрок.Добавить(ДанныеСтрокНаИтерацию[0]);
			
		КонецЦикла;
		
	Иначе
		
		Если ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда
			АдресДанных = ПоместитьВоВременноеХранилище(Данные, ДополнительныеПараметры.ИдентификаторФормы);
		Иначе
			АдресДанных = Данные;
		КонецЕсли;
		
		Для Каждого Элемент Из ДополнительныеПараметры.Коллекция Цикл
			СтрокаПодписи = ?(ТипЗнч(Элемент) <> Тип("Число"), Элемент,
				ДополнительныеПараметры.Форма.ЭлектронныеПодписи.НайтиПоИдентификатору(Элемент));
			
			ДанныеСтроки = Новый Структура;
			ДанныеСтроки.Вставить("АдресПодписи", СтрокаПодписи.АдресПодписи);
			ДанныеСтроки.Вставить("Статус",       СтрокаПодписи.Статус);
			ДанныеСтроки.Вставить("ПодписьВерна", СтрокаПодписи.ПодписьВерна);
			ДанныеСтроки.Вставить("ДатаПодписи", СтрокаПодписи.ДатаПодписи);
			ДанныеСтроки.Вставить("ДатаПроверкиПодписи", СтрокаПодписи.ДатаПроверкиПодписи);
			ДанныеСтрок.Добавить(ДанныеСтроки);
			
		КонецЦикла;
		
		ФайловыеФункцииСлужебныйВызовСервера.ПроверитьПодписи(АдресДанных, ДанныеСтрок);
		
	КонецЕсли;
	
	Индекс = 0;
	Для каждого Элемент Из ДополнительныеПараметры.Коллекция Цикл
		СтрокаПодписи = ?(ТипЗнч(Элемент) <> Тип("Число"), Элемент,
			ДополнительныеПараметры.Форма.ЭлектронныеПодписи.НайтиПоИдентификатору(Элемент));
		
		СтрокаПодписи.Статус  = ДанныеСтрок[Индекс].Статус;
		СтрокаПодписи.ПодписьВерна = ДанныеСтрок[Индекс].ПодписьВерна;
		СтрокаПодписи.ДатаПроверкиПодписи = ДанныеСтрок[Индекс].ДатаПроверкиПодписи;
		Индекс = Индекс + 1;
	КонецЦикла;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписиОбъекта.
Процедура ПроверитьПодписиОбъектаПослеСозданияМенеджераКриптографии(МенеджерКриптографии, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(МенеджерКриптографии) <> Тип("МенеджерКриптографии") Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("Индекс", -1);
	ДополнительныеПараметры.Вставить("МенеджерКриптографии", МенеджерКриптографии);
	
	ПроверитьПодписиОбъектаЦиклПодписейНачало(ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписиОбъекта.
Процедура ПроверитьПодписиОбъектаЦиклПодписейНачало(ДополнительныеПараметры)
	
	Если ДополнительныеПараметры.Коллекция.Количество() <= ДополнительныеПараметры.Индекс + 1 Тогда
		ПроверитьПодписиОбъектаЦиклОбъектовНачало(ДополнительныеПараметры);
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Индекс = ДополнительныеПараметры.Индекс + 1;
	Элемент = ДополнительныеПараметры.Коллекция[ДополнительныеПараметры.Индекс];
	
	ДополнительныеПараметры.Вставить("СтрокаПодписи", ?(ТипЗнч(Элемент) <> Тип("Число"), Элемент,
		ДополнительныеПараметры.Форма.ЭлектронныеПодписи.НайтиПоИдентификатору(Элемент)));
	
	Если ДелопроизводствоКлиентСервер.ЭтоДокумент(ДополнительныеПараметры.Данные) Тогда
		
		ДополнительныеПараметрыПроверки = Новый Структура;
		Если ДополнительныеПараметры.Свойство("РеквизитОрганизацияНеЗаполнен") Тогда
			ДополнительныеПараметрыПроверки.Вставить("РеквизитОрганизацияНеЗаполнен", Истина);
		КонецЕсли;
		
		ПроверяемыеДанные = РаботаСЭП.ПолучитьДвоичныеДанныеОбъекта(
			ДополнительныеПараметры.Данные, ДополнительныеПараметры.СтрокаПодписи.Версия,
			ДополнительныеПараметрыПроверки);
		
	Иначе
		ПроверяемыеДанные = ДополнительныеПараметры.Данные;
	КонецЕсли;
	
	МодульЭлектроннаяПодписьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиент");
	МодульЭлектроннаяПодписьКлиент.ПроверитьПодпись(
		Новый ОписаниеОповещения("ПроверитьПодписиОбъектаПослеПроверкиСтроки", ЭтотОбъект, ДополнительныеПараметры),
		ПроверяемыеДанные,
		ДополнительныеПараметры.СтрокаПодписи.АдресПодписи,
		ДополнительныеПараметры.МенеджерКриптографии);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьПодписиОбъекта.
Процедура ПроверитьПодписиОбъектаПослеПроверкиСтроки(Результат, ДополнительныеПараметры) Экспорт
	
	СтрокаПодписи = ДополнительныеПараметры.СтрокаПодписи;
	
	Если ТипЗнч(Результат) = Тип("Булево") Тогда
		СтрокаПодписи.ПодписьВерна = Результат;
		СтрокаПодписи.СертификатДействителен = Результат;
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура") Тогда
		
		// Повторная проверка подписи для случаев, когда подпись была создана до включения учета по организациям.
		Если ДелопроизводствоКлиентСервер.ЭтоДокумент(ДополнительныеПараметры.Данные)
			И ДополнительныеПараметры.СтрокаПодписи.Версия > 1
			И Результат.Свойство("ТекстОшибкиПроверкиПодписи") Тогда
			
			ДополнительныеПараметры.Индекс = ДополнительныеПараметры.Индекс - 1;
			ДополнительныеПараметры.Вставить("РеквизитОрганизацияНеЗаполнен", Истина);
			ПроверитьПодписиОбъектаЦиклПодписейНачало(ДополнительныеПараметры);
			Возврат;
		КонецЕсли;
		
		СтрокаПодписи.ПодписьВерна = Не Результат.Свойство("ТекстОшибкиПроверкиПодписи");
		СтрокаПодписи.СертификатДействителен = Не Результат.Свойство("ТекстОшибкиПроверкиСертификата");
	КонецЕсли;
	ДанныеПодписи = Новый Структура(
		"УникальныйИдентификатор,
		|Объект,
		|УстановившийПодпись,
		|ДатаПодписи,
		|ПодписьВерна,
		|ТекстОшибкиПроверкиПодписи,
		|СертификатДействителен,
		|ТекстОшибкиПроверкиСертификата");
	ЗаполнитьЗначенияСвойств(ДанныеПодписи, СтрокаПодписи);
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("ТекстОшибкиПроверкиПодписи") Тогда
		ДанныеПодписи.ТекстОшибкиПроверкиПодписи = Результат.ТекстОшибкиПроверкиПодписи;
	Иначе
		ДанныеПодписи.ТекстОшибкиПроверкиПодписи = "";
	КонецЕсли;
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("ТекстОшибкиПроверкиСертификата") Тогда
		ДанныеПодписи.ТекстОшибкиПроверкиСертификата = Результат.ТекстОшибкиПроверкиСертификата;
	Иначе
		ДанныеПодписи.ТекстОшибкиПроверкиСертификата = "";
	КонецЕсли;
	РаботаСЭП.ОбновитьСтатусПроверкиПодписи(ДанныеПодписи, СтрокаПодписи.ДатаПроверкиПодписи, СтрокаПодписи.Статус);
	
	ПроверитьПодписиОбъектаЦиклПодписейНачало(ДополнительныеПараметры);
	
КонецПроцедуры

// Открывает форму просмотра ЭП.
//
Процедура ОткрытьПодпись(ТекущиеДанные, УникальныйИдентификатор) Экспорт
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентПовтИсп.ЭтоВебКлиентПодMacOS() Тогда
		Возврат;
	КонецЕсли;
	
	РасширениеПодключеноФайл = ПодключитьРасширениеРаботыСФайлами();
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Объект) И 
		ЗначениеЗаполнено(ТекущиеДанные.ДатаПодписи) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ДатаПодписи", ТекущиеДанные.ДатаПодписи);
		ПараметрыФормы.Вставить("Объект", ТекущиеДанные.Объект);
		ПараметрыФормы.Вставить("УстановившийПодпись", ТекущиеДанные.УстановившийПодпись);
		ПараметрыФормы.Вставить("УникальныйИдентификатор", ТекущиеДанные.УникальныйИдентификатор);
		ПараметрыФормы.Вставить("ПодписьПроверена", ЗначениеЗаполнено(ТекущиеДанные.ДатаПроверкиПодписи));
		ПараметрыФормы.Вставить("ПодписьВерна", ТекущиеДанные.ПодписьВерна);
		ПараметрыФормы.Вставить("СертификатДействителен", ТекущиеДанные.СертификатДействителен);
		Попытка
			ОткрытьФорму("РегистрСведений.ЭлектронныеПодписи.ФормаЗаписи", ПараметрыФормы,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
			ПоказатьПредупреждение(Неопределено, ТекстОшибки);
		КонецПопытки;
		
	Иначе
		
		Если ТипЗнч(ТекущиеДанные) = Тип("ДанныеФормыЭлементДерева") Тогда
			ДочерниеЭлементы = ТекущиеДанные.ПолучитьЭлементы();
			Если ДочерниеЭлементы.Количество() > 0 Тогда
				Версия = ДочерниеЭлементы[0].Объект;
				Если ЗначениеЗаполнено(Версия) И ТипЗнч(Версия) = Тип("СправочникСсылка.ВерсииФайлов") Тогда
					ФайлСсылка = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Версия, "Владелец");
					ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
						ФайлСсылка,
						Неопределено,
						УникальныйИдентификатор);
					РаботаСФайламиКлиент.Открыть(ДанныеФайла, УникальныйИдентификатор); 
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура Подписать(Данные, ИдентификаторФормы, ОбработчикЗавершения, Заголовки = Неопределено) Экспорт
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Данные) = Тип("Массив") Тогда
		МассивОбъектов = Данные;
	Иначе
		МассивОбъектов = Новый Массив;
		МассивОбъектов.Добавить(Данные);
	КонецЕсли;
	
	НаборДанных = Новый Массив;
	МассивДанныхОбъектов = Новый Массив;
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	ПараметрыВыполнения.Вставить("ИдентификаторФормы", ИдентификаторФормы);
	ПараметрыВыполнения.Вставить("МассивДанныхОбъектов", МассивДанныхОбъектов);
	
	Для Каждого Объект Из МассивОбъектов Цикл
		
		// У документов сперва подписываем не помеченные на удаление файлы.
		Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект) Тогда
			
			МассивПодчиненныхФайлов = РаботаСФайламиВызовСервера.ПолучитьВсеПодчиненныеФайлы(Объект, Ложь);
			
			Для Каждого Файл Из МассивПодчиненныхФайлов Цикл
				
				МассивДанныхОбъектов.Добавить(Файл);
				
				ТекущиеПараметрыВыполнения = Новый Структура;
				ТекущиеПараметрыВыполнения.Вставить("ИдентификаторФормы", ИдентификаторФормы);
				ТекущиеПараметрыВыполнения.Вставить("ПодписываемыеДанные", Файл);
				
				ЭлементДанных = Новый Структура;
				ЭлементДанных.Вставить("Представление", Файл);
				ЭлементДанных.Вставить("Данные",
					Новый ОписаниеОповещения("ПриЗапросеДвоичныхДанныхОбъекта", ЭтотОбъект, ТекущиеПараметрыВыполнения));
				ЭлементДанных.Вставить("Объект",
					Новый ОписаниеОповещения("ПриПолученииПодписи", ЭтотОбъект, ТекущиеПараметрыВыполнения));
				НаборДанных.Добавить(ЭлементДанных);
				
			КонецЦикла;
			
		КонецЕсли;
		
		МассивДанныхОбъектов.Добавить(Объект);
		
		ТекущиеПараметрыВыполнения = Новый Структура;
		ТекущиеПараметрыВыполнения.Вставить("ИдентификаторФормы", ИдентификаторФормы);
		ТекущиеПараметрыВыполнения.Вставить("ПодписываемыеДанные", Объект);
		
		ЭлементДанных = Новый Структура;
		ЭлементДанных.Вставить("Представление", Объект);
		ЭлементДанных.Вставить("Данные",
			Новый ОписаниеОповещения("ПриЗапросеДвоичныхДанныхОбъекта", ЭтотОбъект, ТекущиеПараметрыВыполнения));
		ЭлементДанных.Вставить("Объект",
			Новый ОписаниеОповещения("ПриПолученииПодписи", ЭтотОбъект, ТекущиеПараметрыВыполнения));
		НаборДанных.Добавить(ЭлементДанных);
		
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(Заголовки)
		Или ТипЗнч(Заголовки) <> Тип("Структура") Тогда
		
		Заголовки = Новый Структура;
	КонецЕсли;
	
	Если Заголовки.Свойство("Операция") Тогда
		Операция = Заголовки.Операция;
	Иначе
		Операция = НСтр("ru = 'Подписание'; en = 'Signing'");
		Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Данные) Тогда
			Операция = НСтр("ru = 'Подписание документа'; en = 'Signing document'");
		ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоВизаСогласования(Данные) Тогда
			Операция = НСтр("ru = 'Подписание визы согласования'; en = 'Endorsement singing'");
		ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоРезолюция(Данные) Тогда
			Операция = НСтр("ru = 'Подписание резолюции'; en = 'Resolution signing'");
		КонецЕсли;
	КонецЕсли;
	
	Если Заголовки.Свойство("ЗаголовокДанных") Тогда
		ЗаголовокДанных = Заголовки.ЗаголовокДанных;
	Иначе
		ЗаголовокДанных = НСтр("ru = 'Объект'; en = 'Object'");
		Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Данные) Тогда
			ЗаголовокДанных = НСтр("ru = 'Документ'; en = 'Document'");
		ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоВизаСогласования(Данные) Тогда
			ЗаголовокДанных = НСтр("ru = 'Виза согласования'; en = 'Endorsement of approval'");
		ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоРезолюция(Данные) Тогда
			ЗаголовокДанных = НСтр("ru = 'Резолюция'; en = 'Resolution'");
		КонецЕсли;
	КонецЕсли;
	
	Если Заголовки.Свойство("ЗаголовокДанных") Тогда
		ПредставлениеНабора = Заголовки.ЗаголовокДанных;
	Иначе
		ПредставлениеНабора = НСтр("ru = 'Объекты (%1)'; en = 'Objects (%1)'");
		// Выводим название документа, так как при подписании документа будут также подписаны его файлы.
		Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Данные) Тогда
			ПредставлениеНабора = Строка(Данные);
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеДанных = Новый Структура;
	ОписаниеДанных.Вставить("ПоказатьКомментарий", Истина);
	ОписаниеДанных.Вставить("ИдентификаторФормы",  ИдентификаторФормы);
	ОписаниеДанных.Вставить("Операция",            Операция);
	ОписаниеДанных.Вставить("ЗаголовокДанных",     ЗаголовокДанных);
	ОписаниеДанных.Вставить("НаборДанных",         НаборДанных);
	ОписаниеДанных.Вставить("ПредставлениеНабора", ПредставлениеНабора);
	
	ОбработчикПродолжения = Новый ОписаниеОповещения("ПослеПодписанияОбъектов", ЭтотОбъект, ПараметрыВыполнения);
	
	МодульЭлектроннаяПодписьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиент");
	МодульЭлектроннаяПодписьКлиент.Подписать(ОписаниеДанных, , ОбработчикПродолжения);
	
КонецПроцедуры

// Продолжение процедуры ПодписатьОбъект.
// Вызывается из подсистемы ЭлектроннаяПодпись при запросе данных для подписания.
//
Процедура ПриЗапросеДвоичныхДанныхОбъекта(Параметры, Контекст) Экспорт
	
	Если ДелопроизводствоКлиентСервер.ЭтоФайл(Контекст.ПодписываемыеДанные) Тогда
		
		Данные = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаИДвоичныеДанные(
			Контекст.ПодписываемыеДанные).ДвоичныеДанные;
		
	Иначе
		
		Данные = РаботаСЭП.ПолучитьДвоичныеДанныеОбъекта(Контекст.ПодписываемыеДанные);
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.Оповещение, Новый Структура("Данные", Данные));
	
КонецПроцедуры

// Продолжение процедуры ПодписатьОбъект.
// Вызывается из подсистемы ЭлектроннаяПодпись после подписания данных для нестандартного
// способа добавления подписи в объект.
//
Процедура ПриПолученииПодписи(Параметры, Контекст) Экспорт
	
	ВыполнитьОбработкуОповещения(Параметры.Оповещение, Новый Структура);
	
КонецПроцедуры

// Завершение процедуры ПодписатьОбъект.
Процедура ПослеПодписанияОбъектов(ОписаниеДанных, ПараметрыВыполнения) Экспорт
	
	Если Не ОписаниеДанных.Успех Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.ВернутьРезультат(ПараметрыВыполнения.ОбработчикЗавершения, ОписаниеДанных);
	
КонецПроцедуры

Процедура ПослеПодписанияОбъекта(ОписаниеДанных, ПараметрыВыполнения) Экспорт
	
	Если Не ОписаниеДанных.Успех Тогда
		Возврат;
	КонецЕсли;
		
	ПодписанныеДанные = Новый Массив;
	Для Каждого Данные Из ОписаниеДанных.НаборДанных Цикл
		Если Не Данные.Свойство("СвойстваПодписи") Тогда
			Возврат;
		КонецЕсли;
		Элемент = Новый Структура;
		Элемент.Вставить("ПодписанныйОбъект", Данные.Представление);
		Элемент.Вставить("СвойстваПодписи", Данные.СвойстваПодписи);
		Элемент.Вставить("ПараметрыВыполнения", ПараметрыВыполнения);
		ПодписанныеДанные.Добавить(Элемент);
	КонецЦикла;
	
	РаботаСЭП.ЗанестиИнформациюОПодписях(ПодписанныеДанные, ОписаниеДанных.ИдентификаторФормы);
	ИнформироватьОПодписании(ОписаниеДанных.НаборДанных, ПараметрыВыполнения.Объект);
	
КонецПроцедуры

// По окончании подписания нотифицирует.
//
Процедура ИнформироватьОПодписании(ПодписанныеДанные, Объект) Экспорт
	
	Для Каждого Данные Из ПодписанныеДанные Цикл
		ДелопроизводствоКлиент.ОповеститьОбИзмененииОбъекта(Данные.Представление);
	КонецЦикла;
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Установлена подпись для ""%1""'; en = 'Assigned signature for ""%1""'"),
		Объект);
	Состояние(ТекстСообщения);
	
КонецПроцедуры

// Преобразует 2-уровневое дерево в массив.
//
Функция ПолучитьМассивДанныхПодписей(ТаблицаПодписей) Экспорт
	
	ДанныеСтрок = Новый Массив;
	
	ЭлементыПервогоУровня = ТаблицаПодписей.ПолучитьЭлементы();
	
	Для Каждого СтрокаУровняОдин Из ЭлементыПервогоУровня Цикл
		ЭлементыВторогоУровня = СтрокаУровняОдин.ПолучитьЭлементы();
		
		Для Каждого Строка Из ЭлементыВторогоУровня Цикл
			ДанныеСтрок.Добавить(Строка);
		КонецЦикла;
	КонецЦикла;
	
	Возврат ДанныеСтрок;
	
КонецФункции

#КонецОбласти

#Область РаботаСФайлами

// Есть ли шифрованные файлы среди выделенных.
//
Функция ЕстьШифрованныеФайлы(ВыделенныеСтроки, ТаблицаПодписей) Экспорт
	
	Для Каждого Элемент Из ВыделенныеСтроки Цикл
		ДанныеСтроки = ТаблицаПодписей.НайтиПоИдентификатору(Элемент);
		
		Если ДанныеСтроки.Объект <> Неопределено И (НЕ ДанныеСтроки.Объект.Пустая()) Тогда
			Если ДанныеСтроки.Зашифрован Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Проверяет есть ли шифрованные файлы.
//
Функция ЕстьШифрованныеФайлыСредиВсехПодписей(ТаблицаПодписей) Экспорт
	
	ДанныеСтрок = ПолучитьМассивДанныхПодписей(ТаблицаПодписей);
	Для Каждого Строка Из ДанныеСтрок Цикл
		Если Строка.Зашифрован Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Показывает текст и вызывает обработчик с заданным результатом.
//
Процедура ВернутьРезультатПослеПоказаПредупреждения(ОбработчикРезультата, ТекстПредупреждения, Результат) Экспорт
	Если ТипЗнч(ОбработчикРезультата) = Тип("ОписаниеОповещения") Тогда
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("ОбработчикРезультата", ОбработчикРезультата);
		ПараметрыОбработчика.Вставить("Результат",             Результат);
		Обработчик = Новый ОписаниеОповещения("ВернутьРезультатПослеЗакрытияПростогоДиалога", ЭтотОбъект, ПараметрыОбработчика);
		ПоказатьПредупреждение(Обработчик, ТекстПредупреждения);
	Иначе
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
КонецПроцедуры

// Обработчик результата работы процедуры ВернутьРезультатПослеПоказаПредупреждения.
//
Процедура ВернутьРезультатПослеЗакрытияПростогоДиалога(Структура) Экспорт
	ВыполнитьОбработкуОповещения(Структура.ОбработчикРезультата, Структура.Результат);
КонецПроцедуры

// Показывает стандартное предупреждение.
//
// Параметры:
//  ОбработчикРезультата - ОписаниеОповещения, Неопределено - Описание процедуры, принимающей результат работы метода.
//  ПредставлениеКоманды - Строка - Необязательный. Имя команды, для выполнения которой необходимо расширение.
//
Процедура ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСКриптографией(
	ОбработчикРезультата = Неопределено, ПредставлениеКоманды = "") Экспорт
	
	ТекстПредупреждения = НСтр("ru = 'Для выполнения команды ""%1"" необходимо
	                                 |установить расширение работы с криптографией.';
	                                 |en = 'To execute command ""%1"" the extension for working
	                                 |with cryptography must be installed.'");
	Если ЗначениеЗаполнено(ПредставлениеКоманды) Тогда
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", ПредставлениеКоманды);
	Иначе
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, " ""%1""", "");
	КонецЕсли;
	ВернутьРезультатПослеПоказаПредупреждения(ОбработчикРезультата, ТекстПредупреждения, Неопределено);
	
КонецПроцедуры

#КонецОбласти
