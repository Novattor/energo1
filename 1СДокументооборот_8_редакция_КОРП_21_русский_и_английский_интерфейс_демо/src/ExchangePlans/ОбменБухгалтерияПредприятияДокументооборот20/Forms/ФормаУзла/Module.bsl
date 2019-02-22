#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ДокументооборотИспользоватьОграничениеПравДоступа") Тогда
		
		Элементы.ГруппаСтраницыНастроек.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ОграничиватьВыгрузкуОрганизациями = 
		ТекущийОбъект.Организации.Количество() <> 0;
	ТекущийОбъект.ВыгружатьДоговоры = 
		ТекущийОбъект.Договоры.Количество() <> 0;
	ТекущийОбъект.ВыгружатьЗаявкиНаОплату = 
		ТекущийОбъект.ЗаявкиНаОплату.Количество() <> 0;
	
КонецПроцедуры


&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

#КонецОбласти
