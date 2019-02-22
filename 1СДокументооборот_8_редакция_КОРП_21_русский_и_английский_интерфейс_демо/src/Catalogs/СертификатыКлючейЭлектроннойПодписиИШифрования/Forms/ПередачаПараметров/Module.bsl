&НаКлиенте
Перем ОбщиеВнутренниеДанные;

&НаКлиенте
Перем ВременноеХранилищеКонтекстовОпераций;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбщиеВнутренниеДанные = Новый Соответствие;
	Отказ = Истина;
	
	ВременноеХранилищеКонтекстовОпераций = Новый Соответствие;
	ПодключитьОбработчикОжидания("УдалитьУстаревшиеКонтекстыОпераций", 300);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьНовуюФорму(ВидФормы, СерверныеПараметры, КлиентскиеПараметры = Неопределено,
			ОбработкаЗавершения = Неопределено, Знач ВладелецНовойФормы = Неопределено) Экспорт
	
	ВидыФорм =
		",ПодписаниеДанных,ШифрованиеДанных,РасшифровкаДанных,
		|,ВыборСертификатаДляПодписанияИлиРасшифровки,ПроверкаСертификата,";
	
	Если СтрНайти(ВидыФорм, "," + ВидФормы + ",") = 0 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка в процедуре ОткрытьНовуюФорму. ВидФормы ""%1"" не поддерживается.'; en = 'Error in procedure ОткрытьНовуюФорму. Form type ""%1"" is not supported.'"),
			ВидФормы);
	КонецЕсли;
	
	Если ВладелецНовойФормы = Неопределено Тогда
		ВладелецНовойФормы = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	ОбработкаПродолжения = Новый ОписаниеОповещения("ОткрытьНовуюФорму", ЭтотОбъект);
	
	ИмяНовойФормы = "Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Форма." + ВидФормы;
	
	Контекст = Новый Структура;
	Форма = ОткрытьФорму(ИмяНовойФормы, СерверныеПараметры, ВладелецНовойФормы,,,,
		Новый ОписаниеОповещения("ОткрытьНовуюФормуОповещениеОЗакрытии", ЭтотОбъект, Контекст));
	
	Если Форма = Неопределено Тогда
		Если ТипЗнч(ОбработкаЗавершения) = Тип("ОписаниеОповещения") Тогда
			ВыполнитьОбработкуОповещения(ОбработкаЗавершения, Неопределено);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(Форма, Истина);
	
	Контекст.Вставить("Форма", Форма);
	Контекст.Вставить("ОбработкаЗавершения", ОбработкаЗавершения);
	Контекст.Вставить("КлиентскиеПараметры", КлиентскиеПараметры);
	Контекст.Вставить("Оповещение", Новый ОписаниеОповещения("ПродлитьХранениеКонтекстаОперации", ЭтотОбъект));
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьНовуюФормуПродолжение", ЭтотОбъект, Контекст);
	
	Если КлиентскиеПараметры = Неопределено Тогда
		Форма.ПродолжитьОткрытие(Оповещение, ОбщиеВнутренниеДанные);
	Иначе
		Форма.ПродолжитьОткрытие(Оповещение, ОбщиеВнутренниеДанные, КлиентскиеПараметры);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОткрытьНовуюФорму.
&НаКлиенте
Процедура ОткрытьНовуюФормуПродолжение(Результат, Контекст) Экспорт
	
	Если Контекст.Форма.Открыта() Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьХранениеФормы(Контекст);
	
	Если ТипЗнч(Контекст.ОбработкаЗавершения) = Тип("ОписаниеОповещения") Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОбработкаЗавершения, Результат);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОткрытьНовуюФорму.
&НаКлиенте
Процедура ОткрытьНовуюФормуОповещениеОЗакрытии(Результат, Контекст) Экспорт
	
	ОбновитьХранениеФормы(Контекст);
	
	Если ТипЗнч(Контекст.ОбработкаЗавершения) = Тип("ОписаниеОповещения") Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОбработкаЗавершения, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьХранениеФормы(Контекст)
	
	СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(Контекст.Форма, Ложь);
	
	Если ТипЗнч(Контекст.КлиентскиеПараметры) = Тип("Структура")
	   И Контекст.КлиентскиеПараметры.Свойство("ОписаниеДанных")
	   И ТипЗнч(Контекст.КлиентскиеПараметры.ОписаниеДанных) = Тип("Структура")
	   И Контекст.КлиентскиеПараметры.ОписаниеДанных.Свойство("КонтекстОперации")
	   И ТипЗнч(Контекст.КлиентскиеПараметры.ОписаниеДанных.КонтекстОперации) = Тип("УправляемаяФорма") Тогда
	
	#Если ВебКлиент Тогда
		ПродлитьХранениеКонтекстаОперации(Контекст.КлиентскиеПараметры.ОписаниеДанных.КонтекстОперации);
	#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродлитьХранениеКонтекстаОперации(Форма) Экспорт
	
	Если ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда
		ВременноеХранилищеКонтекстовОпераций.Вставить(Форма,
			Новый Структура("Форма, Время", Форма, ОбщегоНазначенияКлиент.ДатаСеанса()));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьУстаревшиеКонтекстыОпераций()
	
	УдаляемыеСсылкиНаФормы = Новый Массив;
	Для Каждого КлючИЗначение Из ВременноеХранилищеКонтекстовОпераций Цикл
		
		Если КлючИЗначение.Значение.Форма.Открыта() Тогда
			ВременноеХранилищеКонтекстовОпераций[КлючИЗначение.Ключ].Время = ОбщегоНазначенияКлиент.ДатаСеанса();
			
		ИначеЕсли КлючИЗначение.Значение.Время + 15*60 < ОбщегоНазначенияКлиент.ДатаСеанса() Тогда
			УдаляемыеСсылкиНаФормы.Добавить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Форма Из УдаляемыеСсылкиНаФормы Цикл
		ВременноеХранилищеКонтекстовОпераций.Удалить(Форма);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПарольСертификата(СертификатСсылка, Пароль, ПояснениеПароля) Экспорт
	
	УстановленныеПароли = ОбщиеВнутренниеДанные.Получить("УстановленныеПароли");
	ПоясненияУстановленныхПаролей = ОбщиеВнутренниеДанные.Получить("ПоясненияУстановленныхПаролей");
	
	Если УстановленныеПароли = Неопределено Тогда
		УстановленныеПароли = Новый Соответствие;
		ОбщиеВнутренниеДанные.Вставить("УстановленныеПароли", УстановленныеПароли);
		ПоясненияУстановленныхПаролей = Новый Соответствие;
		ОбщиеВнутренниеДанные.Вставить("ПоясненияУстановленныхПаролей", ПоясненияУстановленныхПаролей);
	КонецЕсли;
	
	ОбработкаПродолжения = Новый ОписаниеОповещения("УстановитьПарольСертификата", ЭтотОбъект);
	
	УстановленныеПароли.Вставить(СертификатСсылка, Строка(Пароль));
	Пароль = Неопределено;
	
	НовоеПояснениеПароля = Новый Структура;
	НовоеПояснениеПароля.Вставить("ТекстПояснения", "");
	НовоеПояснениеПароля.Вставить("ПояснениеГиперссылка", Ложь);
	НовоеПояснениеПароля.Вставить("ТекстПодсказки", "");
	НовоеПояснениеПароля.Вставить("ОбработкаДействия", Неопределено);
	
	Если ТипЗнч(ПояснениеПароля) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(НовоеПояснениеПароля, ПояснениеПароля);
	КонецЕсли;
	
	ПоясненияУстановленныхПаролей.Вставить(СертификатСсылка, НовоеПояснениеПароля);
	
КонецПроцедуры

#КонецОбласти
