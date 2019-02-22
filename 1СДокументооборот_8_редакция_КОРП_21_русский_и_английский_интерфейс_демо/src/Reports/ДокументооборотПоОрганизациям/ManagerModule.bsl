
#Область НастройкиОтчетаПоУмолчанию

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.ДокументыИФайлы));
			
	Если КлючВариантаОтчета = "ВходящиеДокументы" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоВходящимДокументам);
		
	ИначеЕсли КлючВариантаОтчета = "ИсходящиеДокументы" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсходящимДокументам);

	ИначеЕсли КлючВариантаОтчета = "ВнутренниеДокументы" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоВнутреннимДокументам);
		
	ИначеЕсли КлючВариантаОтчета = "ЗадачиИсполнителей" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
			
		СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.СовместнаяРабота));
		СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.УправлениеБизнесПроцессами));
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
