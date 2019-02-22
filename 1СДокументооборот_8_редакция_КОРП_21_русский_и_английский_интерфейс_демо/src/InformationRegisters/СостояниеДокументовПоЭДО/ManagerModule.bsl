#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет запись в регистр СостояниеВерсииДокументаПоЭДО.
//
// Параметры:
//  ДокументДО - документ документооборота .
//  Контрагент - СправочникСсылка.Контрагенты - Контрагент из таблицы Стороны.
//  Комментарий - Строка - Комментарий к состоянию
Процедура Добавить(ДокументДО, Контрагент, СостояниеВерсииДокументаПоЭДО, НаправлениеЭД = Неопределено, Комментарий = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДатаСеанса();
	МенеджерЗаписи.ДокументДО = ДокументДО;
	МенеджерЗаписи.Контрагент = Контрагент;
	МенеджерЗаписи.СостояниеВерсииДокументаПоЭДО = СостояниеВерсииДокументаПоЭДО;
	Если Не Комментарий = Неопределено Тогда
		МенеджерЗаписи.Комментарий = Комментарий;
	КонецЕсли;
	Если НаправлениеЭД = Неопределено Тогда
		ДанныеСостоянияДокументаПоЭДО(ДокументДО, Контрагент, ,НаправлениеЭД);
	КонецЕсли; 
	МенеджерЗаписи.НаправлениеЭД = НаправлениеЭД;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Возвращает состояние версии документа ДО по ЭДО.
	//
	// Параметры:
	//  ДокументДО - документ документооборота .
	//  Контрагент - СправочникСсылка.Контрагенты - Контрагент по ЭДО.
	// 
	// Возвращаемое значение:
	//  СостоянияВерсийЭДДО - ПеречислениеСсылка.СостоянияВерсийЭДДО - состояние версии документа ДО по ЭДО.
	//
Функция ДанныеСостоянияДокументаПоЭДО(ДокументДО, Контрагент = Неопределено, НаДату = Неопределено, НаправлениеЭД = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СостояниеДокументовПоЭДО.СостояниеВерсииДокументаПоЭДО КАК СостояниеВерсииДокументаПоЭДО,
	|	СостояниеДокументовПоЭДО.НаправлениеЭД КАК НаправлениеЭД,
	|	СостояниеДокументовПоЭДО.Период КАК Период
	|ИЗ
	|	РегистрСведений.СостояниеДокументовПоЭДО.СрезПоследних(&НаДату, ) КАК СостояниеДокументовПоЭДО
	|ГДЕ
	|	СостояниеДокументовПоЭДО.ДокументДО = &ДокументДО";
	
	Если Не Контрагент = Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
			|	И СостояниеДокументовПоЭДО.Контрагент = &Контрагент";
		Запрос.УстановитьПараметр("Контрагент", Контрагент);
	КонецЕсли;
	Запрос.УстановитьПараметр("НаДату", ?(НаДату = Неопределено,ТекущаяДатаСеанса(),НаДату));
	Запрос.УстановитьПараметр("ДокументДО", ДокументДО.Ссылка);
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		НаправлениеЭД = Выборка.НаправлениеЭД;
		НаДату = Выборка.Период;
		
		Возврат Выборка.СостояниеВерсииДокументаПоЭДО;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецЕсли


