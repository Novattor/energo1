
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Нумерация.ПоказатьИндексНумерации(ЭтаФорма);
	
	// Видимость команды "Политики доступа".
	Если Элементы.Найти("ФормаПолитикиДоступа") <> Неопределено Тогда
		ОтключенныеРазрезы = ДокументооборотПраваДоступаПовтИсп.ОтключенныеРазрезыДоступа(Ложь);
		Если ОтключенныеРазрезы.Найти(ПланыВидовХарактеристик.ВидыДоступа.ВопросыДеятельности) <> Неопределено Тогда
			Элементы.ФормаПолитикиДоступа.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'; en = 'Data has been changed. Save changes?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("НетНастройкиНумерации", Нумерация.НетНастройкиНумерации(ТекущийОбъект.Ссылка));
	
	ИндексНумерации = СокрЛП(ИндексНумерации);
	Если ИндексНумерации <> ИндексНумерацииПриОткрытии Тогда 
		Если ЗначениеЗаполнено(ИндексНумерации) Тогда 
			РегистрыСведений.ИндексыНумерации.ЗаписатьИндексНумерации(Объект.Ссылка, ИндексНумерации);
		Иначе 
			РегистрыСведений.ИндексыНумерации.УдалитьИндексНумерации(Объект.Ссылка);
		КонецЕсли;
		
		ИндексНумерацииПриОткрытии = ИндексНумерации;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("НетНастройкиНумерации") 
		И ПараметрыЗаписи.НетНастройкиНумерации = Истина 
		И Не ПараметрыЗаписи.Свойство("ПоказаноПредупреждение") Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПослеЗаписиКлиентПродолжение",
			ЭтотОбъект,
			ПараметрыЗаписи);
		ПоказатьПредупреждение(
		    ОписаниеОповещения,
			НСтр("ru = 'Документы с данным вопросом деятельности нельзя будет зарегистрировать, так как отсутствует подходящая настройка нумерации.'; en = 'Documents of this activity type cannot be registered as corresponding numeration settings are missing.'"));
	КонецЕсли;	
	Если ПараметрыЗаписи.Свойство("Закрыть") Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Изменение:'; en = 'Changed:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиКлиентПродолжение(ПараметрыЗаписи) Экспорт
	
	ПараметрыЗаписи.Вставить("ПоказаноПредупреждение", Истина);
	ПослеЗаписи(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть()
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИЗакрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры


