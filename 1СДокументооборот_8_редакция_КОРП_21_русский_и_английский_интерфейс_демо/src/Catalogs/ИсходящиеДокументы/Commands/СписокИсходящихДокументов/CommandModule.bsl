
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	КлючеваяОперация = "ИсходящиеДокументыОткрытиеФормыФормаСписка";
	УИДЗамера = ОценкаПроизводительностиКлиентСервер.НачатьРучнойЗамерВремени(КлючеваяОперация);
	
	Форма = ПолучитьФорму("Справочник.ИсходящиеДокументы.ФормаСписка", , ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	Если Форма.Открыта() Тогда 
		Форма.Активизировать();
		Возврат;
	КонецЕсли;
	Форма.Открыть();
	
	ОценкаПроизводительностиКлиентСервер.ЗакончитьРучнойЗамерВремени(УИДЗамера);
	
КонецПроцедуры


