////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с пометкой прочтения.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура предназначена для оповещения о прочтении объекта, в случае если он был прочтен.
// Для каждого типа объекта предназначено отдельное имя события оповещения.
Процедура ОповеститьОПрочтении(Объект, ОбъектПрочтен, ЭтаФорма = Неопределено) Экспорт 
	
	Если ТипЗнч(Объект) = Тип("Массив") Тогда
		Если Объект.Количество() > 0 Тогда
			ПрочтенныйОбъект = Объект.Получить(0);
			Если ТипЗнч(ПрочтенныйОбъект) = Тип("СправочникСсылка.СообщенияОбсуждений") Тогда
				ПрочтенныйОбъект = Объект;
			КонецЕсли;
		КонецЕсли;
	Иначе
		ПрочтенныйОбъект = Объект;
	КонецЕсли;
	
	Если ОбъектПрочтен Тогда
		ИмяСобытия = "ДанныеПрочтены";
		ОбъектПрочтен = Ложь;
		Оповестить(ИмяСобытия, ПрочтенныйОбъект);	
	КонецЕсли;
	
КонецПроцедуры

// Функция предназначена для определения необходимости обновления сведений о прочтении
// при обработки оповещения в формах.
// 		Истина - необходимо обновить информацию о прочтении.
//		Ложь - информацию о прочтении обновлять не нужно.
Функция ПроверитьНеобходимостьОбновления(ИмяСобытия, Параметр, ОжидаемыйПараметр) Экспорт
	
	Если ИмяСобытия = "ДанныеПрочтены" Тогда
		Если ОжидаемыйПараметр = "Обсуждения" Тогда
			Если ТипЗнч(Параметр) = Тип("СправочникСсылка.СообщенияОбсуждений")
				ИЛИ ТипЗнч(Параметр) = Тип("СправочникСсылка.ТемыОбсуждений") 
				ИЛИ (ТипЗнч(Параметр) = Тип("Тип") И Параметр = Тип("СправочникСсылка.СообщенияОбсуждений"))
				ИЛИ ТипЗнч(Параметр) = Тип("Массив") Тогда
				Возврат Истина;
			КонецЕсли;
			
		ИначеЕсли ОжидаемыйПараметр = "Почта" Тогда
			Если ТипЗнч(Параметр) = Тип("ДокументСсылка.ВходящееПисьмо")
				ИЛИ ТипЗнч(Параметр) = Тип("ДокументСсылка.ИсходящееПисьмо") Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
