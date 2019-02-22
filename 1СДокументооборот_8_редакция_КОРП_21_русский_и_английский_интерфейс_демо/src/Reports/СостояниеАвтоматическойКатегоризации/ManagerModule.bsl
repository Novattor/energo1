
#Область НастройкиОтчетаПоУмолчанию

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	Если КлючВариантаОтчета = "СтатусПроцесса" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Администрирование);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
		СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.НастройкаИАдминистрирование));
		
		СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.НСИ));

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


