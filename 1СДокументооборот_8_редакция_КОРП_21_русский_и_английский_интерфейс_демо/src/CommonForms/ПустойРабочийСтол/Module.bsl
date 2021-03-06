
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не СтандартныеПодсистемыКлиент.ОтключенаЛогикаНачалаРаботыСистемы() Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ТестовыйРежим.Видимость = Истина;
	
	ЗаголовокТестовогоРежима = "{" + НСтр("ru = 'Тестирование'; en = 'Testing'") + "} ";
	ТекущийЗаголовок = ПолучитьЗаголовокКлиентскогоПриложения();
	
	Если СтрНачинаетсяС(ТекущийЗаголовок, ЗаголовокТестовогоРежима) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьЗаголовокКлиентскогоПриложения(ЗаголовокТестовогоРежима + ТекущийЗаголовок);
	
	ЗарегистрироватьОтключениеЛогикиНачалаРаботыСистемы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗарегистрироватьОтключениеЛогикиНачалаРаботыСистемы()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВладелецДанных = Справочники.ИдентификаторыОбъектовМетаданных.ПолучитьСсылку(
		Новый УникальныйИдентификатор("627a6fb8-872a-11e3-bb87-005056c00008")); // Константы.
	
	ДатыОтключения = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ВладелецДанных);
	Если ТипЗнч(ДатыОтключения) <> Тип("Массив") Тогда
		ДатыОтключения = Новый Массив;
	КонецЕсли;
	
	ДатыОтключения.Добавить(ТекущаяДатаСеанса());
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ВладелецДанных, ДатыОтключения);
	
КонецПроцедуры

#КонецОбласти
