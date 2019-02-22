&НаКлиенте
Процедура УстановитьПараметрыИспользования(СтруктураПараметров) Экспорт
	
	Параметры.ФайлСсылка = СтруктураПараметров.ФайлСсылка;
	КомментарийКВерсии = СтруктураПараметров.КомментарийКВерсии;
	Файл = СтруктураПараметров.ФайлСсылка;
	СоздатьНовуюВерсию = СтруктураПараметров.СоздатьНовуюВерсию;

КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Файл = Параметры.ФайлСсылка;
	
	Если ЗначениеЗаполнено(Файл) Тогда
		
		ХранитьВерсии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Файл, "ХранитьВерсии");
		СоздатьНовуюВерсию = ХранитьВерсии;
		
	КонецЕсли;	
	
КонецПроцедуры


&НаКлиенте
Процедура ОК(Команда)
	СтруктураВозврата = Новый Структура("КомментарийКВерсии, СоздатьНовуюВерсию, КодВозврата", 
		КомментарийКВерсии, СоздатьНовуюВерсию, КодВозвратаДиалога.ОК);
	Закрыть(СтруктураВозврата);
КонецПроцедуры


&НаКлиенте
Процедура Отмена(Команда)
	СтруктураВозврата = Новый Структура("КомментарийКВерсии, СоздатьНовуюВерсию, КодВозврата", 
		КомментарийКВерсии, СоздатьНовуюВерсию, КодВозвратаДиалога.Отмена);
	Закрыть(СтруктураВозврата);
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ОбработчикЗакрытьФорму", 60 * 5, Истина);  
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикЗакрытьФорму()

	СтруктураВозврата = Новый Структура("КомментарийКВерсии, СоздатьНовуюВерсию, КодВозврата", 
		КомментарийКВерсии, СоздатьНовуюВерсию, КодВозвратаДиалога.ОК);
	Закрыть(СтруктураВозврата);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("ОбработчикЗакрытьФорму");
	
КонецПроцедуры


