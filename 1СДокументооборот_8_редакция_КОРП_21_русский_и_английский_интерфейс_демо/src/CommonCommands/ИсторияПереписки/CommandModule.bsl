
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура("Документ", ПараметрКоманды);
	ОткрытьФорму("ОбщаяФорма.ИсторияПереписки", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры


