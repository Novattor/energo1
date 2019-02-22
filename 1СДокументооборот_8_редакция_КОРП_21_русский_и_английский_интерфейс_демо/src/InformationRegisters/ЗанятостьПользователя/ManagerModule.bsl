#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Изменяет доступность времени
Функция ИзменитьДоступностьВремени(Пользователь, ДатаНачала, ДатаОкончания, Занят) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДатаНачала) ИЛИ НЕ ЗначениеЗаполнено(ДатаОкончания) 
		ИЛИ ДатаОкончания <= ДатаНачала Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СводнаяТаблицаЗанятости = РаботаСРабочимКалендаремСервер.ПолучитьТаблицуЗанятости(Пользователь, ДатаНачала, ДатаОкончания);
	
	Если Занят = Неопределено Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Пользователь", Пользователь);
		ПараметрыОтбора.Вставить("Занят", Перечисления.СостоянияЗанятости.Доступен);
		СтрокиСвободногоВремени = СводнаяТаблицаЗанятости.НайтиСтроки(ПараметрыОтбора);
		Если СтрокиСвободногоВремени.Количество() <> 0 Тогда
			Занят = Перечисления.СостоянияЗанятости.Занят;
		Иначе
			Занят = Перечисления.СостоянияЗанятости.Доступен;
		КонецЕсли;
		
	КонецЕсли;
	
	Попытка
		
		НачатьТранзакцию();
		
		ТаблицаЗанятости = ПолучитьТаблицуЗанятости(Пользователь, ДатаНачала, ДатаОкончания);
		Для Каждого Занятость Из ТаблицаЗанятости Цикл
			
			Если Занятость.ДатаНачала < ДатаОкончания
				И Занятость.ДатаОкончания > ДатаНачала Тогда
				
				Если Занятость.ДатаНачала < ДатаНачала Тогда
					МенеджерЗаписи = РегистрыСведений.ЗанятостьПользователя.СоздатьМенеджерЗаписи();
					ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Занятость);
					МенеджерЗаписи.ДатаОкончания = ДатаНачала;
					МенеджерЗаписи.Записать();
				КонецЕсли;
				
				Если Занятость.ДатаОкончания > ДатаОкончания Тогда
					МенеджерЗаписи = РегистрыСведений.ЗанятостьПользователя.СоздатьМенеджерЗаписи();
					ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Занятость);
					МенеджерЗаписи.ДатаНачала = ДатаОкончания;
					МенеджерЗаписи.Записать();
				КонецЕсли;
				
				МенеджерЗаписи = РегистрыСведений.ЗанятостьПользователя.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Занятость);
				МенеджерЗаписи.Удалить();
				
			КонецЕсли;
			
		КонецЦикла;
		
		МенеджерЗаписи = РегистрыСведений.ЗанятостьПользователя.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Пользователь = Пользователь;
		МенеджерЗаписи.ДатаНачала = ДатаНачала;
		МенеджерЗаписи.ДатаОкончания = ДатаОкончания;
		МенеджерЗаписи.Занят = Занят;
		МенеджерЗаписи.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
	Возврат Занят;
	
КонецФункции

// Возвращает таблицу занятости пользователей.
//
Функция ПолучитьТаблицуЗанятости(Знач МассивПользователей, ДатаНачала, ДатаОкончания) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(МассивПользователей) = Тип("СправочникСсылка.Пользователи") Тогда
		Пользователь = МассивПользователей;
		МассивПользователей = Новый Массив;
		МассивПользователей.Добавить(Пользователь);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗанятостьПользователя.Пользователь,
		|	ЗанятостьПользователя.ДатаНачала,
		|	ЗанятостьПользователя.ДатаОкончания,
		|	ЗанятостьПользователя.Занят
		|ИЗ
		|	РегистрСведений.ЗанятостьПользователя КАК ЗанятостьПользователя
		|ГДЕ
		|	ЗанятостьПользователя.Пользователь В(&МассивПользователей)
		|	И ЗанятостьПользователя.ДатаНачала < &ДатаОкончания
		|	И ЗанятостьПользователя.ДатаОкончания > &ДатаНачала";
	
	Запрос.УстановитьПараметр("МассивПользователей", МассивПользователей);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли




