
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Предопределенный Или Объект.ЗапретитьРедактированиеПользователем Тогда
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.Родитель.ТолькоПросмотр     = Истина;
		Элементы.Тип.ТолькоПросмотр          = Истина;
		Элементы.ГруппаТипОбщиеДляВсех.ТолькоПросмотр = Объект.ЗапретитьРедактированиеПользователем;
	Иначе
		// Обработчик подсистемы запрета редактирования реквизитов объектов.
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
			МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект,, НСтр("ru = 'Разрешить редактирование типа и группы'; en = 'Allow editing of type and group'"));
			
		Иначе
			Элементы.Родитель.ТолькоПросмотр = Истина;
			Элементы.Тип.ТолькоПросмотр = Истина;
			
		КонецЕсли;
	КонецЕсли;
	
	СсылкаРодителя = Объект.Родитель;
	
	Если Не Объект.МожноИзменятьСпособРедактирования Тогда
		Элементы.РедактированиеТолькоВДиалоге.Доступность       = Ложь;
		Элементы.РазрешитьВводНесколькихЗначений.Доступность    = Ложь;
		Элементы.ГруппаНаименованиеНастройкиПоТипам.Доступность = Ложь;
	Иначе
		Если Объект.ХранитьИсториюИзменений ИЛИ СсылкаРодителя.Пустая() ИЛИ СсылкаРодителя.Уровень() > 0 Тогда
			Элементы.РазрешитьВводНесколькихЗначений.Доступность = Ложь;
		Иначе
			Элементы.РазрешитьВводНесколькихЗначений.Доступность = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ХранитИсториюИзменений.Видимость = Объект.ХранитьИсториюИзменений;
	
	ПроверятьПоКлассификатору = ?(Объект.ПроверятьПоФИАС, 0, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьОтображениеПриИзмененииТипа();
	ОтобразитьДоступностьВариантовПроверкиПоКлассификатору();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ПроверятьПоФИАС = (ПроверятьПоКлассификатору = 0);
	Если Не ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ТекущийОбъект.Предопределенный Тогда
		// Обработчик подсистемы запрета редактирования реквизитов объектов.
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
			МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПриИзменении(Элемент)
	
	ИзменитьРеквизитыПриИзмененииТипа();
	ИзменитьОтображениеПриИзмененииТипа();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресТолькоРоссийскийПриИзменении(Элемент)
	
	ИзменитьРеквизитыПриИзмененииТолькоРоссии();
	ИзменитьОтображениеПриИзмененииТолькоРоссии();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьКорректностьАдресаПриИзменении(Элемент)
	ОтобразитьДоступностьВариантовПроверкиПоКлассификатору();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Предопределенный Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			МодульЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
			МодульЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьОтображениеПриИзмененииТипа()
	
	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Адрес;
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Объект.МожноИзменятьСпособРедактирования;
		
		ИзменитьОтображениеПриИзмененииТолькоРоссии();
		
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
		Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.АдресЭлектроннойПочты;
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Ложь;
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Skype") Тогда
		Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Skype;
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Ложь;
		Элементы.РазрешитьВводНесколькихЗначений.Доступность = Истина;
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон")
		Или Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
		Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Телефон;
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Объект.МожноИзменятьСпособРедактирования;
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Другое") Тогда
		Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Другое;
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Ложь;
	Иначе
		Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Прочие;
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьДоступностьВариантовПроверкиПоКлассификатору()
	Если Объект.ПроверятьКорректность Тогда
		Элементы.ПроверятьПоКлассификатору.Доступность = Истина;
	Иначе
		Элементы.ПроверятьПоКлассификатору.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРеквизитыПриИзмененииТипа()
	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		ИзменитьРеквизитыПриИзмененииТолькоРоссии();
		
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
		Объект.РедактированиеТолькоВДиалоге = Ложь;
		
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон")
		Или Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
		// Нет изменений
		
	Иначе
		Объект.РедактированиеТолькоВДиалоге = Ложь;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОтображениеПриИзмененииТолькоРоссии()
	
	Элементы.ПроверятьПоКлассификатору.Доступность   = Объект.ПроверятьКорректность;
	Элементы.ПроверятьКорректностьАдреса.Доступность  = Объект.АдресТолькоРоссийский;
	Элементы.СкрыватьНеактуальныеАдреса.Доступность  = Объект.АдресТолькоРоссийский;
	Элементы.УказыватьОКТМОВручную.Доступность       = Объект.АдресТолькоРоссийский;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРеквизитыПриИзмененииТолькоРоссии()
	
	Если Не Объект.АдресТолькоРоссийский Тогда
		Объект.ПроверятьКорректность      = Ложь;
		Объект.СкрыватьНеактуальныеАдреса = Ложь;
		Объект.УказыватьОКТМО = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
