#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		
		КлючНазначенияИспользования = "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		Элементы.Список.РежимВыбора = Истина;
		
		Заголовок = НСтр("ru = 'Выбор пункта протокола'; en = 'Minutes item choice'");
		АвтоЗаголовок = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборМероприятиеПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтбор()
	
	ПараметрыОтбора = Новый Соответствие();
	Параметрыотбора.Вставить("Владелец", ОтборМероприятие);
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	УстановитьОтборСпискаПоПараметру(Список.Параметры, "Владелец", ПараметрыОтбора["Владелец"]);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСпискаПоПараметру(ПараметрыСписка, ИмяПараметра, Значение)
	
	Параметр = ПараметрыСписка.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Параметр.Использование = Ложь;
	Если ЗначениеЗаполнено(Значение) Тогда
		ПараметрыСписка.УстановитьЗначениеПараметра(ИмяПараметра, Значение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
