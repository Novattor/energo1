#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ЗначениеЗаполнено(ФайлОбработкиИмя) Или Не ЗначениеЗаполнено(ФайлОбработкиАдрес) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Укажите файл внешнего отчета или обработки'; en = 'Specify an external file or report processing'"), , "ФайлОбработкиАдрес");
		Отказ = Истина;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(БезопасныйРежим) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Укажите безопасный режим для подключения внешнего модуля'; en = 'Specify safe mode for connecting an external module'"), , "БезопасныйРежим");
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовУправленияФормы

&НаКлиенте
Процедура ФайлОбработкиИмяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Истина;
	
	Оповещение = Новый ОписаниеОповещения("ФайлОбработкиИмяНачалоВыбораПослеПомещенияФайла", ЭтотОбъект);
	НачатьПомещениеФайла(Оповещение, , , Истина, ЭтотОбъект.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлОбработкиИмяНачалоВыбораПослеПомещенияФайла(Результат, Адрес, ВыбранноеИмяФайла, Контекст) Экспорт
	
	Если Результат Тогда
		
		ФайлОбработкиИмя = ВыбранноеИмяФайла;
		ФайлОбработкиАдрес = Адрес;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлОбработкиИмяОчистка(Элемент, СтандартнаяОбработка)
	
	УдалитьИзВременногоХранилища(ФайлОбработкиАдрес);
	
	ФайлОбработкиАдрес = "";
	ФайлОбработкиИмя = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодключитьИОткрыть(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		Имя = ПодключитьНаСервере();
		
		Расширение = Прав(НРег(СокрЛП(ФайлОбработкиИмя)), 3);
		
		Если Расширение = "epf" Тогда
			
			ИмяФормыВнешнегоМодуля = "ВнешняяОбработка." + Имя + ".Форма";
			
		Иначе
			
			ИмяФормыВнешнегоМодуля = "ВнешнийОтчет." + Имя + ".Форма";
			
		КонецЕсли;
		
		ОткрытьФорму(ИмяФормыВнешнегоМодуля, , ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодключитьНаСервере()
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.'; en = 'Not enough permissions.'");
	КонецЕсли;
	
	Расширение = Прав(НРег(СокрЛП(ФайлОбработкиИмя)), 3);
	
	Если Расширение = "epf" Тогда
		
		Менеджер = ВнешниеОбработки;
		
	ИначеЕсли Расширение = "erf" Тогда
		
		Менеджер = ВнешниеОтчеты;
		
	Иначе
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Файл %1 не является файлом внешнего отчета или обработки'; en = 'File %1 is not an external report or processing'"), ФайлОбработкиИмя);
		
	КонецЕсли;
	
	Имя = Менеджер.Подключить(ФайлОбработкиАдрес, , БезопасныйРежим);
	
	Возврат Имя;
	
КонецФункции

#КонецОбласти
