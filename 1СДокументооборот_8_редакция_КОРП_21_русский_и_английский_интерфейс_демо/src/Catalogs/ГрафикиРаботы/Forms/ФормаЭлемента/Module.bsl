#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// рабочее время
	Для Инд = 1 По Объект.РабочееВремя.Количество() Цикл
		ЭтаФорма["ВремяНачала"+Инд] = Объект.РабочееВремя[Инд-1].ВремяНачала;
		ЭтаФорма["ВремяОкончания"+Инд] = Объект.РабочееВремя[Инд-1].ВремяОкончания;
	КонецЦикла;	
	
	// особое рабочее время
	ТаблОсобоеРабочееВремя = Объект.ОсобоеРабочееВремя.Выгрузить();
	ТаблОсобоеРабочееВремя.Свернуть("РабочийДень");
	
	ОсобоеРабочееВремя.Загрузить(ТаблОсобоеРабочееВремя);
	Для Каждого Строка Из ОсобоеРабочееВремя Цикл
		ОтборСтрок = Новый Структура("РабочийДень", Строка.РабочийДень);
		НайденныеСтроки = Объект.ОсобоеРабочееВремя.НайтиСтроки(ОтборСтрок);
		
		Для Инд = 1 По НайденныеСтроки.Количество() Цикл
			Строка["ВремяНачалаОсобое"+Инд] = НайденныеСтроки[Инд-1].ВремяНачала;
			Строка["ВремяОкончанияОсобое"+Инд] = НайденныеСтроки[Инд-1].ВремяОкончания;
		КонецЦикла;	
	КонецЦикла;	
	
	Если ОсобоеРабочееВремя.Количество() = 0 Тогда 
		Элементы.ГруппаВремя.ТолькоПросмотр = Истина;
	Иначе
		Элементы.ГруппаВремя.ТолькоПросмотр = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьРабочееВремя(Отказ);
	
	ПроверитьОсобоеРабочееВремя(Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.РабочееВремя.Очистить();
	Для Инд = 1 по 4 Цикл
		Если ЗначениеЗаполнено(ЭтаФорма["ВремяОкончания"+Инд]) Тогда 
			НоваяСтрока = Объект.РабочееВремя.Добавить();
			НоваяСтрока.ВремяНачала = ЭтаФорма["ВремяНачала"+Инд];
			НоваяСтрока.ВремяОкончания = ЭтаФорма["ВремяОкончания"+Инд];
		КонецЕсли;
	КонецЦикла;	
	
	Объект.ОсобоеРабочееВремя.Очистить();
	Для Каждого Строка Из ОсобоеРабочееВремя Цикл
		Для Инд = 1 По 4 Цикл
			Если ЗначениеЗаполнено(Строка["ВремяОкончанияОсобое"+Инд]) Тогда 
				НоваяСтрока = Объект.ОсобоеРабочееВремя.Добавить();
				НоваяСтрока.РабочийДень = Строка.РабочийДень;
				НоваяСтрока.ВремяНачала = Строка["ВремяНачалаОсобое"+Инд];
				НоваяСтрока.ВремяОкончания = Строка["ВремяОкончанияОсобое"+Инд];
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОсобоеРабочееВремяПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ОсобоеРабочееВремя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Элементы.ГруппаВремя.ТолькоПросмотр = Истина;
		Возврат;
	Иначе	
		Элементы.ГруппаВремя.ТолькоПросмотр = Ложь;
	КонецЕсли;	
	
	Для Инд = 1 По 4 Цикл
		ЭтаФорма["ВремяНачалаОсобое"+Инд] = ТекущиеДанные["ВремяНачалаОсобое"+Инд];
		ЭтаФорма["ВремяОкончанияОсобое"+Инд] = ТекущиеДанные["ВремяОкончанияОсобое"+Инд];
	КонецЦикла;	
		
КонецПроцедуры

&НаКлиенте
Процедура ВремяОсобоеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОсобоеРабочееВремя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Для Инд = 1 По 4 Цикл
		ТекущиеДанные["ВремяНачалаОсобое"+Инд] = ЭтаФорма["ВремяНачалаОсобое"+Инд];
		ТекущиеДанные["ВремяОкончанияОсобое"+Инд] = ЭтаФорма["ВремяОкончанияОсобое"+Инд];
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьРабочееВремя(Отказ)
	
	НетЗаполненныхЗначений = Истина;
	Для Инд = 1 По 4 Цикл
		Если ЗначениеЗаполнено(ЭтаФорма["ВремяНачала" + Инд]) Или ЗначениеЗаполнено(ЭтаФорма["ВремяОкончания" + Инд]) Тогда 
			НетЗаполненныхЗначений = Ложь;
		КонецЕсли;	
	КонецЦикла;	
	Если НетЗаполненныхЗначений Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указано ни одного интервала времени'; en = 'Time intervals are not specified'"),,"ВремяНачала1",,Отказ);
		Возврат;	
	КонецЕсли;	
	
	Для Инд = 1 По 4 Цикл
		Если ЗначениеЗаполнено(ЭтаФорма["ВремяНачала" + Инд]) И Не ЗначениеЗаполнено(ЭтаФорма["ВремяОкончания" + Инд]) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заполнено поле ""По""'; en = 'Field ""To"" is not filled in'"),,"ВремяОкончания"+Инд,,Отказ);
			Возврат;	
		КонецЕсли;
	КонецЦикла;
	
	Для Инд = 1 По 4 Цикл
		Если ЗначениеЗаполнено(ЭтаФорма["ВремяОкончания" + Инд]) И ЭтаФорма["ВремяНачала" + Инд] >= ЭтаФорма["ВремяОкончания" + Инд] Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Время окончания меньше времени начала'; en = 'End time is less than start time'"),,"ВремяОкончания" + Инд,,Отказ);
			Возврат;	
		КонецЕсли;	
	КонецЦикла;	
	
	Для Инд1 = 1 По 3 Цикл
		Для Инд2 = Инд1 + 1 По 4 Цикл
			Если ЗначениеЗаполнено(ЭтаФорма["ВремяОкончания" + Инд1]) И ЗначениеЗаполнено(ЭтаФорма["ВремяОкончания" + Инд2]) Тогда 
				Если ГрафикиРаботы.ИнтервалыПересекаются(
						ЭтаФорма["ВремяНачала"+Инд1], 
						ЭтаФорма["ВремяОкончания"+Инд1], 
						ЭтаФорма["ВремяНачала"+Инд2], 
						ЭтаФорма["ВремяОкончания"+Инд2]) 
					Тогда 
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Интервалы времени (%1, %2) и (%3, %4) пересекаются'; en = 'Time intervals (%1, %2) and (%3, %4) are overlapping'"),
							Формат(ЭтаФорма["ВремяНачала"+Инд1],	"ДФ=ЧЧ:мм; ДП=00:00"),
							Формат(ЭтаФорма["ВремяОкончания"+Инд1], "ДФ=ЧЧ:мм; ДП=00:00"), 
							Формат(ЭтаФорма["ВремяНачала"+Инд2],	"ДФ=ЧЧ:мм; ДП=00:00"), 
							Формат(ЭтаФорма["ВремяОкончания"+Инд2], "ДФ=ЧЧ:мм; ДП=00:00")));
						Отказ = Истина;	
					Возврат;
				КонецЕсли;	
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Процедура ПроверитьОсобоеРабочееВремя(Отказ)
	
	Для Каждого Строка Из ОсобоеРабочееВремя Цикл
		ИдентификаторСтроки = Строка.ПолучитьИдентификатор();
		
		Если Не ЗначениеЗаполнено(Строка.РабочийДень) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не указан день с особым рабочим временем'; en = 'The day with special working time is not specified'"),,"ОсобоеРабочееВремя["+ОсобоеРабочееВремя.Индекс(Строка)+"].РабочийДень",,Отказ);
			Возврат;	
		КонецЕсли;
		
		НетЗаполненныхЗначений = Истина;
		Для Инд = 1 По 4 Цикл
			Если ЗначениеЗаполнено(Строка["ВремяНачалаОсобое" + Инд]) Или ЗначениеЗаполнено(Строка["ВремяОкончанияОсобое" + Инд]) Тогда 
				НетЗаполненныхЗначений = Ложь;
			КонецЕсли;	
		КонецЦикла;	
		Если НетЗаполненныхЗначений Тогда 
			Элементы.ОсобоеРабочееВремя.ТекущаяСтрока = ИдентификаторСтроки;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указано ни одного интервала времени'; en = 'Time intervals are not specified'"),,"ВремяНачалаОсобое1",,Отказ);
			Возврат;	
		КонецЕсли;	
		
		Для Инд = 1 По 4 Цикл
			Если ЗначениеЗаполнено(Строка["ВремяНачалаОсобое" + Инд]) И Не ЗначениеЗаполнено(Строка["ВремяОкончанияОсобое" + Инд]) Тогда 
				Элементы.ОсобоеРабочееВремя.ТекущаяСтрока = ИдентификаторСтроки;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""По""'; en = 'Field ""To"" is not filled'"),,"ВремяОкончанияОсобое"+Инд,,Отказ);
				Возврат;	
			КонецЕсли;
		КонецЦикла;
		
		Для Инд = 1 По 4 Цикл
			Если ЗначениеЗаполнено(Строка["ВремяОкончанияОсобое" + Инд]) И Строка["ВремяНачалаОсобое" + Инд] >= Строка["ВремяОкончанияОсобое" + Инд] Тогда 
				Элементы.ОсобоеРабочееВремя.ТекущаяСтрока = ИдентификаторСтроки;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Время окончания меньше времени начала'; en = 'End time is less than start time'"),,"ВремяОкончанияОсобое" + Инд,,Отказ);
				Возврат;	
			КонецЕсли;	
		КонецЦикла;	
		
		Для Инд1 = 1 По 3 Цикл
			Для Инд2 = Инд1 + 1 По 4 Цикл
				Если ЗначениеЗаполнено(Строка["ВремяОкончанияОсобое" + Инд1]) И ЗначениеЗаполнено(Строка["ВремяОкончанияОсобое" + Инд2]) Тогда 
					Если ГрафикиРаботы.ИнтервалыПересекаются(
						Строка["ВремяНачалаОсобое"+Инд1], 
						Строка["ВремяОкончанияОсобое"+Инд1], 
						Строка["ВремяНачалаОсобое"+Инд2], 
						Строка["ВремяОкончанияОсобое"+Инд2]) 
					Тогда 
						Элементы.ОсобоеРабочееВремя.ТекущаяСтрока = ИдентификаторСтроки;
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Интервалы времени (%1, %2) и (%3, %4) пересекаются'; en = 'Time intervals (%1, %2) and (%3, %4) are overlapping'"),
							Формат(Строка["ВремяНачалаОсобое"+Инд1],	"ДФ=ЧЧ:мм; ДП=00:00"),
							Формат(Строка["ВремяОкончанияОсобое"+Инд1], "ДФ=ЧЧ:мм; ДП=00:00"), 
							Формат(Строка["ВремяНачалаОсобое"+Инд2],	"ДФ=ЧЧ:мм; ДП=00:00"), 
							Формат(Строка["ВремяОкончанияОсобое"+Инд2], "ДФ=ЧЧ:мм; ДП=00:00")),,"ОсобоеРабочееВремя");
							Отказ = Истина;	
						Возврат;
					КонецЕсли;	
				КонецЕсли;
			КонецЦикла;	
		КонецЦикла;	
		
	КонецЦикла;	
	
КонецПроцедуры	

#КонецОбласти






