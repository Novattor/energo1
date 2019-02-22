
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Ответственный = Пользователи.АвторизованныйПользователь();
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(Список, "Ответственный", Ответственный);
	
	ОтветственныйИсх = Ответственный;
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокИсх, "Ответственный", ОтветственныйИсх);
	
	СтатусНеРаспакованногоПакета = Перечисления.СтатусыПакетовЭД.КРаспаковке;
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НераспакованныеПакеты, "Статус", СтатусНеРаспакованногоПакета);
	
	СтатусНеОтправленногоПакета = Перечисления.СтатусыПакетовЭД.ПодготовленКОтправке;
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НеотправленныеПакеты, "Статус", СтатусНеОтправленногоПакета);
	
	АктуальныеВидыЭД = ОбменСКонтрагентамиПовтИсп.ПолучитьАктуальныеВидыЭД();
	
	МассивИсключенияВходящихЭД = Новый Массив();

	Элементы.ВидЭД.СписокВыбора.ЗагрузитьЗначения(АктуальныеВидыЭД);
	
	МассивИсключенияИсходящихЭД = Новый Массив();
	МассивИсключенияИсходящихЭД.Добавить(Перечисления.ВидыЭД.Подтверждение);
	
	ВидыЭДИсходящие = ОбщегоНазначенияКлиентСервер.СократитьМассив(АктуальныеВидыЭД, МассивИсключенияИсходящихЭД);
	Элементы.ВидЭДИсх.СписокВыбора.ЗагрузитьЗначения(ВидыЭДИсходящие);
	
	Элементы.Пакеты.Видимость = Пользователи.ЭтоПолноправныйПользователь();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборПоЭлементуПриЗагрузкеИзНастроек(ЭтотОбъект, Список, "ВидЭД",    Настройки);
	ОтборПоЭлементуПриЗагрузкеИзНастроек(ЭтотОбъект, Список, "СтатусЭД", Настройки);
	
	ОтборПоЭлементуПриЗагрузкеИзНастроек(ЭтотОбъект, СписокИсх, "ВидЭДИсх",    Настройки);
	ОтборПоЭлементуПриЗагрузкеИзНастроек(ЭтотОбъект, СписокИсх, "СтатусЭДИсх", Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		
		Элементы.Список.Обновить();
		Элементы.СписокИсх.Обновить();
		Элементы.СписокНераспакованныеПакеты.Обновить();
		Элементы.СписокНеотправленныеПакеты.Обновить();
		Элементы.ВсеПакеты.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидЭДПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(Список, "ВидЭД", ВидЭД);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элемент.ТекущиеДанные <> Неопределено Тогда		
		ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(Список, "Ответственный", Ответственный);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусЭДПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(Список, "СостояниеЭДО", СостояниеЭДО);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНеРаспакованногоПакетаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НераспакованныеПакеты, "Контрагент", КонтрагентНеРаспакованногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусНеРаспакованногоПакетаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НераспакованныеПакеты, "Статус", СтатусНеРаспакованногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНеотправленногоПакетаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НеотправленныеПакеты, "Контрагент", КонтрагентНеОтправленногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусНеОтправленногоПакетаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НеотправленныеПакеты, "Статус", СтатусНеОтправленногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйИсхПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокИсх, "Ответственный", ОтветственныйИсх);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЭДИсхПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокИсх, "ВидЭДИсх", ВидЭДИсх);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусЭДИсхПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокИсх, "СостояниеЭДО", СостояниеЭДОИсх);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьОтветственного(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыборГруппПользователей", Ложь);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",      Истина);
	ПараметрыФормы.Вставить("РежимВыбора",             Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьВыборОтветственного", ЭтотОбъект);
	НовыйОтветственный = ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, ЭтотОбъект,
		УникальныйИдентификатор, , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СравнитьДанныеВходящихЭД(Команда)
	
	СравнитьДанныеЭД(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СравнитьДанныеИсходящихЭД(Команда)
	
	СравнитьДанныеЭД(Элементы.СписокИсх);
	
КонецПроцедуры

&НаКлиенте
Процедура Распаковать(Команда)
	
	// Распаковываем только выделенные строки
	ОбменСКонтрагентамиСлужебныйКлиент.РаспаковатьПакетыЭДНаКлиенте(Элементы.СписокНераспакованныеПакеты.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	// Отправить только выделенные строки
	МассивЭД = Элементы.СписокНеотправленныеПакеты.ВыделенныеСтроки; 
	
	ОбработкаОповещения = Новый ОписаниеОповещения("КомандаОтправитьОповещение", ЭтотОбъект);
	
	ОбменСКонтрагентамиСлужебныйКлиент.ОтправитьМассивПакетовЭД(МассивЭД, ОбработкаОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтправитьОповещение(КолОтправленныхПакетов, ДополнительныеПараметры) Экспорт
	
	ЗаголовокОповещения = НСтр("ru = 'Обмен электронными документами'; en = 'Electronic document interchange'");
	ТекстОповещения     = НСтр("ru = 'Отправленных пакетов нет'; en = 'No packets sent'");
	
	Если ЗначениеЗаполнено(КолОтправленныхПакетов) Тогда
	
		ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отправлено пакетов: (%1)'; en = 'Packets sent: (%1)'"), КолОтправленныхПакетов);
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ЗаголовокОповещения, , ТекстОповещения);
	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКРаспаковке(Команда)
	
	ТаблицаПакетов = "СписокНеРаспакованныеПакеты";
	Количество = 0;
	УстановитьСтатусПакетов(ТаблицаПакетов, ПредопределенноеЗначение("Перечисление.СтатусыПакетовЭД.КРаспаковке"), Количество);
	
	ТекстОповещения = НСтр("ru = 'Изменен статус пакетов на ""К распаковке""'; en = 'Changed the status of the packages to ""To unpack""'") + ": (%1)";
	ТекстОповещения = СтрЗаменить(ТекстОповещения, "%1", Количество);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Обмен электронными документами'; en = 'Electronic document interchange'"), , ТекстОповещения);
	Элементы[ТаблицаПакетов].Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтменен(Команда)
	
	Если Команда.Имя = "УстановитьСтатусОтмененНеРаспакованныеПакеты" Тогда
		ТаблицаПакетов = "СписокНеРаспакованныеПакеты";
	Иначе
		ТаблицаПакетов = "СписокНеОтправленныеПакеты";
	КонецЕсли;
	
	Количество = 0;
	УстановитьСтатусПакетов(ТаблицаПакетов, ПредопределенноеЗначение("Перечисление.СтатусыПакетовЭД.Отменен"), Количество);
	ТекстОповещения = НСтр("ru = 'Изменен статус пакетов на ""Отменен""'; en = 'Changed the status of the packages to ""Canceled""'") + ": (%1)";
	ТекстОповещения = СтрЗаменить(ТекстОповещения, "%1", Количество);
	ПоказатьОповещениеПользователя(НСтр("ru = 'Обмен электронными документами'; en = 'Electronic document interchange'"), , ТекстОповещения);
	Элементы[ТаблицаПакетов].Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусПодготовленКОтправке(Команда)
	
	ТаблицаПакетов = "СписокНеотправленныеПакеты";
	Количество = 0;
	УстановитьСтатусПакетов(ТаблицаПакетов, ПредопределенноеЗначение("Перечисление.СтатусыПакетовЭД.ПодготовленКОтправке"), Количество);
	ТекстОповещения = НСтр("ru = 'Изменен статус пакетов на ""Подготовлен к отправке""'; en = 'Changed status of packages to ""Prepared for sending""'" + ": (%1)");
	ТекстОповещения = СтрЗаменить(ТекстОповещения, "%1", Количество);
	ПоказатьОповещениеПользователя(НСтр("ru = 'Обмен электронными документами'; en = 'Electronic document interchange'"), , ТекстОповещения);
	Элементы[ТаблицаПакетов].Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПакетыЭДНаДиск(Команда)
	
	ДанныеФайлов = ПолучитьДанныеПрисоединенныхФайловПакетовЭДНаСервере(
		Элементы.ВсеПакеты.ВыделенныеСтроки, УникальныйИдентификатор);
	
	МассивФайлов = Новый Массив;
	Для Каждого ДанныеФайла Из ДанныеФайлов Цикл
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(
			ДанныеФайла.ИмяФайла, ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
		МассивФайлов.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	МодульЭлектронноеВзаимодействиеСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектронноеВзаимодействиеСлужебныйКлиент");
	
	Если МассивФайлов.Количество() Тогда
		ПустойОбработчик = Новый ОписаниеОповещения("ПустойОбработчик", 
			МодульЭлектронноеВзаимодействиеСлужебныйКлиент);
		НачатьПолучениеФайлов(ПустойОбработчик, МассивФайлов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВходящиеВыгрузитьЭлектронныеДокументыДляФНС(Команда)
	
	ВыгрузитьОбменСКонтрагентамиДляФНС(ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий"));
	
КонецПроцедуры

&НаКлиенте
Процедура ИсходящиеВыгрузитьЭлектронныеДокументыДляФНС(Команда)
	
	ВыгрузитьОбменСКонтрагентамиДляФНС(ПредопределенноеЗначение("Перечисление.НаправленияЭД.Исходящий"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокДанных, ВидЭлемента, ЗначениеЭлемента)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДанных, ВидЭлемента,
		ЗначениеЭлемента, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ЗначениеЭлемента));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтветственногоЭД(Знач СписокОбъектов, НовыйОтветственный, КоличествоОбработанныхЭД)
	
	МассивЭД = Новый Массив();
	КоличествоОбработанных = 0;
	
	Для Каждого ЭлСписка Из СписокОбъектов Цикл
		Если ТипЗнч(ЭлСписка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		МассивЭД.Добавить(ЭлСписка.Ссылка);
	КонецЦикла;
	
	Если МассивЭД.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭДПрисоединенныеФайлы.Ссылка,
	|	ЭДПрисоединенныеФайлы.Ответственный
	|ИЗ
	|	Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
	|ГДЕ
	|	ЭДПрисоединенныеФайлы.Ссылка В(&МассивЭД)
	|	И ЭДПрисоединенныеФайлы.Ответственный <> &Ответственный";
	Запрос.УстановитьПараметр("МассивЭД", МассивЭД);
	Запрос.УстановитьПараметр("Ответственный", НовыйОтветственный);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	Попытка
		Пока Выборка.Следующий() Цикл
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			СтруктураПараметров = Новый Структура("Ответственный", НовыйОтветственный);
			ОбменСКонтрагентамиСлужебныйВызовСервера.ИзменитьПоСсылкеПрисоединенныйФайл(Выборка.Ссылка, СтруктураПараметров, Ложь);
			КоличествоОбработанныхЭД = КоличествоОбработанныхЭД + 1;
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстОшибки = НСтр("ru='Не удалось выполнить запись электронного документа (%Объект%). %ОписаниеОшибки%'; en = 'Failed to save an electronic document (%Объект%). %ОписаниеОшибки%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Объект%", Выборка.Ссылка);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура СравнитьДанныеЭД(ТекущийСписок)
	
	#Если НЕ ТолстыйКлиентУправляемоеПриложение И НЕ ТолстыйКлиентОбычноеПриложение Тогда
		ТекстСообщения = НСтр("ru='Сравнение электронных документов можно сделать только в режиме толстого клиента.'; en = 'Comparison of electronic documents can only be done in thick client mode.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	#Иначе
		Если ТекущийСписок.ТекущиеДанные = Неопределено
			ИЛИ ТекущийСписок.ВыделенныеСтроки.Количество() <> 2 Тогда
			Возврат;
		КонецЕсли;
		ТекущийЭД    = ТекущийСписок.ВыделенныеСтроки.Получить(0);
		ПослВерсияЭД = ТекущийСписок.ВыделенныеСтроки.Получить(1);
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ЭДПервый", ПослВерсияЭД);
		СтруктураПараметров.Вставить("ЭДВторой", ТекущийЭД);
		ВыполнитьСравнениеЭД(СтруктураПараметров);
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтатусПакетов(ТаблицаПакетов, СтатусПакета, КоличествоИзмененных)
	
	КоличествоИзмененных = 0;
	Для Каждого СтрокаТаблицы Из Элементы[ТаблицаПакетов].ВыделенныеСтроки Цикл
		Попытка
			Пакет = СтрокаТаблицы.Ссылка.ПолучитьОбъект();
			Пакет.СтатусПакета = СтатусПакета;
			Пакет.Записать();
			КоличествоИзмененных = КоличествоИзмененных + 1;
		Исключение
			ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
				НСтр("ru = 'изменение статуса пакетов ЭД'; en = 'adjustment of ED package status'"), ТекстОшибки, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеПрисоединенныхФайловПакетовЭДНаСервере(Знач ПакетыЭД, УникальныйИдентификатор)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПакетЭДПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	Справочник.ПакетЭДПрисоединенныеФайлы КАК ПакетЭДПрисоединенныеФайлы
	|ГДЕ
	|	ПакетЭДПрисоединенныеФайлы.ВладелецФайла В (&ПакетыЭД)";
	
	Запрос.УстановитьПараметр("ПакетыЭД", ПакетыЭД);
			
	Выборка = Запрос.Выполнить().Выбрать();

	ДанныеФайлов = Новый Массив;
	Пока Выборка.Следующий() Цикл
		ДанныеФайла = ПрисоединенныеФайлы.ПолучитьДанныеФайла(Выборка.Ссылка,
			УникальныйИдентификатор);
		ДанныеФайлов.Добавить(ДанныеФайла);
	КонецЦикла;
	
	Возврат ДанныеФайлов;
	
КонецФункции


&НаСервере
Процедура ВыполнитьСравнениеЭД(СтруктураПараметров)
	
	#Если НЕ ТолстыйКлиентУправляемоеПриложение И НЕ ТолстыйКлиентОбычноеПриложение Тогда
		ТекстСообщения = НСтр("ru='Сравнение электронных документов можно сделать только в режиме толстого клиента.'; en = 'Comparison of electronic documents can only be done in thick client mode.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	#Иначе
		
		ЭДПервый = СтруктураПараметров.ЭДПервый;
		ЭДВторой = СтруктураПараметров.ЭДВторой;
		
		Если Не (ЗначениеЗаполнено(ЭДПервый) И ЗначениеЗаполнено(ЭДВторой)) Тогда
			ТекстСообщения = НСтр("ru='Не указан один из сравниваемых электронных документов.'; en = 'None of the documents being compared is specified.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		МассивЭД = Новый Массив;
		МассивЭД.Добавить(ЭДПервый);
		МассивЭД.Добавить(ЭДВторой);
		ПереченьВременныхФайлов = ОбменСКонтрагентамиСлужебный.ПодготовитьВременныеФайлыПросмотраЭД(МассивЭД);
		
		Если Не ЗначениеЗаполнено(ПереченьВременныхФайлов) Тогда
			ТекстСообщения = НСтр("ru='Ошибка при разборе электронного документа.'; en = 'An error occurred while parsing an electronic document.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		ИмяФайла = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла("mxl");
		// Необходимо заменить фрагмент от последнего подчеркивания до фрагмента ".mxl".
		ДлинаСтроки = СтрДлина(ИмяФайла);
		Для ОбратныйИндекс = 0 По ДлинаСтроки Цикл
			Если Сред(ИмяФайла, ДлинаСтроки - ОбратныйИндекс, 1) = "_" Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		НазваниеЭД = ПереченьВременныхФайлов[0].НазваниеЭД;
		СкорректироватьИмяФайла(НазваниеЭД);
		ИмяПервогоФайлаMXL = Лев(ИмяФайла, ДлинаСтроки - ОбратныйИндекс) + НазваниеЭД + Прав(ИмяФайла, 4);
		ТабличныйДокумент = ПолучитьИзВременногоХранилища(ПереченьВременныхФайлов[0].АдресФайлаДанных);
		ТабличныйДокумент.Записать(ИмяПервогоФайлаMXL);
		
		НазваниеЭД = ПереченьВременныхФайлов[1].НазваниеЭД;
		СкорректироватьИмяФайла(НазваниеЭД);
		ИмяВторогоФайлаMXL = Лев(ИмяФайла, ДлинаСтроки - ОбратныйИндекс) + НазваниеЭД + Прав(ИмяФайла, 4);
		ТабличныйДокумент = ПолучитьИзВременногоХранилища(ПереченьВременныхФайлов[1].АдресФайлаДанных);
		ТабличныйДокумент.Записать(ИмяВторогоФайлаMXL);
		
		Сравнение = Новый СравнениеФайлов;
		Сравнение.СпособСравнения = СпособСравненияФайлов.ТабличныйДокумент;
		Сравнение.ПервыйФайл = ИмяПервогоФайлаMXL;
		Сравнение.ВторойФайл = ИмяВторогоФайлаMXL;
		Сравнение.ПоказатьРазличияМодально();
		
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура СкорректироватьИмяФайла(СтрИмяФайла)
	
	// Перечень запрещенных символов взят отсюда: http<<ВНЕШНЕЕСОЕДИНЕНИЕ>>support.microsoft.com/kb/100108/ru.
	// При этом были объединены запрещенные символы для файловых систем FAT и NTFS.
	СтрИсключения = """ / \ [ ] : ; | = , ? * < >";
	СтрИсключения = СтрЗаменить(СтрИсключения, " ", "");
	
	Для Сч=1 По СтрДлина(СтрИсключения) Цикл
		Символ = Сред(СтрИсключения, Сч, 1);
		Если СтрНайти(СтрИмяФайла, Символ) <> 0 Тогда
			СтрИмяФайла = СтрЗаменить(СтрИмяФайла, Символ, " ");
		КонецЕсли;
	КонецЦикла;
	
	СтрИмяФайла = СокрЛП(СтрИмяФайла);
	
КонецПроцедуры

&НаСервере
Процедура ОтборПоЭлементуПриЗагрузкеИзНастроек(Форма, СписокДанных, ВидЭлемента, Настройки)
	
	ЗначениеЭлемента = Настройки.Получить(ВидЭлемента);
	
	Если ЗначениеЗаполнено(ЗначениеЭлемента) Тогда
		Форма[ВидЭлемента] = ЗначениеЭлемента;
		УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокДанных, ВидЭлемента, ЗначениеЭлемента);
	КонецЕсли;
	
	Настройки.Удалить(ВидЭлемента);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьПользователяОСменеОтветственного(КоличествоОбработанных, СписокОбъектов, Ответственный)
	
	ОчиститьСообщения();
	
	Если КоличествоОбработанных > 0 Тогда
		
		СписокОбъектов.Обновить();
		
		ТекстСообщения = НСтр("ru='Для %КоличествоОбработанных% из %КоличествоВсего% выделенных эл.документов
		|установлен ответственный ""%Ответственный%""';
		|en = 'For %КоличествоОбработанных% of %КоличествоВсего% selected documents 
		|responsible was set to ""%Ответственный%""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоОбработанных%", КоличествоОбработанных);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВсего%",        СписокОбъектов.ВыделенныеСтроки.Количество());
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ответственный%",          Ответственный);
		ТекстЗаголовка = НСтр("ru='Ответственный ""%Ответственный%"" установлен'; en = 'Responsible ""%Ответственный%"" is selected'");
		ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Ответственный%", Ответственный);
		ПоказатьОповещениеПользователя(ТекстЗаголовка, , ТекстСообщения, БиблиотекаКартинок.Информация32);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Ответственный ""%Ответственный%"" не установлен ни для одного эл.документа.'; en = 'Responsible ""%Ответственный%"" is not selected for any documents.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ответственный%", Ответственный);
		ТекстЗаголовка = НСтр("ru='Ответственный ""%Ответственный%"" не установлен'; en = 'Responsible ""%Ответственный%"" is not selected'");
		ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Ответственный%", Ответственный);
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьОбменСКонтрагентамиДляФНС(НаправлениеЭД)
	
	СтруктураПараметров = Новый Структура("НаправлениеЭД, ВерсияВызова", НаправлениеЭД, 1);
	ОткрытьФорму("Обработка.ОбменСКонтрагентами.Форма.ФормаВыбораЭДДляПередачиФНС",
		СтруктураПараметров, ЭтотОбъект, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборОтветственного(НовыйОтветственный, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(НовыйОтветственный) Тогда
		КоличествоОбработанныхЭД = 0;
		УстановитьОтветственногоЭД(Элементы.Список.ВыделенныеСтроки, НовыйОтветственный, КоличествоОбработанныхЭД);
		ОповеститьПользователяОСменеОтветственного(КоличествоОбработанныхЭД, Элементы.Список, НовыйОтветственный);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
