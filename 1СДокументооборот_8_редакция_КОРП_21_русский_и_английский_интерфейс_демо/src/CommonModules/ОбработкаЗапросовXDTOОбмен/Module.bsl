////////////////////////////////////////////////////////////////////////////////
// Обработка запросов XDTO, обмен
// Реализует функционал веб-сервиса DMService по обмену данными
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает и заполняет сообщения обмена для интегрированных систем
//
Процедура ФормированиеСообщений() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	УзлыОбмена = ОбработкаЗапросовXDTOПовтИсп.ПолучитьУзлыОбменаИнтегрированныхСистем();
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюСИнтегрированнымиСистемами") Тогда
		Для каждого ИнтегрированнаяСистема Из УзлыОбмена Цикл
			ПланыОбмена.УдалитьРегистрациюИзменений(ИнтегрированнаяСистема);
		КонецЦикла; 
		Возврат;
	КонецЕсли; 
	
	Для каждого ИнтегрированнаяСистема Из УзлыОбмена Цикл
		Сообщение = СоздатьНовоеСообщение(ИнтегрированнаяСистема);
		СформироватьПакетОбмена(Сообщение, ИнтегрированнаяСистема);
	КонецЦикла; 
	
КонецПроцедуры

// Возвращает в ответ на запрос DMGetChangesRequest измененные объекты
//
// Параметры:
//   Сообщение - ОбъектXDTO типа DMGetChangesRequest
//
// Возвращаемое значение:
//   ОбъектXDTO типа DMGetChangesResponse
//
Функция ПолучитьИзменения(Сообщение) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюСИнтегрированнымиСистемами") = Ложь Тогда 
	    Константы.ИспользоватьСинхронизациюСИнтегрированнымиСистемами.Установить(Истина);
	КонецЕсли; 
	
	Ответ = ОбработкаЗапросовXDTO.СоздатьОбъект("DMGetChangesResponse");
	Узел =  ОбработкаЗапросовXDTO.УзелИнтегрированнойСистемы(Сообщение);
	
	ИдентификаторПринятогоСообщения = Сообщение.lastMessageId;
	
	Если ИдентификаторПринятогоСообщения <> Неопределено Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	СообщенияИнтегрированныхСистем.Ссылка
			|ИЗ
			|	Справочник.СообщенияИнтегрированныхСистем КАК СообщенияИнтегрированныхСистем
			|ГДЕ
			|	СообщенияИнтегрированныхСистем.ПометкаУдаления = ЛОЖЬ
			|	И СообщенияИнтегрированныхСистем.ИдентификаторСообщения = &ИдентификаторСообщения
			|	И СообщенияИнтегрированныхСистем.Входящее = ЛОЖЬ";
		Запрос.УстановитьПараметр("ИдентификаторСообщения", Строка(ИдентификаторПринятогоСообщения));
		ВыборкаПринятыеСообщения = Запрос.Выполнить().Выбрать();
		Если ВыборкаПринятыеСообщения.Следующий() Тогда
			ПринятоеСообщение = ВыборкаПринятыеСообщения.Ссылка;
			ПринятоеСообщениеОбъект = ПринятоеСообщение.ПолучитьОбъект();
			ПринятоеСообщениеОбъект.УстановитьПометкуУдаления(Истина);
			РегистрыСведений.СведенияОСообщенияхОбменаСИнтегрированнымиСистемами.ЗаписатьДатуПередачиКлиенту(
				ПринятоеСообщение,
				ТекущаяДатаСеанса());
			ИдентификаторПринятогоСообщения = Неопределено;
		Иначе
			ИдентификаторПринятогоСообщения = Неопределено;
		КонецЕсли;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СообщенияИнтегрированныхСистем.Ссылка,
		|	СообщенияИнтегрированныхСистем.ДанныеСообщения КАК Данные,
		|	СообщенияИнтегрированныхСистем.ДатаСоздания КАК ДатаСоздания,
		|	СообщенияИнтегрированныхСистем.ИдентификаторСообщения
		|ИЗ
		|	Справочник.СообщенияИнтегрированныхСистем КАК СообщенияИнтегрированныхСистем
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ОчередиСообщенийОбменаСИнтегрированнымиСистемами КАК ОчередиСообщенийОбменаСИнтегрированнымиСистемами
		|ПО
		|	СообщенияИнтегрированныхСистем.Очередь = ОчередиСообщенийОбменаСИнтегрированнымиСистемами.Очередь
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	РегистрСведений.СтепеньГотовностиСообщенийИнтегрированныхСистем КАК СтепеньГотовностиСообщенийИнтегрированныхСистем
		|ПО
		|	СообщенияИнтегрированныхСистем.Ссылка = СтепеньГотовностиСообщенийИнтегрированныхСистем.Сообщение
		|ГДЕ
		|	ОчередиСообщенийОбменаСИнтегрированнымиСистемами.ИнтегрированнаяСистема = &ИнтегрированнаяСистема
		|	И НЕ СообщенияИнтегрированныхСистем.ПометкаУдаления
		|	И СтепеньГотовностиСообщенийИнтегрированныхСистем.ПроцентГотовности = 100
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаСоздания";
	Запрос.УстановитьПараметр("ИнтегрированнаяСистема", Узел);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ИмяФайлаСообщенияОбмена = ПолучитьИмяВременногоФайла("xml");
		ДвоичныеДанные = Выборка.Данные.Получить();
		ДвоичныеДанные.Записать(ИмяФайлаСообщенияОбмена);
		СсылочныйТип = ФабрикаXDTO.Тип("http://www.1c.ru/dm", "DMObject");
			
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ИмяФайлаСообщенияОбмена);
		
		ЧтениеXML.Прочитать(); // корневой элемент "Message"
		
		ЧтениеXML.Прочитать();
		Пока ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Цикл
			ТипXDTO = ФабрикаXDTO.Тип("http://www.1c.ru/dm", ЧтениеXML.Имя);
			ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипXDTO);
			Если СсылочныйТип.ЭтоПотомок(ТипXDTO) Тогда
				Ответ.objects.Добавить(ОбъектXDTO);
			Иначе // записи РС и тому подобные объекты не ссылочных типов
				Ответ.records.Добавить(ОбъектXDTO);
			КонецЕсли;
		КонецЦикла;
			
		Ответ.messageId = Строка(Выборка.ИдентификаторСообщения);
		
	КонецЕсли; 
	
	Возврат Ответ;
	
КонецФункции

// Помещает изменения в базу и возвращает ответ на запрос DMPutChangesRequest
//
// Параметры:
//   Сообщение - ОбъектXDTO типа DMPutChangesRequest
//
// Возвращаемое значение:
//   ОбъектXDTO типа DMPutChangesResponse
//
Функция ЗаписатьИзмененияОбъектов(Сообщение) Экспорт
	
	Ответ = ОбработкаЗапросовXDTO.СоздатьОбъект("DMPutChangesResponse");
	Ответ.dataBaseId = Сообщение.dataBaseId;
	Узел =  ОбработкаЗапросовXDTO.УзелИнтегрированнойСистемы(Сообщение);
	
	Для Каждого Объект Из Сообщение.objects Цикл
		
			
		Если  ОбработкаЗапросовXDTO.ПроверитьТип(Объект, "DMIncomingDocument") Тогда
			Объект = ОбработкаЗапросовXDTOДокументы.ИзменитьВходящийДокумент(Узел, Объект, Истина);
			
		ИначеЕсли  ОбработкаЗапросовXDTO.ПроверитьТип(Объект, "DMOutgoingDocument") Тогда
			Объект = ОбработкаЗапросовXDTOДокументы.ИзменитьИсходящийДокумент(Узел, Объект, Истина);
			
		ИначеЕсли  ОбработкаЗапросовXDTO.ПроверитьТип(Объект, "DMInternalDocument") Тогда
			Объект = ОбработкаЗапросовXDTOДокументы.ИзменитьВнутреннийДокумент(Узел, Объект, Истина);
			
		ИначеЕсли  ОбработкаЗапросовXDTO.ПроверитьТип(Объект, "DMCorrespondent") Тогда
			Объект = ОбработкаЗапросовXDTOДокументы.ИзменитьКонтрагента(Узел, Объект, Истина);
			
		КонецЕсли;
		
		Если ТипЗнч(Объект) = Тип("ОбъектXDTO")
			И ОбработкаЗапросовXDTO.ПроверитьТип(Объект, "DMError") Тогда 
			Возврат Объект;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ответ;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий изменения данных

// Вызывается перед записью ссылочного объекта и регистрирует его на нужных узлах.
//
Процедура ОбменСИнтегрированнымиСистемамиПередЗаписью(Источник, Отказ) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюСИнтегрированнымиСистемами")
		Или Источник.ДополнительныеСвойства.Свойство("ОтключитьРегистрациюДляОбменаСИнтегрированнымиСистемами") Тогда
		Возврат;
	КонецЕсли;
	
	ЗарегистрироватьОбъект(Источник);
	
КонецПроцедуры

// Вызывается перед записью набора записей регистра и регистрирует его данные при необходимости.
//
Процедура ОбменСИнтегрированнымиСистемамиПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюСИнтегрированнымиСистемами")
		Или Источник.ДополнительныеСвойства.Свойство("ОтключитьРегистрациюДляОбменаСИнтегрированнымиСистемами") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.ТекущиеСостоянияДокументов") Тогда
	
		СостоянияСогласования = Новый Массив;
		СостоянияСогласования.Добавить(Перечисления.СостоянияДокументов.НаСогласовании);
		СостоянияСогласования.Добавить(Перечисления.СостоянияДокументов.Согласован);
		СостоянияСогласования.Добавить(Перечисления.СостоянияДокументов.НеСогласован);
		
		Для Каждого Запись Из Источник Цикл
			Узлы = ЗарегистрироватьСсылку(Запись.Документ);
			Если Узлы.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			ПланыОбмена.ЗарегистрироватьИзменения(Узлы, Запись.Документ);
			Если СостоянияСогласования.Найти(Запись.Состояние) <> Неопределено Тогда
				НаборЗаписей = РегистрыСведений.ТекущиеСостоянияДокументов.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Документ.Установить(Запись.Документ);
				НаборЗаписей.Отбор.Состояние.Установить(Запись.Состояние);
				ПланыОбмена.ЗарегистрироватьИзменения(Узлы, НаборЗаписей);
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.СведенияОФайлах") Тогда
		
		Для Каждого Запись Из Источник Цикл
			ЗарегистрироватьСсылку(Запись.Файл);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед удалением ссылочного объекта и регистрирует его на нужных узлах.
//
Процедура ОбменСИнтегрированнымиСистемамиПередУдалением(Источник, Отказ) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюСИнтегрированнымиСистемами")
		Или Источник.ДополнительныеСвойства.Свойство("ОтключитьРегистрациюДляОбменаСИнтегрированнымиСистемами") Тогда
		Возврат;
	КонецЕсли;
	
	ЗарегистрироватьОбъект(Источник, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает данные, зарегистрированные для передачи по узлу обмена.
//
// Параметры:
//   УзелОбмена - ПланОбменаСсылка.ИнтегрированныеСистемы - узел-получатель.
//
// Возвращаемое значение:
//   Массив, содержащий ссылки на измененные объекты или измененные наборы записей. Наборы прочитаны.
//
Функция ПолучитьДанныеДляПередачи(УзелОбмена)
	
	УстановитьПривилегированныйРежим(Истина);
	МассивДанных = Новый Массив;
	Для Каждого ЭлементСоставаПланаОбмена Из УзелОбмена.Метаданные().Состав Цикл
		ЗапросИзменения = Новый Запрос;
		ИмяМетаданныхЭлемента = ЭлементСоставаПланаОбмена.Метаданные.Имя;
		ПолноеИмяМетаданныхЭлемента = ЭлементСоставаПланаОбмена.Метаданные.ПолноеИмя();
		Если ИмяМетаданныхЭлемента = "ТекущиеСостоянияДокументов" Тогда
			
			ТекстЗапроса = 
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	РегистрИзменения.Документ
				|ПОМЕСТИТЬ
				|	Документы
				|ИЗ
				|	РегистрСведений.ТекущиеСостоянияДокументов.Изменения КАК РегистрИзменения
				|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
				|	РегистрСведений.СвязиОбъектовИнтегрированныхСистем КАК СвязиОбъектовИнтегрированныхСистем
				|ПО
				|	СвязиОбъектовИнтегрированныхСистем.УзелИнтегрированнойСистемы = &Узел
				|	И СвязиОбъектовИнтегрированныхСистем.СсылкаНаОбъектДО = РегистрИзменения.Документ
				|ГДЕ
				|	РегистрИзменения.Узел = &Узел
				|	И РегистрИзменения.Состояние В (&СостоянияСогласования)
				|
				|; /////////////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	Документы.Документ,
				|	МАКСИМУМ(ЕСТЬNULL(Состояния.Состояние, Неопределено)) КАК Состояние,
				|	МАКСИМУМ(ЕСТЬNULL(Состояния.Установил, Неопределено)) КАК Установил,
				|	МАКСИМУМ(ЕСТЬNULL(Состояния.ДатаУстановки, Неопределено)) КАК ДатаУстановки
				|ПОМЕСТИТЬ
				|	СостоянияДокументов
				|ИЗ
				|	Документы
				|ЛЕВОЕ СОЕДИНЕНИЕ
				|	РегистрСведений.ТекущиеСостоянияДокументов КАК Состояния
				|ПО
				|	Документы.Документ = Состояния.Документ
				|	И Состояния.Состояние В (&СостоянияСогласования)
				|СГРУППИРОВАТЬ ПО
				|	Документы.Документ
				|
				|; /////////////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВизыСогласования.Источник.БизнесПроцесс КАК БизнесПроцесс,
				|	МАКСИМУМ(ДатаИсполнения) КАК ДатаИсполнения
				|ПОМЕСТИТЬ
				|	ДатыВизСогласовано
				|ИЗ
				|	Справочник.ВизыСогласования КАК ВизыСогласования
				|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
				|	СостоянияДокументов
				|ПО
				|	ВизыСогласования.Источник.БизнесПроцесс = СостоянияДокументов.Установил
				|	И СостоянияДокументов.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.Согласован)
				|ГДЕ
				|	НЕ ВизыСогласования.Удалена
				|	И НЕ ВизыСогласования.ПометкаУдаления
				|	И ВизыСогласования.РезультатСогласования В (
				|		ЗНАЧЕНИЕ(Перечисление.РезультатыСогласования.Согласовано),
				|		ЗНАЧЕНИЕ(Перечисление.РезультатыСогласования.СогласованоСЗамечаниями)
				|	)
				|СГРУППИРОВАТЬ ПО
				|	ВизыСогласования.Источник.БизнесПроцесс
				|
				|; /////////////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВизыСогласования.Источник.БизнесПроцесс КАК БизнесПроцесс,
				|	МАКСИМУМ(ВизыСогласования.УстановилРезультат) КАК Установил
				|ПОМЕСТИТЬ
				|	ВизыСогласовано
				|ИЗ
				|	Справочник.ВизыСогласования КАК ВизыСогласования
				|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
				|	ДатыВизСогласовано
				|ПО
				|	ВизыСогласования.Источник.БизнесПроцесс = ДатыВизСогласовано.БизнесПроцесс
				|	И ВизыСогласования.ДатаИсполнения = ДатыВизСогласовано.ДатаИсполнения
				|ГДЕ
				|	НЕ ВизыСогласования.Удалена
				|	И НЕ ВизыСогласования.ПометкаУдаления
				|	И ВизыСогласования.РезультатСогласования В (
				|		ЗНАЧЕНИЕ(Перечисление.РезультатыСогласования.Согласовано),
				|		ЗНАЧЕНИЕ(Перечисление.РезультатыСогласования.СогласованоСЗамечаниями)
				|	)
				|СГРУППИРОВАТЬ ПО
				|	ВизыСогласования.Источник.БизнесПроцесс
				|
				|; /////////////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВизыСогласования.Источник.БизнесПроцесс КАК БизнесПроцесс,
				|	МАКСИМУМ(ДатаИсполнения) КАК ДатаИсполнения
				|ПОМЕСТИТЬ
				|	ДатыВизНеСогласовано
				|ИЗ
				|	Справочник.ВизыСогласования КАК ВизыСогласования
				|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
				|	СостоянияДокументов
				|ПО
				|	ВизыСогласования.Источник.БизнесПроцесс = СостоянияДокументов.Установил
				|	И СостоянияДокументов.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.НеСогласован)
				|ГДЕ
				|	НЕ ВизыСогласования.Удалена
				|	И НЕ ВизыСогласования.ПометкаУдаления
				|	И ВизыСогласования.РезультатСогласования =
				|		ЗНАЧЕНИЕ(Перечисление.РезультатыСогласования.НеСогласовано)
				|СГРУППИРОВАТЬ ПО
				|	ВизыСогласования.Источник.БизнесПроцесс
				|
				|; /////////////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВизыСогласования.Источник.БизнесПроцесс КАК БизнесПроцесс,
				|	МАКСИМУМ(ВизыСогласования.УстановилРезультат) КАК Установил
				|ПОМЕСТИТЬ
				|	ВизыНеСогласовано
				|ИЗ
				|	Справочник.ВизыСогласования КАК ВизыСогласования
				|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
				|	ДатыВизНеСогласовано
				|ПО
				|	ВизыСогласования.Источник.БизнесПроцесс = ДатыВизНеСогласовано.БизнесПроцесс
				|	И ВизыСогласования.ДатаИсполнения = ДатыВизНеСогласовано.ДатаИсполнения
				|ГДЕ
				|	НЕ ВизыСогласования.Удалена
				|	И НЕ ВизыСогласования.ПометкаУдаления
				|	И ВизыСогласования.РезультатСогласования =
				|		ЗНАЧЕНИЕ(Перечисление.РезультатыСогласования.НеСогласовано)
				|СГРУППИРОВАТЬ ПО
				|	ВизыСогласования.Источник.БизнесПроцесс
				|
				|; /////////////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	СостоянияДокументов.Документ,
				|	СостоянияДокументов.Состояние,
				|	ВЫБОР КОГДА СостоянияДокументов.Установил ССЫЛКА Справочник.Пользователи
				|		ТОГДА СостоянияДокументов.Установил
				|		ИНАЧЕ ВЫБОР КОГДА СостоянияДокументов.Состояние 
				|			= ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.НеСогласован)
				|			ТОГДА ВизыНеСогласовано.Установил
				|			ИНАЧЕ ВизыСогласовано.Установил
				|		КОНЕЦ
				|	КОНЕЦ КАК Установил,
				|	СостоянияДокументов.ДатаУстановки
				|ИЗ
				|	СостоянияДокументов
				|ЛЕВОЕ СОЕДИНЕНИЕ
				|	ВизыСогласовано
				|ПО
				|	СостоянияДокументов.Установил = ВизыСогласовано.БизнесПроцесс
				|ЛЕВОЕ СОЕДИНЕНИЕ
				|	ВизыНеСогласовано
				|ПО
				|	СостоянияДокументов.Установил = ВизыНеСогласовано.БизнесПроцесс
				|		
				|";
			ЗапросИзменения.Текст = ТекстЗапроса;
			ЗапросИзменения.УстановитьПараметр("Узел", УзелОбмена);
			СостоянияСогласования = Новый Массив;
			СостоянияСогласования.Добавить(Перечисления.СостоянияДокументов.НаСогласовании);
			СостоянияСогласования.Добавить(Перечисления.СостоянияДокументов.Согласован);
			СостоянияСогласования.Добавить(Перечисления.СостоянияДокументов.НеСогласован);
			ЗапросИзменения.УстановитьПараметр("СостоянияСогласования", СостоянияСогласования);
			
			Выборка = ЗапросИзменения.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				СтруктураЗаписи = Новый Структура;
				СтруктураЗаписи.Вставить("Документ", Выборка.Документ);
				СтруктураЗаписи.Вставить("Состояние", Выборка.Состояние);
				СтруктураЗаписи.Вставить("Установил", Выборка.Установил);
				СтруктураЗаписи.Вставить("ДатаУстановки", Выборка.ДатаУстановки);
				МассивДанных.Добавить(СтруктураЗаписи);
			КонецЦикла;
				
		Иначе // ссылочный тип
			
			ВыбиратьТолькоСвязанныеОбъекты = 
				ИмяМетаданныхЭлемента <> "ШаблоныВнутреннихДокументов"
				И ИмяМетаданныхЭлемента <> "ШаблоныВходящихДокументов"
				И ИмяМетаданныхЭлемента <> "ШаблоныИсходящихДокументов";
				
			ТекстЗапроса = 
				"ВЫБРАТЬ
				|	ТаблицаИзменения.Ссылка
				|ИЗ
				|	%1.Изменения КАК ТаблицаИзменения";
			Если ВыбиратьТолькоСвязанныеОбъекты Тогда
				ТекстЗапроса = ТекстЗапроса + "
					|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
					|	РегистрСведений.СвязиОбъектовИнтегрированныхСистем КАК СвязиОбъектовИнтегрированныхСистем
					|ПО
					|	СвязиОбъектовИнтегрированныхСистем.УзелИнтегрированнойСистемы = &Узел
					|	И СвязиОбъектовИнтегрированныхСистем.СсылкаНаОбъектДО = ТаблицаИзменения.Ссылка";
			КонецЕсли;
			ТекстЗапроса = ТекстЗапроса + "
				|ГДЕ
				|	ТаблицаИзменения.Узел = &Узел
				|";
				
			ЗапросИзменения.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстЗапроса,
				ПолноеИмяМетаданныхЭлемента);
			ЗапросИзменения.УстановитьПараметр("Узел", УзелОбмена);
			
			РезультатЗапроса = ЗапросИзменения.Выполнить();
			Если Не РезультатЗапроса.Пустой() Тогда
				Выборка = РезультатЗапроса.Выбрать();
				Пока Выборка.Следующий() Цикл
					МассивДанных.Добавить(Выборка.Ссылка); 
				КонецЦикла;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивДанных;
	
КонецФункции

// Создание нового сообщения интегрированных систем и помещение его в очередь.
// У сообщения устанавливается признак того, что оно находится в стадии подготовки (процент готовности = 0).
//
// Параметры:
//	 ИнтегрированнаяСистема - ПланОбменаСсылка.ИнтегрированныеСистемы - узел-получатель
//
// Возвращаемое значение:
//   СправочникСсылка.СообщенияИнтегрированныхСистем - подготовленное сообщение
//
Функция СоздатьНовоеСообщение(ИнтегрированнаяСистема)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Сообщение = Справочники.СообщенияИнтегрированныхСистем.СоздатьЭлемент();
	Сообщение.ИдентификаторСообщения = Строка(Новый УникальныйИдентификатор);
	Сообщение.Входящее = Ложь;
	Сообщение.ДатаСоздания = ТекущаяДатаСеанса();
	
	Сообщение.Записать();
	
	РегистрыСведений.ОчередиСообщенийОбменаСИнтегрированнымиСистемами.ПоместитьСообщениеВОчередь(
		ИнтегрированнаяСистема,
		Сообщение);
	
	// Установка у сообщения степени готовности 0%
	РегистрыСведений.СтепеньГотовностиСообщенийИнтегрированныхСистем.УстановитьПроцентГотовности(Сообщение, 0);
	
	Возврат Сообщение.Ссылка;
	
КонецФункции

// Формирует содержание сообщения с изменениями с момента последнего обмена
//
// Параметры:
//	Сообщение - СправочникСсылка.СообщенияИнтегрированныхСистем - подготовленное сообщение
//	ИнтегрированнаяСистема - ПланОбменаСсылка.ИнтегрированныеСистемы - узел-получатель
//
Процедура СформироватьПакетОбмена(Сообщение, ИнтегрированнаяСистема)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачалоПодготовки = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	
	НачатьТранзакцию();
	
	Попытка
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла, "UTF-8");
		ЗаписьXML.ЗаписатьОбъявлениеXML();
				
		// Выборка всех изменений
		ДанныеДляПередачи = ПолучитьДанныеДляПередачи(ИнтегрированнаяСистема);
		
		КоличествоОбъектовВсего = ДанныеДляПередачи.Количество();
		ВВыборкеЕстьДанные = КоличествоОбъектовВсего > 0;
		
		СчетчикОбъектов = 0;
		МассивАдресатов = Новый Массив;
		ОбъектыXDTO = Новый Массив;
		ЗаписиXDTO = Новый Массив;
		
		Для Каждого ЭлементДанных Из ДанныеДляПередачи Цикл
			Попытка
				ПолучитьXDTOИзОбъекта(ИнтегрированнаяСистема, ЭлементДанных, ОбъектыXDTO, ЗаписиXDTO);
			Исключение
				Инфо = ИнформацияОбОшибке();
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Обмен с интегрированными системами.Формирование сообщения'; en = 'Exchange with integrated systems.Generating message'", Метаданные.ОсновнойЯзык.КодЯзыка),
					УровеньЖурналаРегистрации.Ошибка,,
					ЭлементДанных,
					ПодробноеПредставлениеОшибки(Инфо));
				ВызватьИсключение;
			КонецПопытки;
			// Расчет процента готовности сообщения.
			// Максимальное значение 99, т.к. необходимо гарантировать, 
			//	что не будет выполняться попытка передать сообщение клиенту до того,
			//	как данные сообщения будут записаны.
			СчетчикОбъектов = СчетчикОбъектов + 1;
			ПроцентГотовности = Окр(99 * (СчетчикОбъектов/КоличествоОбъектовВсего));
			РегистрыСведений.СтепеньГотовностиСообщенийИнтегрированныхСистем.УстановитьПроцентГотовности(
				Сообщение, ПроцентГотовности);
		КонецЦикла;
		
		КонецПодготовки = ТекущаяУниверсальнаяДатаВМиллисекундах();
		
		РегистрыСведений.СведенияОСообщенияхОбменаСИнтегрированнымиСистемами.ЗаписатьВремяПодготовки(
			Сообщение,
			(КонецПодготовки - НачалоПодготовки)/1000);
			
		Если ВВыборкеЕстьДанные Тогда	
			
			ВыгрузитьМассивXDTOВСообщение(ИмяВременногоФайла, ЗаписьXML, ОбъектыXDTO, ЗаписиXDTO, Сообщение);
			УдалитьФайлы(ИмяВременногоФайла);
	 	Иначе
			// Если данных к выгрузке нет, то сообщение удаляется из очереди и из базы.
			СообщениеОбъект = Сообщение.ПолучитьОбъект();
			СообщениеОбъект.Удалить();
			ЗаписьXML.Закрыть();
			УдалитьФайлы(ИмяВременногоФайла);
		КонецЕсли;

		ПланыОбмена.УдалитьРегистрациюИзменений(ИнтегрированнаяСистема);
		
	Исключение
		ЗаписьXML.Закрыть();
		ОтменитьТранзакцию();
		Если НайтиФайлы(ИмяВременногоФайла).Количество() > 0 Тогда 
			УдалитьФайлы(ИмяВременногоФайла);
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

// Добавляет в массив объект XDTO, заполненный по указанному объекту Документооборота.
//
// Параметры:
//   Узел - ПланОбменаСсылка.ИнтегрированныеСистемы - узел-контрагент ИС.
//   Объект - Произвольный - добавляемый объект Документооборота.
//   ОбъектыXDTO - Массив - дополняемый массив объектов XDTO, наследников DMObject. Неявно возвращаемое значение.
//   ЗаписиXDTO - Массив - дополняемый массив объектов XDTO, не соответствующих ссылочным объектам ДО.
//
Процедура ПолучитьXDTOИзОбъекта(Узел, Объект, ОбъектыXDTO, ЗаписиXDTO)
	
	Если ТипЗнч(Объект) = Тип("Структура") Тогда
		ЗаписьXDTO = ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.ПолучитьЗаписьСостоянияСогласования(Объект);
		ЗаписиXDTO.Добавить(ЗаписьXDTO);
		
	Иначе // ссылочный тип
		
		ОбъектID = ОбработкаЗапросовXDTO.ПолучитьObjectIDПоСсылке(Объект);
		
		Если ОбъектID.type = "DMFile" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOФайлы.ПолучитьКарточкуФайла(ОбъектID.id, Новый Массив);
			
		ИначеЕсли ОбъектID.type = "DMBusinessProcessTask" 
			Или ОбъектID.type = "DMBusinessProcessOrderTaskCheckup"
			Или ОбъектID.type = "DMBusinessProcessApprovalTaskApproval"
			Или ОбъектID.type = "DMBusinessProcessApprovalTaskCheckup"
			Или ОбъектID.type = "DMBusinessProcessConfirmationTaskConfirmation"
			Или ОбъектID.type = "DMBusinessProcessConfirmationTaskCheckup"
			Или ОбъектID.type = "DMBusinessProcessRegistrationTaskRegistration"
			Или ОбъектID.type = "DMBusinessProcessRegistrationTaskCheckup"
			Или ОбъектID.type = "DMBusinessProcessConsiderationTaskAcquaint"
			Или ОбъектID.type = "DMBusinessProcessPerfomanceTaskCheckup" 
			Или ОбъектID.type = "DMBusinessProcessIssuesSolutionTaskQuestion" 
			Или ОбъектID.type = "DMBusinessProcessIssuesSolutionTaskAnswer" 
			Или ОбработкаЗапросовXDTOПереопределяемый.ПроверитьТипОбъектаПриПолученииЗадачи(ОбъектID) Тогда
			
			ОбъектXDTO = ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.ПолучитьЗадачуБизнесПроцесса(Узел, ОбъектID, Ложь);
			
		ИначеЕсли ОбъектID.type = "DMBusinessProcessPerformance"
			Или ОбъектID.type = "DMBusinessProcessPerformance_1.2.1.11"
			Или ОбъектID.type = "DMBusinessProcessAcquaintance"
			Или ОбъектID.type = "DMBusinessProcessOrder"
			Или ОбъектID.type = "DMBusinessProcessConsideration"
			Или ОбъектID.type = "DMBusinessProcessRegistration"
			Или ОбъектID.type = "DMBusinessProcessApproval"
			Или ОбъектID.type = "DMBusinessProcessApproval_1.2.1.11"
			Или ОбъектID.type = "DMBusinessProcessConfirmation"
			Или ОбъектID.type = "DMBusinessProcessInternalDocumentProcessing"
			Или ОбъектID.type = "DMBusinessProcessIncomingDocumentProcessing"
			Или ОбъектID.type = "DMBusinessProcessOutgoingDocumentProcessing"
			Или ОбъектID.type = "DMBusinessProcessIssuesSolution"
			Или ОбработкаЗапросовXDTOПереопределяемый.ПроверитьТипОбъектаПриПолученииПроцесса(ОбъектID) Тогда
			
			ОбъектXDTO = ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.ПолучитьБизнесПроцесс(Узел, ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMBusinessProcessExecutorRole" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.ПолучитьРольИсполнителей(ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMIncomingDocument" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьВходящийДокумент(Узел, ОбъектID,, Истина);
			
		ИначеЕсли ОбъектID.type = "DMOutgoingDocument" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьИсходящийДокумент(Узел, ОбъектID,, Истина);
			
		ИначеЕсли ОбъектID.type = "DMInternalDocument" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьВнутреннийДокумент(Узел, ОбъектID,, Истина);
			
		ИначеЕсли ОбъектID.type = "DMInternalDocumentType" 
			ИЛИ ОбъектID.type = "DMIncomingDocumentType" 
			ИЛИ ОбъектID.type = "DMOutgoingDocumentType" Тогда 
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьВидДокумента(ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMIncomingDocumentTemplate" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьШаблонВходящегоДокумента(Узел, ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMOutgoingDocumentTemplate" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьШаблонИсходящегоДокумента(Узел, ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMInternalDocumentTemplate" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьШаблонВнутреннегоДокумента(Узел, ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMSubdivision" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьПодразделение(ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMCurrency" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьВалюту(ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMUser" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьПользователя(ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMContactPerson" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьКонтактноеЛицо(ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMPrivatePerson" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьФизическоеЛицо(ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMOrganization" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьОрганизацию(ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMCorrespondent" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOДокументы.ПолучитьКонтрагента(Узел, ОбъектID,, Истина);
			
		ИначеЕсли ОбъектID.type = "DMDailyReport" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOУчетВремени.ПолучитьЕжедневныйОтчет(ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMMeeting" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOКорп.ПолучитьМероприятие(Узел, ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMMeetingMinutesItem" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOКорп.ПолучитьПунктПротоколаМероприятия(Узел, ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMForumThread" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOКорп.ПолучитьТемуОбсуждения(Узел, ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMForumMessage" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOКорп.ПолучитьСообщениеОбсуждения(Узел, ОбъектID);
			
		ИначеЕсли ОбъектID.type = "DMPremisesReservation" Тогда
			ОбъектXDTO = ОбработкаЗапросовXDTOКорп.ПолучитьБронь(Узел, ОбъектID);
			
		Иначе
			ОбъектXDTO = ОбработкаЗапросовXDTO.ПолучитьНеОписанныйОбъект(ОбъектID);
			
		КонецЕсли;
		
		Если ОбработкаЗапросовXDTO.ПроверитьТип(ОбъектXDTO, "DMError") Тогда
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Обмен с интегрированными системами.Формирование сообщения'; en = 'Exchange with integrated systems.Generating message'", Метаданные.ОсновнойЯзык.КодЯзыка),
				УровеньЖурналаРегистрации.Ошибка, , Объект, ОбъектXDTO.description);
		Иначе
			ОбъектыXDTO.Добавить(ОбъектXDTO);
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

// Выполняет выгрузку массива объектов XDTO в XML-файл для последующей передачи интегрированной системе.
//
// Параметры:
//	 ИмяВременногоФайла - Строка - имя файла XML на диске.
//	 ЗаписьXML - ЗаписьXML - объект, с помощью которого выполняется запись в файл.
//	 ОбъектыXDTO - Массив - содержит объекты XDTO, подлежащие выгрузке (наследники DMObject).
//	 ЗаписиXDTO - Массив - содержит объекты XDTO, подлежащие выгрузке (кроме ссылочных).
//	 Сообщение - СправочникСсылка.СообщенияИнтегрированныхСистем - сообщение к заполнению.
//
Процедура ВыгрузитьМассивXDTOВСообщение(ИмяВременногоФайла, ЗаписьXML, ОбъектыXDTO, ЗаписиXDTO, Сообщение) Экспорт
	
	НачалоЗаполнения = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Message");
	// Ссылочные типы (наследники DMObject).
	Для Каждого ОбъектXDTO из ОбъектыXDTO Цикл
		Если ОбъектXDTO = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Попытка
			ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектXDTO);	 
		Исключение
			Инфо = ОписаниеОшибки();
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Обмен с интегрированными системами.Выгрузка XDTO в XML'; en = 'Exchange with integrated systems.Exporting XDTO to XML'", Метаданные.ОсновнойЯзык.КодЯзыка),
				УровеньЖурналаРегистрации.Ошибка,
				,
				ОбъектXDTO.Тип().Имя,
				ОбъектXDTO.Тип().Имя + Символы.ПС + ПодробноеПредставлениеОшибки(Инфо));
		КонецПопытки;
	КонецЦикла;
	// Прочие объекты (наборы записей РС и т.п.).
	Для Каждого ОбъектXDTO из ЗаписиXDTO Цикл
		Если ОбъектXDTO = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Попытка
			ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектXDTO);	 
		Исключение
			Инфо = ОписаниеОшибки();
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Обмен с интегрированными системами.Выгрузка XDTO в XML'; en = 'Exchange with integrated systems.Exporting XDTO to XML'", Метаданные.ОсновнойЯзык.КодЯзыка),
				УровеньЖурналаРегистрации.Ошибка,
				,
				ОбъектXDTO.Тип().Имя,
				ОбъектXDTO.Тип().Имя + Символы.ПС + ПодробноеПредставлениеОшибки(Инфо));
		КонецПопытки;
	КонецЦикла;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();	// Message
	
	ЗаписьXML.Закрыть();
	ДвоичныеДанныеСообщения = Новый ДвоичныеДанные(ИмяВременногоФайла);
	
	// Запись массива частей файла в содержательную часть сообщения интегрированных систем.
	СообщениеОбъект = Сообщение.ПолучитьОбъект(); 
	СообщениеОбъект.ДанныеСообщения = Новый ХранилищеЗначения(ДвоичныеДанныеСообщения);
	СообщениеОбъект.Записать();
	
	ОкончаниеЗаполнения = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	РегистрыСведений.СведенияОСообщенияхОбменаСИнтегрированнымиСистемами.ЗаписатьСведения(
		Сообщение,
		ДвоичныеДанныеСообщения.Размер(),
		ОбъектыXDTO.Количество() + ЗаписиXDTO.Количество());
		
	РегистрыСведений.СведенияОСообщенияхОбменаСИнтегрированнымиСистемами.ЗаписатьВремяФормирования(
		Сообщение,
		(ОкончаниеЗаполнения - НачалоЗаполнения)/1000);
	
	// Установка отметки о 100% готовности сообщения после выполнения всех действий по подготовке сообщения.
	// После установки степени готовности в 100% сообщение может быть передано на клиента.
	РегистрыСведений.СтепеньГотовностиСообщенийИнтегрированныхСистем.УстановитьПроцентГотовности(Сообщение, 100);
	
	УдалитьФайлы(ИмяВременногоФайла);
	
КонецПроцедуры

// Возвращает массив узлов интегрированных систем для указанной ссылки на объект ДО.
//
// Параметры:
//   Ссылка - ЛюбаяСсылка - ссылка на объект ДО.
//
Функция ПолучитьУзлыОбменаИнтегрированныхСистемДляОбъектаДО(Ссылка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Перед выполнением запроса удостоверимся, что узлы вообще есть.
	ИнтегрированныеСистемы = ОбработкаЗапросовXDTOПовтИсп.ПолучитьУзлыОбменаИнтегрированныхСистем();
	Если ИнтегрированныеСистемы.Количество() = 0 Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	// Шаблоны регистрируем без учета установленных связей: информация об этом есть в самих правилах.
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ШаблоныВнутреннихДокументов")
		Или ТипЗнч(Ссылка) = Тип("СправочникСсылка.ШаблоныИсходящихДокументов")
		Или ТипЗнч(Ссылка) = Тип("СправочникСсылка.ШаблоныВходящихДокументов") Тогда
		
		Возврат ИнтегрированныеСистемы;
		
	Иначе // Регистрируем только объекты, связи которых зафиксированы в РС.
	
		Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Связи.УзелИнтегрированнойСистемы КАК Узел
			|ИЗ
			|	РегистрСведений.СвязиОбъектовИнтегрированныхСистем КАК Связи
			|ГДЕ
			|	СсылкаНаОбъектДО = &Ссылка
			|	И УзелИнтегрированнойСистемы <> ЗНАЧЕНИЕ(ПланОбмена.ИнтегрированныеСистемы.ПустаяСсылка)");
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Узлы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Узел");
		Возврат Узлы;
		
	КонецЕсли;
	
КонецФункции

// Регистрирует объект по ссылке на подходящих узлах и возвращает их.
//
// Параметры:
//   Ссылка - ЛюбаяСсылка - ссылка на объект ДО.
//
// Возвращаемое значение:
//   Массив - ПланОбменаСсылка.ИнтегрированныеСистемы - узлы, регистрация на которых выполнена.
//
Функция ЗарегистрироватьСсылку(Ссылка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.Файлы") Тогда // регистрируем владельца
		
		ВладелецФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ВладелецФайла");
		
		Если ТипЗнч(ВладелецФайла) <> Тип("СправочникСсылка.ВходящиеДокументы")
			И ТипЗнч(ВладелецФайла) <> Тип("СправочникСсылка.ВнутренниеДокументы")
			И ТипЗнч(ВладелецФайла) <> Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
			
			Возврат Новый Массив;
			
		КонецЕсли;
		
		Источник = ВладелецФайла;
		
	Иначе // документ, контрагент
		
		Источник = Ссылка;
		
	КонецЕсли;
	
	Узлы = ПолучитьУзлыОбменаИнтегрированныхСистемДляОбъектаДО(Источник);
	Если Узлы.Количество() <> 0 Тогда
		ПланыОбмена.ЗарегистрироватьИзменения(Узлы, Источник);
	КонецЕсли;
	
	Возврат Узлы;
	
КонецФункции

// Регистрирует объект на подходящих узлах.
//
// Параметры:
//   Объект - Произвольный - объект ДО.
//   ЭтоУдалениеОбъекта - Булево - Истина, если регистрация происходит перед удалением объекта.
//
Процедура ЗарегистрироватьОбъект(Объект, ЭтоУдалениеОбъекта = Ложь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(ПараметрыСеанса.ПараметрыОбработчикаОбновления)
		И Объект.ДополнительныеСвойства.Свойство("РегистрироватьНаУзлахПлановОбменаПриОбновленииИБ") Тогда
		
		ОтключитьРегистрацию = Истина;
		
		Если Объект.ДополнительныеСвойства.РегистрироватьНаУзлахПлановОбменаПриОбновленииИБ = Неопределено Тогда
			Если Не ЭтоУдалениеОбъекта И Объект.ЭтоНовый() Тогда
				ОтключитьРегистрацию = Ложь;
			КонецЕсли;
			
		ИначеЕсли Объект.ДополнительныеСвойства.РегистрироватьНаУзлахПлановОбменаПриОбновленииИБ Тогда
			ОтключитьРегистрацию = Ложь;
		КонецЕсли;
		
		Если ОтключитьРегистрацию Тогда
			Возврат;
		КонецЕсли;
		
	ИначеЕсли Объект.ДополнительныеСвойства.Свойство("ОтключитьМеханизмРегистрацииОбъектов") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Объект) = Тип("СправочникОбъект.Файлы") Тогда
		ЗарегистрироватьСсылку(Объект.ВладелецФайла);
		
	Иначе
		
		Узлы = ПолучитьУзлыОбменаИнтегрированныхСистемДляОбъектаДО(Объект.Ссылка);
		
		Для Каждого Узел Из Узлы Цикл
			Объект.ОбменДанными.Получатели.Добавить(Узел);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
