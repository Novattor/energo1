#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("Документ") Тогда
		ВызватьИсключение НСтр("ru = 'Отсутствует обязательный параметр открытия формы <Документ>.'; en = 'Parameter <Документ> requred for the form opening is missing.'");
	КонецЕсли;
	
	Документ = Параметры.Документ;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Документ", Документ,
		ВидСравненияКомпоновкиДанных.Равно, , Истина);
	
	ПоказыватьУдаленныеРезолюции = 
		Параметры.Свойство("ПоказыватьУдаленныеРезолюции")
		И Параметры.ПоказыватьУдаленныеРезолюции;
	
	Если Не ПоказыватьУдаленныеРезолюции Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
