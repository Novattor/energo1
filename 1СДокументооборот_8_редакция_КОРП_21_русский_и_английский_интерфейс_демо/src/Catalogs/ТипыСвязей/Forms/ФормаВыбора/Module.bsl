
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Заголовок") И ЗначениеЗаполнено(Параметры.Заголовок) Тогда 
		ЭтаФорма.Заголовок = Параметры.Заголовок;
		ЭтаФорма.АвтоЗаголовок = Ложь;
	КонецЕсли;
	
КонецПроцедуры


