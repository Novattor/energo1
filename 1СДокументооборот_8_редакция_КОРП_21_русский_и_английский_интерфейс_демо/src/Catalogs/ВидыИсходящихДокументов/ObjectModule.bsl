#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	ВключенУчетПоНоменклатуреДел = ВестиУчетПоНоменклатуреДел И Константы.ИспользоватьНоменклатуруДел.Получить();
	
	// Подсистема Свойства
	УправлениеСвойствами.ПередЗаписьюВидаОбъекта(ЭтотОбъект, "Справочник_ИсходящиеДокументы");
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ПредыдущаяПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления");
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда 
		Если ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Ссылка).Удаление Тогда 
			ШаблоныДокументов.ПометитьНаУдалениеШаблоныДокументов(Ссылка, ПометкаУдаления);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У вас нет права ""Пометка на удаление"" вида документа ""%1"".'; en = 'You have no ""Mark for deletion"" permission for ""%1"" document type.'"),
				Строка(Ссылка));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	НаборСвойств = Неопределено;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ДокументооборотПраваДоступа.ПриЗаписиРазрезаДоступа(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецЕсли
