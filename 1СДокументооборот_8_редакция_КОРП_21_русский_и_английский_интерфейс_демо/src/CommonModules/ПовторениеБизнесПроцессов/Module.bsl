
////////////////////////////////////////////////////////////////////////////////
// Повторение бизнес процессов: содержит серверные процедуры и функции механизма
//                              повторение процессов
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет формирование бизнес-процессов из регламентного задания 
Процедура ПовторениеБизнесПроцессовПоРасписанию() Экспорт 
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПовторениеБизнесПроцессов") Тогда 
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкаПовторенияБизнесПроцессов.БизнесПроцесс,
		|	НастройкаПовторенияБизнесПроцессов.Расписание,
		|	НастройкаПовторенияБизнесПроцессов.ДатаПоследнегоПовторения,
		|	НастройкаПовторенияБизнесПроцессов.ГрафикРаботы
		|ИЗ
		|	РегистрСведений.НастройкаПовторенияБизнесПроцессов КАК НастройкаПовторенияБизнесПроцессов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
		|		ПО НастройкаПовторенияБизнесПроцессов.БизнесПроцесс = ДанныеБизнесПроцессов.БизнесПроцесс
		|ГДЕ
		|	НЕ НастройкаПовторенияБизнесПроцессов.ПовторениеЗавершено
		|	И ДанныеБизнесПроцессов.УзелОбмена = &УзелОбмена";
		
	ЭтотУзелОбмена = РаботаСБизнесПроцессами.ЭтотУзелОбменаДляОбработкиПроцессов();
	Запрос.УстановитьПараметр("УзелОбмена", ЭтотУзелОбмена);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТекущаяДата = ТекущаяДатаСеанса();
		
		ДатыДляПроверкиРасписания = Новый Массив;
		ДатыДляПроверкиРасписания.Добавить(ТекущаяДата);
		
		Расписание = Выборка.Расписание.Получить();
		
		Если ЗначениеЗаполнено(Выборка.ГрафикРаботы)
			И ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы") Тогда
			
			Если Не ГрафикиРаботы.ЭтоРабочаяДатаВремя(Выборка.ГрафикРаботы, ТекущаяДата) Тогда
				Продолжить;
				
			Иначе
				
				// Если текущий день является первым рабочим после выходных,
				// то добавляем для проверки все предыдущие выходные дни.
				// Это нужно, чтобы стартовать периодические процессы,
				// старт которых выпал на выходной день.
				
				НерабочийДень = ТекущаяДата - 86400;
				
				Пока Не ГрафикиРаботы.ЭтоРабочаяДатаВремя(Выборка.ГрафикРаботы, НерабочийДень) Цикл
					ДатыДляПроверкиРасписания.Добавить(НерабочийДень);
					НерабочийДень = НерабочийДень - 86400;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
		ВыполнитьПовторение = Ложь;
		
		Для Каждого ПроверяемаяДата Из ДатыДляПроверкиРасписания Цикл
			Если Расписание.ТребуетсяВыполнение(ПроверяемаяДата, Выборка.ДатаПоследнегоПовторения) Тогда
				ВыполнитьПовторение = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ВыполнитьПовторение Тогда
			
			Результат = ПовторитьБизнесПроцесс(ТекущаяДата, Выборка.БизнесПроцесс);
			
			Если Результат Тогда 
				МенеджерЗаписи = РегистрыСведений.НастройкаПовторенияБизнесПроцессов.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.БизнесПроцесс = Выборка.БизнесПроцесс;
				МенеджерЗаписи.Прочитать();
				МенеджерЗаписи.ДатаПоследнегоПовторения = ТекущаяДата;
				МенеджерЗаписи.Записать();
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Расписание.ДатаКонца) И ТекущаяДата > Расписание.ДатаКонца Тогда 
			МенеджерЗаписи = РегистрыСведений.НастройкаПовторенияБизнесПроцессов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.БизнесПроцесс = Выборка.БизнесПроцесс;
			МенеджерЗаписи.Прочитать();
			МенеджерЗаписи.ПовторениеЗавершено = Истина;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает представление расписания в удобном для чтения виде
//
// Параметры:
//   Расписание - РасписаниеРегламентногоЗадания - расписание повторения процесса
//   ГрафикРаботы - СправочникСсылка.ГрафикиРаботы - график работы по которому происходит
//                  повторение процесса
//
// Возвращаемое значение:
//   Строка
//
Функция ПолучитьПредставлениеРасписания(Знач Расписание, ГрафикРаботы) Экспорт
	
	Если Расписание = Неопределено Тогда 
		Возврат НСтр("ru = 'Расписание не задано'; en = 'Schedule is not set'");
	КонецЕсли;	
	
	ПредставлениеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполнять с %1'; en = 'Execute from %1'"),
		Формат(Расписание.ДатаНачала, "ДФ=dd.MM.yyyy"));
	
	Если ЗначениеЗаполнено(Расписание.ДатаКонца) Тогда 
		ПредставлениеРасписания = ПредставлениеРасписания + 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = ' по %1'; en = ' by %1'"),
			Формат(Расписание.ДатаКонца, "ДФ=dd.MM.yyyy"));
	КонецЕсли;
	
	ПредставлениеРасписания = ПредставлениеРасписания + 
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = ' в %1'; en = ' in %1'"), 
		Формат(Расписание.ВремяНачала, "ДФ=ЧЧ:мм; ДП=00:00"));
	
	Если Расписание.ДниНедели.Количество() > 0 Тогда  
		
		Если Расписание.ПериодНедель = 1 Тогда
			ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = ' еженедельно в '; en = ' weekly in '");
		Иначе
			ПредставлениеНедель = ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
				Расписание.ПериодНедель, 
				НСтр("ru = 'неделю'; en = 'week'") + "," + НСтр("ru = 'недели'; en = 'weeks'") + "," + НСтр("ru = 'недель'; en = 'weeks'"));
			
			ПредставлениеКаждый = ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
				Расписание.ПериодНедель,
				НСтр("ru = 'каждую'; en = 'every'") + "," + НСтр("ru = 'каждые'; en = 'every'") + "," + НСтр("ru = 'каждые'; en = 'every'"));
				
			ПредставлениеРасписания = ПредставлениеРасписания
				+ " " + ПредставлениеКаждый
				+ " " + Расписание.ПериодНедель
				+ " " + ПредставлениеНедель
				+ НСтр("ru = ' в '; en = ' in '");
			
		КонецЕсли;
		
		Для Каждого ДеньНедели Из Расписание.ДниНедели Цикл
			Если ДеньНедели = 1 Тогда 
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'понедельник, '; en = 'monday, '");
			КонецЕсли;
			Если ДеньНедели = 2 Тогда
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'вторник, '; en = 'tuesday, '");
			КонецЕсли;
			Если ДеньНедели = 3 Тогда
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'среда, '; en = 'wednesday, '");
			КонецЕсли;
			Если ДеньНедели = 4 Тогда
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'четверг, '; en = 'thursday, '");
			КонецЕсли;
			Если ДеньНедели = 5 Тогда
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'пятница, '; en = 'friday, '");
			КонецЕсли;
			Если ДеньНедели = 6 Тогда
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'суббота, '; en = 'saturday, '");
			КонецЕсли;
			Если ДеньНедели = 7 Тогда
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'воскресенье, '; en = 'sunday, '");
			КонецЕсли;
		КонецЦикла;	
		ПредставлениеРасписания = Лев(ПредставлениеРасписания, СтрДлина(ПредставлениеРасписания)-2);
		
	ИначеЕсли Расписание.ДеньВМесяце <> 0 Тогда 
		
		Если Расписание.Месяцы.Количество() > 0 Тогда
			
			ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = ' в '; en = ' in '");
			
			Для Каждого Месяц Из Расписание.Месяцы Цикл
				Если Месяц = 1 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'янв, '; en = 'jan, '");
				КонецЕсли;
				Если Месяц = 2 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'фев, '; en = 'feb, '");
				КонецЕсли;
				Если Месяц = 3 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'мар, '; en = 'mar, '")  КонецЕсли;
				Если Месяц = 4 Тогда ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'апр, '; en = 'apr, '");
				КонецЕсли;
				Если Месяц = 5 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'май, '; en = 'may, '");
				КонецЕсли;
				Если Месяц = 6 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'июн, '; en = 'jun, '");
				КонецЕсли;
				Если Месяц = 7 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'июл, '; en = 'jul, '");
				КонецЕсли;
				Если Месяц = 8 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'авг, '; en = 'aug, '");
				КонецЕсли;
				Если Месяц = 9 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'сен, '; en = 'sep, '");
				КонецЕсли;
				Если Месяц = 10 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'окт, '; en = 'oct, '");
				КонецЕсли;
				Если Месяц = 11 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'ноя, '; en = 'nov, '");
				КонецЕсли;
				Если Месяц = 12 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'дек, '; en = 'dec, '");
				КонецЕсли;
			КонецЦикла;
			
		Иначе
			ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = ' ежемесячно '; en = ' monthly '");
		КонецЕсли;
		
		Если Расписание.ДеньВМесяце > 0 Тогда 
			ПредставлениеРасписания = ПредставлениеРасписания
				+ Строка(Расписание.ДеньВМесяце)
				+ НСтр("ru = '-го числа месяца'; en = '-th day of month'");
		Иначе
			ПредставлениеРасписания = ПредставлениеРасписания
				+ Строка(-Расписание.ДеньВМесяце)
				+ НСтр("ru = '-го дня месяца с конца'; en = '-th day of month from the end'");
		КонецЕсли;
		
	Иначе
		
		Если Расписание.ПериодПовтораДней = 1 Тогда
			ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = ' ежедневно'; en = ' daily'");
		Иначе
		
			ПредставлениеДней = ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
				Расписание.ПериодПовтораДней, 
				НСтр("ru = 'день'; en = 'day'") + "," + НСтр("ru = 'дня'; en = 'days'") + "," + НСтр("ru = 'дней'; en = 'days'"));
			
			ПредставлениеКаждый = ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
				Расписание.ПериодПовтораДней,
				НСтр("ru = 'каждый'; en = 'every'") + "," + НСтр("ru = 'каждые'; en = 'every'") + "," + НСтр("ru = 'каждые'; en = 'every'"));
				
			ПредставлениеРасписания = ПредставлениеРасписания
				+ " " + ПредставлениеКаждый
				+ " " + Расписание.ПериодПовтораДней
				+ " " + ПредставлениеДней;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы")
		И ЗначениеЗаполнено(ГрафикРаботы) Тогда
		
		ОписаниеГрафикаРабот = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = ' по графику работ: ""%1""'; en = ' using work schedule: ""%1""'"),
			ГрафикРаботы);
		ПредставлениеРасписания = ПредставлениеРасписания + ОписаниеГрафикаРабот;
	КонецЕсли;
	
	Возврат ПредставлениеРасписания;
	
КонецФункции	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Создает новый процесс по основанию, от заданной даты.
//
// Параметры:
//   ТекущаяДата - Дата - дата и время создания нового процесса.
//   БизнесПроцессОснование - БизнесПроцессСсылка - ссылка на процесс Основание
//
// Возвращаемое значение:
//   Булево - если процесс создан успешно возвращается Истина, иначе формируется
//            уведомление пользователю, пишется запись в журнал регистрации и
//            возвращается Ложь.
//
Функция ПовторитьБизнесПроцесс(ТекущаяДата, БизнесПроцессОснование)
	
	Результат = Истина;
	ТекстСообщения = "";
	
	НачатьТранзакцию();
	Попытка
		
		НовыйБизнесПроцесс = БизнесПроцессОснование.Скопировать();
		НовыйБизнесПроцесс.Дата = ТекущаяДата;
		НовыйБизнесПроцесс.Автор = БизнесПроцессОснование.Автор;
		
		// Расчет сроков исполнения
		ОбновитьВариантыУстановкиСроков(НовыйБизнесПроцесс);
		СрокиИсполненияПроцессов.РассчитатьСрокИсполненияДляНовогоПроцесса(НовыйБизнесПроцесс);
		
		НовыйБизнесПроцесс.Записать();
		СтартПроцессовСервер.СтартоватьПроцесс(НовыйБизнесПроцесс);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При автоматическом повторении процесса произошла ошибка: %1.'; en = 'During automated process recurrence an error occurred: %1.'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		УровеньВажностиСобытия = УровеньЖурналаРегистрации.Ошибка;
		
		Результат = Ложь;
		
		РаботаСУведомлениями.ОбработатьУведомлениеПрограммы(
			ТекстСообщения,
			БизнесПроцессОснование.Автор,
			БизнесПроцессОснование);
		
	КонецПопытки;
	
	Если ПустаяСтрока(ТекстСообщения) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выполнено повторение процесса. Сформирован новый процесс %1.'; en = 'Process recurrence executed.Generated new process %1.'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			Строка(НовыйБизнесПроцесс));
		УровеньВажностиСобытия = УровеньЖурналаРегистрации.Информация;
	КонецЕсли;	
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Повторение процессов.'; en = 'Process recurrence.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньВажностиСобытия, 
		БизнесПроцессОснование.Метаданные(),
		БизнесПроцессОснование, 
		ТекстСообщения);
		
	Возврат Результат;
	
КонецФункции

// Устанавливает всем срокам процесса вариант установки ОтносительныйСрок
//
// Параметры:
//  Процесс - БизнесПроцессОбъект
//
Процедура ОбновитьВариантыУстановкиСроков(Процесс)
	
	МетаданныеПроцесса = Процесс.Ссылка.Метаданные();
	
	ВариантОтносительныйСрок = 
		Перечисления.ВариантыУстановкиСрокаИсполнения.ОтносительныйСрок;
	
	Если МетаданныеПроцесса.Реквизиты.Найти("ВариантУстановкиСрокаИсполнения") <> Неопределено Тогда
		Процесс.ВариантУстановкиСрокаИсполнения = ВариантОтносительныйСрок;
	КонецЕсли;
	
	Если МетаданныеПроцесса.Реквизиты.Найти("ВариантУстановкиСрокаОбработкиРезультатов") <> Неопределено Тогда
		Процесс.ВариантУстановкиСрокаОбработкиРезультатов = ВариантОтносительныйСрок;
	КонецЕсли;
	
	Если МетаданныеПроцесса.ТабличныеЧасти.Найти("Исполнители") <> Неопределено Тогда
		Для Каждого СтрИсполнитель Из Процесс.Исполнители Цикл
			СтрИсполнитель.ВариантУстановкиСрокаИсполнения = ВариантОтносительныйСрок;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
