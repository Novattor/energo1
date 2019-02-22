#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьДанныеПолностью(Команда)
	
	ОбновитьДанныеПолностьюСервер();
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ПользователиВКонтейнерах"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДанныеПолностьюСервер()
	
	РегистрыСведений.ПользователиВКонтейнерах.ОбновитьДанныеПолностью();
	
КонецПроцедуры

#КонецОбласти
