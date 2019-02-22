
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем ОбновитьДанныеЛичногоАдресатаВАдреснойКниге;
Перем ОбновитьДанныеОтображенияЛичногоАдресатаВАдреснойКниге;
Перем ОбновитьСловаПоискаЛичногоАдресатаВАдреснойКниге;
Перем ОбновитьДоступностьВПоискеПоЛичномуАдресату;

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Обновление адресной книги
	ОбновитьДанныеЛичногоАдресатаВАдреснойКниге = Ложь;
	ОбновитьДанныеОтображенияЛичногоАдресатаВАдреснойКниге = Ложь;
	ОбновитьСловаПоискаЛичногоАдресатаВАдреснойКниге = Ложь;
	ОбновитьДоступностьВПоискеПоЛичномуАдресату = Ложь;
	Если ЭтоНовый() Тогда
		ОбновитьДанныеЛичногоАдресатаВАдреснойКниге = Истина;
		ОбновитьСловаПоискаЛичногоАдресатаВАдреснойКниге = Истина;
	Иначе
		РеквизитыГруппыПоСсылке = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
			"Наименование, Группа, ПометкаУдаления, КонтактнаяИнформация");
			
		Если РеквизитыГруппыПоСсылке.Группа <> Группа Тогда
			ОбновитьДанныеЛичногоАдресатаВАдреснойКниге = Истина;
		КонецЕсли;
		Если РеквизитыГруппыПоСсылке.ПометкаУдаления <> ПометкаУдаления Тогда
			ОбновитьДанныеЛичногоАдресатаВАдреснойКниге = Истина;
			ОбновитьДанныеОтображенияЛичногоАдресатаВАдреснойКниге = Истина;
			ОбновитьДоступностьВПоискеПоЛичномуАдресату = Истина;
		КонецЕсли;
		
		Если РеквизитыГруппыПоСсылке.Наименование <> Наименование Тогда
			ОбновитьСловаПоискаЛичногоАдресатаВАдреснойКниге = Истина;
			ОбновитьДанныеОтображенияЛичногоАдресатаВАдреснойКниге = Истина;
			ОбновитьДанныеЛичногоАдресатаВАдреснойКниге = Истина;
		КонецЕсли;
		Если НЕ ОбновитьСловаПоискаЛичногоАдресатаВАдреснойКниге Тогда
			СтараяКонтактнаяИнформация = РеквизитыГруппыПоСсылке.
				КонтактнаяИнформация.Выгрузить().ВыгрузитьКолонку("Представление");
			НоваяКонтактнаяИнформация = КонтактнаяИнформация.Выгрузить().ВыгрузитьКолонку("Представление");
			Для Каждого СтрИнфо ИЗ НоваяКонтактнаяИнформация Цикл
				Если СтараяКонтактнаяИнформация.Найти(СтрИнфо) = Неопределено Тогда
					ОбновитьСловаПоискаЛичногоАдресатаВАдреснойКниге = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НЕ ОбновитьСловаПоискаЛичногоАдресатаВАдреснойКниге Тогда
				Для Каждого СтрИнфо ИЗ СтараяКонтактнаяИнформация Цикл
					Если НоваяКонтактнаяИнформация.Найти(СтрИнфо) = Неопределено Тогда
						ОбновитьСловаПоискаЛичногоАдресатаВАдреснойКниге = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Обновление адресной книги
	Если ОбновитьДанныеЛичногоАдресатаВАдреснойКниге Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОбъекта(
			Ссылка, Группа, Справочники.АдреснаяКнига.ЛичныеАдресаты, Пользователь);
	КонецЕсли;
	Если ОбновитьДанныеОтображенияЛичногоАдресатаВАдреснойКниге Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОтображенияПодчиненногоОбъекта(Ссылка);
	КонецЕсли;
	Если ОбновитьСловаПоискаЛичногоАдресатаВАдреснойКниге Тогда
		РегистрыСведений.ПоискВАдреснойКниге.ОбновитьСловаПоискаПоЛичномуАдресату(ЭтотОбъект);
	КонецЕсли;
	Если ОбновитьДоступностьВПоискеПоЛичномуАдресату Тогда
		РегистрыСведений.ПоискВАдреснойКниге.ОбновитьДоступностьВПоиске(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
