////////////////////////////////////////////////////////////////////////////////
// Бронирование помещений
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устанавливает пометку удаления брони и оповещает другие формы.
//
// Параметры:
//  Бронь			 - ДокументСсылка.Бронь	 - Бронь.
//  ПометкаУдаления	 - Булево				 - Новая пометка удаления.
// 
// Возвращаемое значение:
//  Булево - Признак того что новая пометка удаления была установлена.
//
Функция УстановитьПометкуУдаления(Бронь, ПометкаУдаления) Экспорт
	
	УстановленаПометкаУдаления = Ложь;
	
	Если ТипЗнч(Бронь) <> Тип("ДокументСсылка.Бронь") Тогда
		Возврат УстановленаПометкаУдаления;
	КонецЕсли;
	
	БроньОбъект = Бронь.ПолучитьОбъект();
	БроньОбъект.Заблокировать();
	Если БроньОбъект.ПометкаУдаления <> ПометкаУдаления Тогда
		БроньОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
		ДобавитьВИсториюРаботыПользователя(БроньОбъект);
		УстановленаПометкаУдаления = Истина;
	КонецЕсли;
	
	Возврат УстановленаПометкаУдаления;
	
КонецФункции

// Устанавливает пометки удаления броней и возвращает факт изменения пометки удаления.
//
// Параметры:
//  Брони				 - Массив	 - Помечаемые на удаление брони.
//  ПовторяющиесяБрони	 - Массив	 - Помечаемые на удаление повторяющиеся брони.
//  ПометкаУдаления		 - Булево	 - Новая пометка удаления.
// 
// Возвращаемое значение:
//  Булево - Признак того что новая пометка удаления была установлена.
//
Функция УстановитьПометкиУдаления(Брони, ПовторяющиесяБрони, ПометкаУдаления) Экспорт
	
	УстановленаПометкаУдаления = Ложь;
	
	НачатьТранзакцию();
	Попытка
		
		Для Каждого Бронь Из Брони Цикл
			
			Если ТипЗнч(Бронь) <> Тип("ДокументСсылка.Бронь") Тогда
				Продолжить;
			КонецЕсли;
			
			БроньОбъект = Бронь.ПолучитьОбъект();
			БроньОбъект.Заблокировать();
			Если БроньОбъект.ПометкаУдаления <> ПометкаУдаления Тогда
				БроньОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
				ДобавитьВИсториюРаботыПользователя(БроньОбъект);
				УстановленаПометкаУдаления = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ПометкаУдаления и ПовторяющиесяБрони.Количество() > 0 Тогда
			
			Для Каждого ПовторяющаясяБронь Из ПовторяющиесяБрони Цикл
				
				БроньОбъект = ПовторяющаясяБронь.Бронь.ПолучитьОбъект();
				БроньОбъект.Заблокировать();
				БроньОбъект.ДобавитьИсключениеПовторения(ПовторяющаясяБронь.ДатаИсключения);
				БроньОбъект.Записать();
				
				ДобавитьВИсториюРаботыПользователя(БроньОбъект);
				
				УстановленаПометкаУдаления = Истина;
				
			КонецЦикла;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ВызватьИсключение;
		
	КонецПопытки;
	
	Возврат УстановленаПометкаУдаления;
	
КонецФункции

// Создает бронь.
//
// Параметры:
//  Бронь	 - Структура - Данные брони.
// 
// Возвращаемое значение:
//  Структура - Результат брони.
//
Функция СоздатьБронь(Бронь) Экспорт
	
	БроньОбъект = Документы.Бронь.СоздатьДокумент();
	БроньОбъект.Заполнить(Бронь);
	БроньОбъект.Записать();
	
	ДобавитьВИсториюРаботыПользователя(БроньОбъект);
	
	Возврат БроньОбъект.РезультатБрони();
	
КонецФункции

// Изменяет брони.
//
// Параметры:
//  ИзмененныеБрони	 - Массив	 - Измененные структуры броней.
// 
// Возвращаемое значение:
//  Массив - Результаты броней.
//
Функция ИзменитьБрони(ИзмененныеБрони) Экспорт
	
	РезультатыБроней = Новый Массив;
	
	НачатьТранзакцию();
	Попытка
		
		Для Каждого Бронь Из ИзмененныеБрони Цикл
			
			Если Бронь.ТипЗаписи = Перечисления.ТипЗаписиКалендаря.ПовторяющеесяСобытие Тогда
				БроньОбъект = Документы.Бронь.СоздатьДокумент();
				БроньОбъект.Заполнить(Бронь.Ссылка);
				БроньОбъект.ДополнительныеСвойства.Вставить("ПовторяющаясяБронь", Бронь.Ссылка);
				БроньОбъект.ДополнительныеСвойства.Вставить("ДатаИсключения", Бронь.ДатаНачалаИсходная);
			Иначе
				БроньОбъект = Бронь.Ссылка.ПолучитьОбъект();
				БроньОбъект.Заблокировать();
			КонецЕсли;
			
			
			ЗаполнитьЗначенияСвойств(БроньОбъект, Бронь, "Помещение, ДатаНачала, ДатаОкончания");
			БроньОбъект.СпособСозданияБрони = Перечисления.СпособыСозданияБрони.Вручную;
			БроньОбъект.Записать();
			
			ДобавитьВИсториюРаботыПользователя(БроньОбъект);
			РезультатыБроней.Добавить(БроньОбъект.РезультатБрони());
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат РезультатыБроней;
	
КонецФункции

// Сформировать данные выбора помещения.
//
// Параметры:
//  ПараметрыПолученияДанных - Структура - Параметры получения данных.
//
// Возвращаемое значение:
//  СписокЗначений - Данные выбора помещения.
//
Функция СформироватьДанныеВыбораПомещения(ПараметрыПолученияДанных) Экспорт
	
	ПараметрыПолученияДанных.Отбор.Вставить("ДляБронирования", Истина);
	ДанныеВыбора = Справочники.ТерриторииИПомещения.ПолучитьДанныеВыбора(ПараметрыПолученияДанных);
	
	Возврат ДанныеВыбора;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Добавляет ссылку в историю работы пользователя.
//
Процедура ДобавитьВИсториюРаботыПользователя(Бронь)
	
	ТипПараметра = ТипЗнч(Бронь);
	Если ТипПараметра = Тип("ДокументОбъект.Бронь") Тогда
		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Бронь.Ссылка);
	ИначеЕсли ТипПараметра = Тип("ДокументСсылка.Бронь") Тогда
		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Бронь);
	КонецЕсли;
	ИсторияРаботыПользователя.Добавить(НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти
