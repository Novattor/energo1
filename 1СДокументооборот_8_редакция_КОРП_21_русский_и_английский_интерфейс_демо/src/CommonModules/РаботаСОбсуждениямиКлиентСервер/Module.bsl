////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с форумом.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Осуществляет поиск сообщения в дереве сообщений.
//
// Параметры:
//  КоллекцияСообщенийОдногоУровня - ДанныеФормыКоллекцияЭлементовДерева - Список сообщений одного уровня дерева.
//  ИскомоеСообщение - СправочникСсылка.СообщенияОбсуждений - Сообщение, которое необходимо найти.
//  Индекс - Число - Значение индекса найденной задачи в дереве. Если сообщение не найдено, 
//                   значение параметра не изменяется.
//
Процедура НайтиСообщениеВДеревеПоСсылке(КоллекцияСообщенийОдногоУровня, ИскомоеСообщение, Индекс) Экспорт
	
	Если ТипЗнч(Индекс) = Тип("Число") И Индекс > -1 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Сообщение Из КоллекцияСообщенийОдногоУровня Цикл
		Если Сообщение.Ссылка = ИскомоеСообщение Тогда
			Индекс = Сообщение.ПолучитьИдентификатор();
		Иначе
			НайтиСообщениеВДеревеПоСсылке(Сообщение.ПолучитьЭлементы(), ИскомоеСообщение, Индекс);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Формирует текстовое представление сообщения
Функция СформироватьТекстовоеПредставлениеСообщения(ТекстСообщения, АвторСообщения, ДатаСообщения) Экспорт
	
	ТестовоеПредставлениеСообщения =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Автор: %1
				|Дата сообщения: %2
				|
				|%3';
				|en = 'Author: %1
				|Message date: %2
				|
				|%3'"),
			АвторСообщения,
			ДатаСообщения,
			ТекстСообщения);
	
	Возврат ТестовоеПредставлениеСообщения;
	
КонецФункции

// Формирует текстовое представление даты.
//
// Параметры:
//  Дата - Дата - Дата, представление которой формируется.
//  СЗаглавнойБуквы - Булево - Начинать ли надпись даты с заглавной буквы.
//
// Возвращаемое значение:
//  Строка - Текстовое представление даты.
//
Функция СформироватьТекстовоеПредставлениеДаты(Дата, СЗаглавнойБуквы) Экспорт
	
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Возврат "";
	КонецЕсли;
	
	ПериодСегодня = Новый СтандартныйПериод(ВариантСтандартногоПериода.Сегодня);
	НачалоСегодня = ПериодСегодня.ДатаНачала;
	
	ПериодВчера = Новый СтандартныйПериод(ВариантСтандартногоПериода.Вчера);
	НачалоВчера = ПериодВчера.ДатаНачала;
	
	ПериодЭтотГод = Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтотГод);
	НачалоЭтогоГода = ПериодЭтотГод.ДатаНачала;
	
	ФорматнаяСтрока = "";
	Если Дата >= НачалоСегодня Тогда
		Если СЗаглавнойБуквы Тогда
			// Сегодня в 11:11
			ФорматнаяСтрока = НСтр("ru = 'ДФ=''Се''''г''''о''''д''''ня ''''в'''' HH:mm'''; en = 'ДФ=''To''''d''''a''''y'''' ''''at'''' HH:mm'''");
		Иначе
			// сегодня в 11:11
			ФорматнаяСтрока = НСтр("ru = 'ДФ=''''''с''''е''''г''''о''''д''''ня ''''в'''' HH:mm'''; en = 'ДФ=''''''t''''o''''d''''a''''y'''' ''''at'''' HH:mm'''");
		КонецЕсли;
	ИначеЕсли Дата < НачалоСегодня И Дата >= НачалоВчера Тогда
		Если СЗаглавнойБуквы Тогда
			// Вчера в 11:11
			ФорматнаяСтрока = НСтр("ru = 'ДФ=''В''''ч''''ера ''''в'''' HH:mm'''; en = 'ДФ=''Y''''esterda''''y ''''at'''' HH:mm'''");
		Иначе
			// Вчера в 11:11
			ФорматнаяСтрока = НСтр("ru = 'ДФ=''''''в''''''''ч''''ера ''''в'''' HH:mm'''; en = 'ДФ=''y''''esterda''''y ''''at'''' HH:mm'''");
		КонецЕсли;
	ИначеЕсли Дата < НачалоВчера И Дата >= НачалоЭтогоГода Тогда
		// 11 ноября в 11:11
		ФорматнаяСтрока = НСтр("ru = 'ДФ=''d MMMM ''''в'''' HH:mm'''; en = 'ДФ=''d MMMM ''''at'''' HH:mm'''");
	ИначеЕсли Дата < НачалоЭтогоГода Тогда
		// 11 ноября 2011 в 11:11
		ФорматнаяСтрока = НСтр("ru = 'ДФ=''d MMMM yyyy ''''в'''' HH:mm'''; en = 'ДФ=''d MMMM yyyy ''''at'''' HH:mm'''");
	КонецЕсли;
	СтрокаДата = Формат(Дата, ФорматнаяСтрока);
	
	Возврат СтрокаДата;
	
КонецФункции

#КонецОбласти
