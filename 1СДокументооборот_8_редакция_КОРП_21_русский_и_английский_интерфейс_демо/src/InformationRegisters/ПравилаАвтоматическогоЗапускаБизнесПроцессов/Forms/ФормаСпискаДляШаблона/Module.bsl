
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор,
		"ШаблонБизнесПроцесса",
		Параметры.ШаблонБизнесПроцесса);
	
КонецПроцедуры


