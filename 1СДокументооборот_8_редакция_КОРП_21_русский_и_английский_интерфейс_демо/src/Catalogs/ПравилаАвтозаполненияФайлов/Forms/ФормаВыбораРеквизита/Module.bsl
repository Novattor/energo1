
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Дерево = АвтозаполнениеШаблоновФайловСерверПовтИсп.ЗаполнитьДеревоРеквизитовДляВыбора(
		Параметры.ВладелецФайла,
		Параметры.ТипДокумента);	
	ЗначениеВРеквизитФормы(Дерево, "ОбъектДеревоРеквизитов");	
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоРеквизитовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьВыборЭлемента(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоРеквизитовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьВыборЭлемента(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборЭлемента(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Тип) Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементДерева = ОбъектДеревоРеквизитов.НайтиПоИдентификатору(Элемент.ТекущаяСтрока);
	Если ЭлементДерева <> Неопределено Тогда
		Если ЗначениеЗаполнено(ЭлементДерева.ОбъектРодитель) Тогда
			ОповеститьОВыборе(Элемент.ТекущиеДанные);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры


