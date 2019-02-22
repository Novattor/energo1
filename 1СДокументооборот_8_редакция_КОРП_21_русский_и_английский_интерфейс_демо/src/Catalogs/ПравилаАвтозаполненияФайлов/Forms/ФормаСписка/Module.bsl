#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ВнутренниеДокументы", НСтр("ru = 'Внутренний документ'; en = 'Internal document'"));
	Список.Параметры.УстановитьЗначениеПараметра("ИсходящиеДокументы", НСтр("ru = 'Исходящий документ'; en = 'Outgoing document'"));
	
	НастройкиФормы = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(ИмяФормы + "/ТекущиеДанные", "");
	Если НастройкиФормы = Неопределено Или НастройкиФормы.Получить("ПоказыватьУдаленные") = Неопределено Тогда
		Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
		УстановитьОтбор();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки["ПоказыватьУдаленные"] <> Неопределено Тогда
		ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
		Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
		УстановитьОтбор();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	УстановитьОтбор();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтбор()
	
	Если Не ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
