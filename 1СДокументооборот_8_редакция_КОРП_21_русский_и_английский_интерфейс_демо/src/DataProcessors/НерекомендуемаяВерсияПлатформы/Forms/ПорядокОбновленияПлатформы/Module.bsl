
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	БазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	Если БазаФайловая Тогда
		МакетПорядокОбновления = Обработки.НерекомендуемаяВерсияПлатформы.ПолучитьМакет("ПорядокОбновленияДляФайловойБазы");
	Иначе
		МакетПорядокОбновления = Обработки.НерекомендуемаяВерсияПлатформы.ПолучитьМакет("ПорядокОбновленияДляКлиентСервернойБазы");
	КонецЕсли;
	
	ПорядокОбновленияПрограммы = МакетПорядокОбновления.ПолучитьТекст();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПорядокОбновленияПрограммыПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	Если ДанныеСобытия.Href <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		ПерейтиПоНавигационнойСсылке(ДанныеСобытия.Href);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьИнструкции(Команда)
	Элементы.ПорядокОбновленияПрограммы.Документ.execCommand("Print");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПорядокОбновленияПрограммыДокументСформирован(Элемент)
	
	Если Не Элемент.Документ.queryCommandSupported("Print") Тогда
		Элементы.ПечатьИнструкции.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
