
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Обработчик", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.СвязьПользовательскихОбработчиковБизнесСобытийИВидаСобытий.Форма.ФормаСпискаДляОбработчика", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры


