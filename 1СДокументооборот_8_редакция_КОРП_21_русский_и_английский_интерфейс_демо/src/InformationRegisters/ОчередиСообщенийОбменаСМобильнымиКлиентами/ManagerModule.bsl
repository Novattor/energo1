// Помещает указанное сообщение в очередь для указанного клиента
Процедура ПоместитьСообщениеВОчередь(МобильныйКлиент, Сообщение) Экспорт
	
	МенеджерЗаписиОчередей = РегистрыСведений.ОчередиСообщенийОбменаСМобильнымиКлиентами.СоздатьМенеджерЗаписи();
	МенеджерЗаписиОчередей.МобильныйКлиент = МобильныйКлиент;
	МенеджерЗаписиОчередей.Прочитать();
	
	Если МенеджерЗаписиОчередей.Выбран() Тогда
		Сообщение.Очередь = МенеджерЗаписиОчередей.Очередь;	
	Иначе		
		// Если очереди для этого клиента еще нет, то она создается
		МенеджерЗаписиОчередей.МобильныйКлиент = МобильныйКлиент;
		
		НоваяОчередь = Справочники.ОчередиСообщенийИнтегрированныхСистем.СоздатьЭлемент();
		НоваяОчередь.Наименование = 
				Строка(МенеджерЗаписиОчередей.МобильныйКлиент.Пользователь);
		НоваяОчередь.Записать();		
		
		МенеджерЗаписиОчередей.Очередь = НоваяОчередь.Ссылка;
		МенеджерЗаписиОчередей.Записать();
		
		Сообщение.Очередь = НоваяОчередь.Ссылка;	
	КонецЕсли;
	Сообщение.Записать();
	
КонецПроцедуры

// Получает количество сообщений в очереди для указанного клиента
Функция ПолучитьКоличествоСообщенийВОчереди(МобильныйКлиент) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(СообщенияИнтегрированныхСистем.Ссылка) КАК Колво
		|ИЗ
		|	Справочник.СообщенияИнтегрированныхСистем КАК СообщенияИнтегрированныхСистем
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОчередиСообщенийОбменаСМобильнымиКлиентами КАК ОчередиСообщенийОбменаСМобильнымиКлиентами
		|		ПО СообщенияИнтегрированныхСистем.Очередь = ОчередиСообщенийОбменаСМобильнымиКлиентами.Очередь
		|ГДЕ
		|	ОчередиСообщенийОбменаСМобильнымиКлиентами.МобильныйКлиент = &МобильныйКлиент
		|	И СообщенияИнтегрированныхСистем.ПометкаУдаления = ЛОЖЬ";
	Запрос.УстановитьПараметр("МобильныйКлиент", МобильныйКлиент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Колво;
	Иначе
		Возврат 0;
	КонецЕсли;
			
КонецФункции


