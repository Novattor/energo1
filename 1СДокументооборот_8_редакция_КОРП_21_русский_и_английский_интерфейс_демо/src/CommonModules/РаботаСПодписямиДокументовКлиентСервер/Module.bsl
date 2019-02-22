// Возвращает Истина, если переданное значение является
// ссылкой на справочник Контрагенты
Функция ЭтоКонтрагент(Значение) Экспорт 

	Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.Контрагенты"); 	

КонецФункции 

// Возвращает Истина, если переданное значение является
// ссылкой на справочник Организации
Функция ЭтоОрганизация(Значение) Экспорт 

	Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.Организации");	

КонецФункции

// Возвращает структуру, необходимую для регистрации внутреннего документа
//
// Параметры:
// 	Объект - Внутренний Документ 
// 
// Возвращаемое значение:
//	ПараметрыРегистрации - Структура - структура параметров
//
Функция ПараметрыРегистрации(Объект) Экспорт

	ПараметрыРегистрации = Новый Структура();
	ПараметрыРегистрации.Вставить("Организация", Объект.Организация);
	ПараметрыРегистрации.Вставить("Контрагент", Объект.Контрагент);

	СторонаОрганизации = Неопределено;
	СторонаКонтрагент = Неопределено;
	
	ИндексСторон = Объект.Стороны.Количество()-1;
	
	Пока ИндексСторон > -1 Цикл
		
		Если ЗначениеЗаполнено(Объект.Стороны[ИндексСторон].Сторона) 
			И ЭтоОрганизация(Объект.Стороны[ИндексСторон].Сторона) Тогда
				СторонаОрганизации = Объект.Стороны[ИндексСторон].Сторона;
		ИначеЕсли ЗначениеЗаполнено(Объект.Стороны[ИндексСторон].Сторона)
			И ЭтоКонтрагент(Объект.Стороны[ИндексСторон].Сторона) Тогда
				СторонаКонтрагент = Объект.Стороны[ИндексСторон].Сторона;
		КонецЕсли;
			
		ИндексСторон = ИндексСторон - 1;
	КонецЦикла;
	
	Если СторонаОрганизации <> Неопределено Тогда
		ПараметрыРегистрации.Вставить("Организация", СторонаОрганизации);
	КонецЕсли;
		
	Если СторонаКонтрагент <> Неопределено Тогда
		ПараметрыРегистрации.Вставить("Контрагент", СторонаКонтрагент);
	КонецЕсли;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции


