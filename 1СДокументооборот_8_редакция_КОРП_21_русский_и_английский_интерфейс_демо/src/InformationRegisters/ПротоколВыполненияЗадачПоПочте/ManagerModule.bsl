// Записывает результат выполнения по сообщению
Процедура ЗаписатьРезультатВыполненияПоСообщению(Сообщение, РезультатВыполнения, Описание = "",
	Задача) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ПротоколВыполненияЗадачПоПочте.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Период = ТекущаяДатаСеанса();
	МенеджерЗаписи.ИдентификаторСообщения = Сообщение.Идентификатор;
	МенеджерЗаписи.РезультатВыполнения = РезультатВыполнения;
	МенеджерЗаписи.Отправитель = Сообщение.Отправитель;
	МенеджерЗаписи.Тема = Сообщение.Тема;
	МенеджерЗаписи.ДатаОтправки = Сообщение.ДатаОтправки;
	МенеджерЗаписи.Описание = Описание;
	МенеджерЗаписи.Задача = Задача;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Удаляет устаревшие записи регистра
Процедура ОчиститьРегистрОтУстаревшихЗаписей() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СрокХранения = Константы.СрокХраненияПротоколовВыполненияЗадачПоПочте.Получить();
	
	Если СрокХранения <> 0 Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПротоколВыполненияЗадачПоПочте.Период,
			|	ПротоколВыполненияЗадачПоПочте.ИдентификаторСообщения,
			|	ПротоколВыполненияЗадачПоПочте.РезультатВыполнения
			|ИЗ
			|	РегистрСведений.ПротоколВыполненияЗадачПоПочте КАК ПротоколВыполненияЗадачПоПочте
			|ГДЕ
			|	ПротоколВыполненияЗадачПоПочте.Период < &Период
			|	И (ПротоколВыполненияЗадачПоПочте.Задача = ЗНАЧЕНИЕ(Задача.ЗадачаИсполнителя.ПустаяСсылка)
			|			ИЛИ ПротоколВыполненияЗадачПоПочте.Задача.Выполнена = ИСТИНА)";
			
		Период = ТекущаяДатаСеанса() - (86400 * СрокХранения);
		Запрос.УстановитьПараметр("Период", Период);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			МенеджерЗаписи = РегистрыСведений.ПротоколВыполненияЗадачПоПочте.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
			МенеджерЗаписи.Прочитать();
			МенеджерЗаписи.Удалить();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


