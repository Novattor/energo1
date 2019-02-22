
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	СтарыйСрок = Параметры.СрокИсполнения;
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КонтрольИсполнители.Исполнитель
		|ИЗ
		|	Справочник.Контроль.Исполнители КАК КонтрольИсполнители
		|ГДЕ
		|	КонтрольИсполнители.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Параметры.Контроль);
	ТаблицаИсполнителей = Запрос.Выполнить().Выгрузить();
	ЗначениеВРеквизитФормы(ТаблицаИсполнителей, "Исполнители");
	
	Если ЗначениеЗаполнено(СтарыйСрок) Тогда
		НачальныйСрок = СтарыйСрок;
	Иначе 
		НачальныйСрок = ТекущаяДата();
	КонецЕсли;
	
	// Заполнение готовых вариантов контрольных сроков
	СписокВыбора = Элементы.НовыйСрокДата.СписокВыбора;
	Элементы.НовыйСрокДата.СписокВыбора.Добавить(НачальныйСрок + 1*24*3600,			НСтр("ru = '1 день'; en = '1 day'"));
	Элементы.НовыйСрокДата.СписокВыбора.Добавить(НачальныйСрок + 2*24*3600, 		НСтр("ru = '2 дня'; en = '2 days'"));	
	Элементы.НовыйСрокДата.СписокВыбора.Добавить(НачальныйСрок + 3*24*3600, 		НСтр("ru = '3 дня'; en = '3 days'"));	
	Элементы.НовыйСрокДата.СписокВыбора.Добавить(НачальныйСрок + 7*24*3600, 		НСтр("ru = 'Неделя'; en = 'Week'"));
	Элементы.НовыйСрокДата.СписокВыбора.Добавить(ДобавитьМесяц(НачальныйСрок, 1), 	НСтр("ru = 'Месяц'; en = 'Month'"));
	
	// Новый срок по умолчанию
	Если ЗначениеЗаполнено(СтарыйСрок) Тогда
		НовыйСрок = СтарыйСрок + 24*3600;
		ДлительностьПереноса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("(+ %1)",
			ДелопроизводствоКлиентСервер.РазностьДатВДнях(НовыйСрок, СтарыйСрок));
	Иначе 
		НовыйСрок = ТекущаяДата() + 24*3600;
	КонецЕсли;
	
	ПроверятьОтсутствие = Отсутствия.ПредупреждатьОбОтсутствии();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НовыйСрокДатаПриИзменении(Элемент)

	Если ЗначениеЗаполнено(НовыйСрок) И ЗначениеЗаполнено(СтарыйСрок) Тогда
		Если СтарыйСрок < НовыйСрок Тогда 
			ДлительностьПереноса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("(+ %1)",
				ДелопроизводствоКлиентСервер.РазностьДатВДнях(НовыйСрок, СтарыйСрок));
		Иначе 
			ДлительностьПереноса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("(- %1)",
				ДелопроизводствоКлиентСервер.РазностьДатВДнях(СтарыйСрок, НовыйСрок));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиИЗакрыть(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПеренестиИЗакрытьЗавершение", ЭтотОбъект);
	Если Не ОтсутствияКлиент.ПроверитьОтсутствиеПоКонтролю(ЭтаФорма,
			Исполнители, НовыйСрок, ОписаниеОповещения) Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиИЗакрытьЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура();
	ПараметрыОповещения.Вставить("НовыйСрок", НовыйСрок);
	ПараметрыОповещения.Вставить("СтарыйСрок", СтарыйСрок);
	
	Закрыть(ПараметрыОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
