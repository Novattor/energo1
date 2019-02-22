
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СсылкаНаОбъект = Параметры.Ссылка;
	
	ОбщийШаблон = РегистрыСведений.ВерсииОбъектов.ПолучитьМакет("СтандартныйМакетПредставленияОбъекта");
	
	ЦветСветлоСерый = ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет;
	ЦветКрасноФиолетовый = ЦветаСтиля.ЗаголовокУдаленногоРеквизитаФон;
	
	Если ТипЗнч(Параметры.СравниваемыеВерсии) = Тип("Массив") Тогда
		СравниваемыеВерсии = Новый СписокЗначений;
		Для Каждого НомерВерсии Из Параметры.СравниваемыеВерсии Цикл
			СравниваемыеВерсии.Добавить(НомерВерсии, НомерВерсии);
		КонецЦикла;
	ИначеЕсли ТипЗнч(Параметры.СравниваемыеВерсии) = Тип("СписокЗначений") Тогда
		СравниваемыеВерсии = Параметры.СравниваемыеВерсии;
	Иначе // Используется переданная версия объекта.
		СериализованныйОбъект = ПолучитьИзВременногоХранилища(Параметры.АдресСериализованногоОбъекта);
		Если Параметры.ПоВерсии Тогда // Используется отчет по одной версии.
			ТаблицаОтчета = ВерсионированиеОбъектов.ОтчетПоВерсииОбъекта(СсылкаНаОбъект, СериализованныйОбъект);
		КонецЕсли;
		Возврат;
	КонецЕсли;
		
	СравниваемыеВерсии.СортироватьПоЗначению();
	Если СравниваемыеВерсии.Количество() > 1 Тогда
		СтрокаНомераВерсий = "";
		Для Каждого Версия Из СравниваемыеВерсии Цикл
			СтрокаНомераВерсий = СтрокаНомераВерсий + Строка(Версия.Представление) + ", ";
		КонецЦикла;
		
		СтрокаНомераВерсий = Лев(СтрокаНомераВерсий, СтрДлина(СтрокаНомераВерсий) - 2);
		
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сравнение версий ""%1"" (№№ %2)'; en = 'Comparing versions ""%1"" (№№ %2)'"),
			ОбщегоНазначения.ПредметСтрокой(СсылкаНаОбъект), СтрокаНомераВерсий);
	Иначе
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Версия объекта ""%1"" №%2'; en = 'Version of object ""%1"" №%2'"),
			СсылкаНаОбъект, Строка(СравниваемыеВерсии[0].Представление));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Сформировать();
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТаблицаОтчетаВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Расшифровка = Область.Расшифровка;
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если Расшифровка.Свойство("Сравнить") Тогда
			ОткрытьФормуСравненияТабличныхДокументов(Расшифровка.Сравнить, Расшифровка.Версия0, Расшифровка.Версия1);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Сформировать()
	Если СравниваемыеВерсии.Количество() = 1 Тогда
		СформироватьОтчетПоВерсии();
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ТаблицаОтчета, "ФормированиеОтчета");
		ПодключитьОбработчикОжидания("НачатьФормированиеОтчетаПоВерсиям", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НачатьФормированиеОтчетаПоВерсиям()
	ДлительнаяОперация = СформироватьОтчетПоВерсиям();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииФормированияОтчета", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетПоВерсиям()
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор());
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("СсылкаНаОбъект", СсылкаНаОбъект);
	ПараметрыОтчета.Вставить("СписокВерсий", СравниваемыеВерсии);
	Возврат ДлительныеОперации.ВыполнитьВФоне("РегистрыСведений.ВерсииОбъектов.СформироватьОтчетПоИзменениям", ПараметрыОтчета, ПараметрыВыполнения);
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииФормированияОтчета(Результат, ДополнительныеПараметры) Экспорт
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ТаблицаОтчета, "НеИспользовать");
	Если Результат.Статус = "Выполнено" Тогда
		ТаблицаОтчета = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	Иначе
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчетПоВерсии()
	ТаблицаОтчета = ВерсионированиеОбъектов.ОтчетПоВерсииОбъекта(СсылкаНаОбъект, СравниваемыеВерсии[0].Значение, СравниваемыеВерсии[0].Представление);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСравненияТабличныхДокументов(ИмяТабличногоДокумента, Версия0, Версия1)
	
	ЗаголовокШаблон = НСтр("ru='Версия №%1'; en = 'Version №%1'");
	НомерВерсии0 = Формат(СравниваемыеВерсии[Версия0], "ЧГ=0");
	НомерВерсии1 = Формат(СравниваемыеВерсии[Версия1], "ЧГ=0");
	ЗаголовокЛевый = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокШаблон, НомерВерсии1);
	ЗаголовокПравый = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокШаблон, НомерВерсии0);
	
	АдресТабличныхДокументов = ПолучитьАдресТабличныхДокументов(ИмяТабличногоДокумента, Версия1, Версия0);
	ПараметрыОткрытияФормы = Новый Структура("АдресТабличныхДокументов, ЗаголовокЛевый, ЗаголовокПравый", 
		АдресТабличныхДокументов, ЗаголовокЛевый, ЗаголовокПравый);
	ФормаСравнения = ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.СравнениеТабличныхДокументов",
		ПараметрыОткрытияФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресТабличныхДокументов(ИмяТабличногоДокумента, Левый, Правый) 
	
	ТабличныйДокументЛевый = ТабличныеДокументы[Левый].Значение[ИмяТабличногоДокумента].Данные;
	ТабличныйДокументПравый = ТабличныеДокументы[Правый].Значение[ИмяТабличногоДокумента].Данные;
	
	ТабличныеДокументыСтруктура = Новый Структура("Левый, Правый", ТабличныйДокументЛевый, ТабличныйДокументПравый);
	
	Возврат ПоместитьВоВременноеХранилище(ТабличныеДокументыСтруктура, УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти



