#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыПечати = Новый Структура;
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.ТемыОбсуждений", "Карточка", ПараметрКоманды, ПараметрыВыполненияКоманды.Источник, ПараметрыПечати);
	
КонецПроцедуры

#КонецОбласти
