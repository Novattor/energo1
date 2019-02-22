
#Область НастройкиОтчетаПоУмолчанию

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		Метаданные.Подсистемы.СовместнаяРабота));
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		Метаданные.Подсистемы.УправлениеБизнесПроцессами));
	
	Если КлючВариантаОтчета = "СписокТекущихЗадач" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ЗадачиСписок);
		
	ИначеЕсли КлючВариантаОтчета = "СписокИстекающихЗадач" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ЗадачиСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.КонтрольныеОтчеты);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Просроченное);
		
	ИначеЕсли КлючВариантаОтчета = "СписокМоихИстекающихЗадач" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ЗадачиМнеСписок);
	
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.КонтрольныеОтчеты);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Просроченное);
		
	ИначеЕсли КлючВариантаОтчета = "СписокИстекающихЗадачПодчиненных" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ЗадачиОтделаСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Просроченное);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.КонтрольныеОтчеты);
		
	ИначеЕсли КлючВариантаОтчета = "СписокНарушенийСроков" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ЗадачиСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Просроченное);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		
	ИначеЕсли КлючВариантаОтчета = "СтатистикаКоличестваЗадач" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "СписокВсехЗадач" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ЗадачиСписок);
	
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		
	ИначеЕсли КлючВариантаОтчета = "СписокНепринятыхЗадач" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ЗадачиСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.КонтрольныеОтчеты);
		
	ИначеЕсли КлючВариантаОтчета = "СписокМоихНепринятыхЗадач" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ЗадачиМнеСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.КонтрольныеОтчеты);
		
	ИначеЕсли КлючВариантаОтчета = "СписокНепринятыхЗадачПодчиненными" Тогда
		 СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ЗадачиОтделаСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.КонтрольныеОтчеты);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		
	ИначеЕсли КлючВариантаОтчета = "СтатистикаДлительностиПринятияКИсполнению" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


