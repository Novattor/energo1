#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьУчетПоОрганизациям = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям");
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Кому назначен шаблон ""%1""'; en = 'Template ""%1"" assigned to'"),
		Строка(Параметры.ШаблонБизнесПроцесса));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор,
		"ШаблонБизнесПроцесса",
		Параметры.ШаблонБизнесПроцесса);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ТекущийШаблонБизнесПроцесса = Элемент.ТекущиеДанные.ШаблонБизнесПроцесса; 
		ТекущийВидДокумента = Элемент.ТекущиеДанные.ВидДокумента; 
		Если ИспользоватьУчетПоОрганизациям Тогда
			ТекущаяОрганизация = Элемент.ТекущиеДанные.Организация;
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	
	УдалитьПодпискиНаБизнесСобытия(
		ТекущийШаблонБизнесПроцесса, 
		ТекущийВидДокумента, 
		ТекущаяОрганизация);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УдалитьПодпискиНаБизнесСобытия(ШаблонБизнесПроцесса, ВидДокумента, Организация)
	
	МассивВидовБизнесСобытий = БизнесСобытияВызовСервера.ПолучитьБизнесСобытияПоВидуДокумента(ВидДокумента);
	Для Каждого ВидСобытия Из МассивВидовБизнесСобытий Цикл
		
		БизнесСобытияВызовСервера.УдалитьПравилоАвтоматическогоЗапускаБизнесПроцессов(
			ВидСобытия, ШаблонБизнесПроцесса, ВидДокумента, Организация);
		
	КонецЦикла;	
		
КонецПроцедуры

#КонецОбласти
