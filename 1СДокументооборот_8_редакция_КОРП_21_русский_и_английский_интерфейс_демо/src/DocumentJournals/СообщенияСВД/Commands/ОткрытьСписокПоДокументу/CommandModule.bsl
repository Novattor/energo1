
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Документ", ПараметрКоманды);
	НаСервере(ПараметрКоманды);
	ОткрытьФорму("ЖурналДокументов.СообщенияСВД.Форма.ФормаСпискаПоДокументу", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

&НаСервере
Функция НаСервере(Документ)
	
	ОбъектДокумента = Документ.ПолучитьОбъект();
	
КонецФункции


