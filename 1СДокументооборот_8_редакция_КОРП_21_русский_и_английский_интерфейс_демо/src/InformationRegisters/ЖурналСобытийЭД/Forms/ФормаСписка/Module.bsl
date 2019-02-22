
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЭлектронноеВзаимодействиеПереопределяемый.ЕстьПравоОткрытияЖурналаРегистрации() Тогда
		ТекстСообщения = НСтр("ru = 'Недостаточно прав для просмотра журнала регистрации.'; en = 'Insufficient permissions to view the log.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
