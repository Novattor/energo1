
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Контрагент", ПараметрКоманды);
	ОткрытьФорму("Справочник.ДелаХраненияДокументов.Форма.ФормаДелаТомаПоКонтрагенту", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры


