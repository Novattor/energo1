
#Область НастройкиОтчетаПоУмолчанию

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.ДокументыИФайлы));
	
	Если КлючВариантаОтчета = "СправкаОбОбъемеДокументооборота" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоДокументам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


