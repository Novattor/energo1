#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПротоколированиеРаботыПользователей.ЗаписатьОткрытие(Объект.Ссылка);
	РаботаСПоследнимиОбъектами.ЗаписатьОбращениеКОбъекту(Объект.Ссылка);
	
	ИспользоватьУчетПоОрганизациям = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям");
	
	Если Объект.Ссылка.Пустая() И Объект.ДелаХраненияДокументов.Количество() = 0 Тогда 
		Объект.Дата = ТекущаяДатаСеанса();
		ЗаполнитьДелаКУничтожению();
	Иначе	
		ЗаполнитьРеквизитыСтрок();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Оповестить("ОбновитьСписокПоследних");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") И ЭтоАдресВременногоХранилища(ВыбранноеЗначение) Тогда 
		ЗагрузитьДелаИзВременногоХранилища(ВыбранноеЗначение);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьРеквизитыСтрок();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПротоколированиеРаботыПользователей.ЗаписатьСоздание(Объект.Ссылка, ПараметрыЗаписи.ЭтоНовыйОбъект);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	
	ЗаполнитьРеквизитыСтрок();
	
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСПоследнимиОбъектами.ЗаписатьОбращениеКОбъекту(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ЗаполнитьРеквизитыСтрок();
	
КонецПроцедуры

&НаКлиенте
Процедура ДелоХраненияДокументовПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДелаХраненияДокументов.ТекущиеДанные;
	Строка = Новый Структура("ДелоХраненияДокументов, Индекс, ДатаНачала, ДатаОкончания, СрокХранения, УжеХранится");
	ЗаполнитьЗначенияСвойств(Строка, ТекущиеДанные);
	
	ЗаполнитьРеквизитыСтроки(Строка);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, Строка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДелоХраненияДокументовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	АдресВременногоХранилища = ПоместитьДелаВоВременноеХранилище();
	ПараметрыФормы = Новый Структура("РежимВыбора, АдресВременногоХранилища, СостояниеНаДату, Организация", "ИзУничтоженияДел", 
		АдресВременногоХранилища, ?(Объект.Ссылка.Пустая(), КонецДня(Объект.Дата), Объект.Дата), Объект.Организация);
	ОткрытьФорму("Справочник.ДелаХраненияДокументов.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДелоХраненияДокументовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораДелаХранения(Текст, Объект.Организация, 
			?(Объект.Ссылка.Пустая(), КонецДня(Объект.Дата), Объект.Дата));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДелоХраненияДокументовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораДелаХранения(Текст, Объект.Организация, 
			?(Объект.Ссылка.Пустая(), КонецДня(Объект.Дата), Объект.Дата));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если ИспользоватьУчетПоОрганизациям И Не ЗначениеЗаполнено(Объект.Организация) Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Организация""'; en = '""Company"" field is not filled in'"),,,"Объект.Организация");
	    Возврат;
	КонецЕсли;	
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПродолжение", ЭтотОбъект);
	
	МассивДел = Новый Массив;
	Для Каждого Строка Из Объект.ДелаХраненияДокументов Цикл
		Если ЗначениеЗаполнено(Строка.ДелоХраненияДокументов) Тогда 
			МассивДел.Добавить(Строка.ДелоХраненияДокументов);
		КонецЕсли;	
	КонецЦикла;
	
	Если МассивДел.Количество() > 0 Тогда 
		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Продолжить?'; en = 'Tabular section will be cleared before filling. Continue?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса,
			РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Иначе 	
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	АдресВременногоХранилища = ПоместитьДелаВоВременноеХранилище();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", "ИзУничтоженияДел");
	ПараметрыФормы.Вставить("АдресВременногоХранилища", АдресВременногоХранилища);
	ПараметрыФормы.Вставить("СостояниеНаДату", ?(Объект.Ссылка.Пустая(), КонецДня(Объект.Дата), Объект.Дата-1));
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	
	ОткрытьФорму("Справочник.ДелаХраненияДокументов.Форма.ФормаПодбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры


// СтандартныеПодсистемы.БазоваяФункциональность
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция СформироватьДанныеВыбораДелаХранения(Знач Текст, Знач Организация, Знач ДатаСреза)
	
	ДанныеВыбора = Новый СписокЗначений;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДелаХраненияДокументов.Ссылка,
	|	ДелаХраненияДокументов.Наименование,
	|	ДелаХраненияДокументов.НоменклатураДел,
	|	ДелаХраненияДокументов.НоменклатураДел.Индекс КАК Индекс,
	|	ДелаХраненияДокументов.НоменклатураДел.СрокХранения КАК СрокХранения,
	|	ДелаХраненияДокументов.ДатаОкончания
	|ИЗ
	|	Справочник.ДелаХраненияДокументов КАК ДелаХраненияДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДелХраненияДокументов.СрезПоследних(&НаДату, ) КАК СостоянияДел
	|		ПО (СостоянияДел.ДелоХраненияДокументов = ДелаХраненияДокументов.Ссылка)
	|ГДЕ
	|	ЕСТЬNULL(СостоянияДел.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияДелХраненияДокументов.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Перечисление.СостоянияДелХраненияДокументов.Уничтожено)
	|	И (ДелаХраненияДокументов.Наименование ПОДОБНО &Текст
	|			ИЛИ ДелаХраненияДокументов.НоменклатураДел.Индекс + "" "" + ДелаХраненияДокументов.Наименование ПОДОБНО &Текст)
	|	И ДелаХраненияДокументов.ДелоЗакрыто
	|	И ДелаХраненияДокументов.НоменклатураДел.КатегорияДела <> ЗНАЧЕНИЕ(Перечисление.КатегорииДел.Постоянное)";

	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		Запрос.Текст = Запрос.Текст +"
			|	И ДелаХраненияДокументов.Организация = &Организация";
		Запрос.УстановитьПараметр("Организация", Организация);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НаДату", Новый Граница(ДатаСреза, ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	Запрос.УстановитьПараметр("Дата", ДатаСреза);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ТипЗнч(Выборка.СрокХранения) = Тип("Число")
			И Год(Выборка.ДатаОкончания) + Выборка.СрокХранения + 1 > Год(ДатаСреза) Тогда 
			Продолжить;
		КонецЕсли;
		ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.Индекс + " " + Выборка.Наименование);
	КонецЦикла;
		
	Возврат ДанныеВыбора;
	
КонецФункции

&НаСервере
Функция ПоместитьДелаВоВременноеХранилище()

	Возврат ПоместитьВоВременноеХранилище(Объект.ДелаХраненияДокументов.Выгрузить(,"ДелоХраненияДокументов"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗагрузитьДелаИзВременногоХранилища(АдресВременногоХранилища)

	Объект.ДелаХраненияДокументов.Загрузить(ПолучитьИзВременногоХранилища(АдресВременногоХранилища));
	ЗаполнитьРеквизитыСтрок();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыСтрок()
	
	Для Каждого Строка Из Объект.ДелаХраненияДокументов Цикл 
		Если Не ЗначениеЗаполнено(Строка.ДелоХраненияДокументов) Тогда 
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьРеквизитыСтроки(Строка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыСтроки(Строка)
	
	РеквизитыДела = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Строка.ДелоХраненияДокументов,
		"НоменклатураДел.Индекс, НоменклатураДел.СрокХранения, ДатаНачала, ДатаОкончания");
	Строка.Индекс = РеквизитыДела.НоменклатураДелИндекс;
	Строка.ДатаНачала = РеквизитыДела.ДатаНачала;
	Строка.ДатаОкончания = РеквизитыДела.ДатаОкончания;
	
	СрокХранения = РеквизитыДела.НоменклатураДелСрокХранения;
	Если ТипЗнч(СрокХранения) = Тип("Число") Тогда 
		Строка.СрокХранения = Строка(СрокХранения) + " " + ДелопроизводствоКлиентСервер.ПодписьЛет(СрокХранения);
	Иначе
		Строка.СрокХранения = СрокХранения;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Строка.ДелоХраненияДокументов) И (Объект.Дата >= РеквизитыДела.ДатаОкончания) Тогда
		УжеХранится = Год(Объект.Дата) - Год(РеквизитыДела.ДатаОкончания) - 1;
		Если УжеХранится < 1 Тогда 
			Строка.УжеХранится = НСтр("ru = 'Менее года'; en = 'Less than a year'");
		Иначе	
			Строка.УжеХранится = Строка(УжеХранится) + " " + ДелопроизводствоКлиентСервер.ПодписьЛет(УжеХранится);
		КонецЕсли;	
	Иначе
		Строка.УжеХранится = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДелаКУничтожению()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОтноситсяКНоменклатуреДел2.Ссылка КАК ПереходящееДело
	|ПОМЕСТИТЬ ПереходящиеДела
	|ИЗ
	|	Справочник.ДелаХраненияДокументов.ОтноситсяКНоменклатуреДел КАК ОтноситсяКНоменклатуреДел1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДелаХраненияДокументов.ОтноситсяКНоменклатуреДел КАК ОтноситсяКНоменклатуреДел2
	|		ПО (ОтноситсяКНоменклатуреДел2.Ссылка = ОтноситсяКНоменклатуреДел1.Ссылка)
	|ГДЕ
	|	НЕ ОтноситсяКНоменклатуреДел1.Ссылка.ПометкаУдаления
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтноситсяКНоменклатуреДел2.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОтноситсяКНоменклатуреДел2.НоменклатураДел) > 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДелаХраненияДокументовОтноситсяКНоменклатуреДел.НоменклатураДел
	|ПОМЕСТИТЬ ПереходящиеНоменклатуры
	|ИЗ
	|	ПереходящиеДела КАК ПереходящиеДела
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДелаХраненияДокументов.ОтноситсяКНоменклатуреДел КАК ДелаХраненияДокументовОтноситсяКНоменклатуреДел
	|		ПО ПереходящиеДела.ПереходящееДело = ДелаХраненияДокументовОтноситсяКНоменклатуреДел.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДелаХраненияДокументов.Ссылка КАК ДелоХраненияДокументов,
	|	ДелаХраненияДокументов.ДатаОкончания КАК ДатаОкончанияДела,
	|	ДелаХраненияДокументов.НоменклатураДел.СрокХранения КАК СрокХранения,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПереходящиеНоменклатуры.НоменклатураДел, ЛОЖЬ) <> ЛОЖЬ
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЕстьПереходящее,
	|	ДелаХраненияДокументов.НоменклатураДел,
	|	ДелаХраненияДокументов.НоменклатураДел.Индекс КАК НоменклатураДелИндекс
	|ИЗ
	|	Справочник.ДелаХраненияДокументов КАК ДелаХраненияДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДелХраненияДокументов.СрезПоследних(&НаДату, ) КАК СостоянияДел
	|		ПО (СостоянияДел.ДелоХраненияДокументов = ДелаХраненияДокументов.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПереходящиеНоменклатуры КАК ПереходящиеНоменклатуры
	|		ПО ДелаХраненияДокументов.НоменклатураДел = ПереходящиеНоменклатуры.НоменклатураДел
	|ГДЕ
	|	ЕСТЬNULL(СостоянияДел.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияДелХраненияДокументов.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Перечисление.СостоянияДелХраненияДокументов.Уничтожено)
	|	И НЕ ДелаХраненияДокументов.ПометкаУдаления
	|	И ДелаХраненияДокументов.ДелоЗакрыто
	|	И ДелаХраненияДокументов.НоменклатураДел.КатегорияДела <> ЗНАЧЕНИЕ(Перечисление.КатегорииДел.Постоянное)";
	НаДату = Объект.Дата;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда 
		Запрос.Текст = Запрос.Текст + " И ДелаХраненияДокументов.Организация = &Организация ";
		Запрос.УстановитьПараметр("Организация", Объект.Организация);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НаДату", Новый Граница(НаДату, ВидГраницы.Исключая));
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		МассивПоиска = Объект.ДелаХраненияДокументов.НайтиСтроки(
			Новый Структура("ДелоХраненияДокументов", Выборка.ДелоХраненияДокументов));
		Если МассивПоиска.Количество() = 0 Тогда 
			Если Выборка.ЕстьПереходящее Тогда 
				ДобавитьПереходящиеДела(Выборка.НоменклатураДел, НаДату);
				Продолжить;
				
			ИначеЕсли ТипЗнч(Выборка.СрокХранения) = Тип("Число")
				И Год(Выборка.ДатаОкончанияДела) + Выборка.СрокХранения + 1 > Год(НаДату) Тогда 
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = Объект.ДелаХраненияДокументов.Добавить();
			НоваяСтрока.ДелоХраненияДокументов = Выборка.ДелоХраненияДокументов;
			ЗаполнитьРеквизитыСтроки(НоваяСтрока);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПереходящиеДела(НоменклатураДел, НаДату)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДелаОтносятсяКНоменклатуреДел.Ссылка КАК Дело
		|ПОМЕСТИТЬ ДелаТекущейНоменклатурыДел
		|ИЗ
		|	Справочник.ДелаХраненияДокументов.ОтноситсяКНоменклатуреДел КАК ДелаОтносятсяКНоменклатуреДел
		|ГДЕ
		|	НЕ ДелаОтносятсяКНоменклатуреДел.Ссылка.ПометкаУдаления
		|	И ДелаОтносятсяКНоменклатуреДел.НоменклатураДел = &Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДелаХраненияДокументовОтноситсяКНоменклатуреДел.НоменклатураДел
		|ПОМЕСТИТЬ ВсяНоменклатура
		|ИЗ
		|	Справочник.ДелаХраненияДокументов.ОтноситсяКНоменклатуреДел КАК ДелаХраненияДокументовОтноситсяКНоменклатуреДел
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДелаТекущейНоменклатурыДел КАК ДелаТекущейНоменклатурыДел
		|		ПО ДелаХраненияДокументовОтноситсяКНоменклатуреДел.Ссылка = ДелаТекущейНоменклатурыДел.Дело.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДелаХраненияДокументов.Ссылка КАК ДелоХраненияДокументов,
		|	ДелаХраненияДокументов.ДелоЗакрыто КАК ДелоЗакрыто,
		|	ДелаХраненияДокументов.ДатаНачала,
		|	ДелаХраненияДокументов.ДатаОкончания КАК ДатаОкончанияДела,
		|	ДелаХраненияДокументов.НоменклатураДел.СрокХранения КАК СрокХранения
		|ИЗ
		|	Справочник.ДелаХраненияДокументов КАК ДелаХраненияДокументов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВсяНоменклатура КАК ВсяНоменклатура
		|		ПО ДелаХраненияДокументов.НоменклатураДел = ВсяНоменклатура.НоменклатураДел
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДелоЗакрыто,
		|	ДелаХраненияДокументов.ДатаОкончания";
	
	Запрос.Параметры.Вставить("Номенклатура", НоменклатураДел);
	
	МассивДел = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Не Выборка.ДелоЗакрыто Тогда 
			МассивДел = Новый Массив;
			Прервать;
		КонецЕсли;
		
		МассивПоиска = Объект.ДелаХраненияДокументов.НайтиСтроки(
			Новый Структура("ДелоХраненияДокументов", Выборка.ДелоХраненияДокументов));
		Если МассивПоиска.Количество() = 0 Тогда 
			
			Если ТипЗнч(Выборка.СрокХранения) = Тип("Число")
				И Год(Выборка.ДатаОкончанияДела) + Выборка.СрокХранения + 1 > Год(НаДату) Тогда 
				МассивДел = Новый Массив;
				Прервать;
			КонецЕсли;
			
			МассивДел.Добавить(Выборка.ДелоХраненияДокументов);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Дело Из МассивДел Цикл 
		НоваяСтрока = Объект.ДелаХраненияДокументов.Добавить();
		НоваяСтрока.ДелоХраненияДокументов = Дело;
		ЗаполнитьРеквизитыСтроки(НоваяСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПродолжение(Результат, Параметры) Экспорт 

	Если Результат = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда 
		Объект.ДелаХраненияДокументов.Очистить();	
	КонецЕсли;	
		
	ЗаполнитьДелаКУничтожению();
	Модифицированность = Истина;
	
	Если Объект.ДелаХраненияДокументов.Количество() = 0 Тогда 
		ТекстСообщения = НСтр("ru = 'Дела (тома) с истекшим сроком хранения не найдены!'; en = 'Expired case files (dossiers) not found!'");
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
