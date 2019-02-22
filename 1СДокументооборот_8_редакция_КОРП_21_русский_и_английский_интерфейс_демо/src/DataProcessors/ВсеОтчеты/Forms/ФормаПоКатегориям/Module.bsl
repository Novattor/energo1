#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Раздел") И ЗначениеЗаполнено(Параметры.Раздел) Тогда
		Раздел = Параметры.Раздел;
	КонецЕсли;	
	
	Если Параметры.Свойство("ИмяПодсистемы") И ЗначениеЗаполнено(Параметры.ИмяПодсистемы) Тогда
		Раздел = Параметры.ИмяПодсистемы;
	КонецЕсли;	
	
	СписокКатегорий = Параметры.СписокКатегорий.Скопировать();
	
	НеОтображатьИерархию = НеДостаточноВариантовДляГруппировки() И Параметры.НеОтображатьИерархию;

	РазделГипперссылка = Параметры.РазделГипперссылка;
	
	СформироватьГиперссылкуНаОтчетыРаздела();
	
	Если Не ПустаяСтрока(Параметры.ЗаголовокФормы) Тогда
		Заголовок = Параметры.ЗаголовокФормы;
	ИначеЕсли ЗначениеЗаполнено(Раздел) Тогда
		
		Если ТипЗнч(Раздел) = Тип("Строка") Тогда
			
			Подсистема = Метаданные.Подсистемы.Найти(Раздел);
			
			Если НЕ Подсистема = Неопределено Тогда
				ЗаголовокФормы = Подсистема.Синоним;
			Конецесли;
					
		Иначе
			
			ЗаголовокФормы = Раздел;
			
		КонецЕсли;

		
		Заголовок = СтрШаблон(НСтр("ru = 'Отчеты раздела ""%1""'; en = 'Reports of section ""%1""'"), ЗаголовокФормы);
	Иначе
		Заголовок = НСтр("ru = 'Панель отчетов'; en = 'Reports panel'");
	КонецЕсли;
	
	ИдСтроки = 0;
	
	КлючОбъектаНастроек = Заголовок;
	ТекКлючВарианта = ХранилищеНастроекДанныхФорм.Загрузить(КлючОбъектаНастроек, "КлючВарианта");
	
	КатегорияСиноним = ХранилищеНастроекДанныхФорм.Загрузить(КлючОбъектаНастроек, "КатегорияСиноним");
	
	ОбновитьДеревоОтчетов();

	// находим сохраненную настройку последнего отчета, выбранного пользователем
	Если Не НеОтображатьИерархию Тогда
		
		СтрокиДерева = ДеревоОтчетовИВариантов.ПолучитьЭлементы();
		
		Для Каждого СтрокаДерева Из СтрокиДерева Цикл
			
			ВариантыОтчета = СтрокаДерева.ПолучитьЭлементы();
			Если НЕ СтрокаДерева.Синоним =  КатегорияСиноним Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого ВариантОтчета Из ВариантыОтчета Цикл
				Если ВариантОтчета.КлючВарианта = ТекКлючВарианта Тогда
					ИдТекущаяКатегория = ВариантОтчета.ПолучитьИдентификатор();
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
	Иначе 
		
		ВариантыОтчета = ДеревоОтчетовИВариантов.ПолучитьЭлементы();
		Для Каждого ВариантОтчета Из ВариантыОтчета Цикл
			Если ВариантОтчета.КлючВарианта = ТекКлючВарианта Тогда
				ИдТекущаяКатегория = ВариантОтчета.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ИдТекущаяКатегория = 0 Тогда
		
		Элементы.ДеревоОтчетовИВариантов.ТекущаяСтрока = 1;
		
	Иначе
		
		Элементы.ДеревоОтчетовИВариантов.ТекущаяСтрока = ИдТекущаяКатегория;
		
	КонецЕсли;

	Элементы.ДеревоОтчетовИВариантовКонтекстноеМенюНеОтображатьИерархию.Пометка = НЕ НеОтображатьИерархию;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ДеревоОтчетовИВариантов.ТекущиеДанные;
	
	Если (НЕ ТекущиеДанные = Неопределено) И 
			(ТекущиеДанные.ПолучитьРодителя() <> Неопределено 
			Или НеОтображатьИерархию) Тогда
			
		//Сохранение последнего отчета, с которым работал пользователь
		КлючОбъектаНастроек = Заголовок;
		СтрокаРодитель =ТекущиеДанные.ПолучитьРодителя();
		КатегорияСиноним =  ?(СтрокаРодитель <> Неопределено, СтрокаРодитель.Синоним, "");
		ТекКлючВарианта = ТекущиеДанные.КлючВарианта;
		ЗаписатьНастройкиДереваКатегорий(КлючОбъектаНастроек, ТекКлючВарианта, КатегорияСиноним);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоОтчетовИВариантовПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжиданияДеревоОтчетовИВариантовПриАктивизацииСтроки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтчетовИВариантовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьОтчетВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура НеОтображатьИерархиюПриИзменении(Элемент)
	
	ОбновитьДеревоОтчетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФорм

&НаКлиенте
Процедура ОткрытьОтчет(Команда)
	
	ОткрытьОтчетВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДеревоОтчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеОтчеты(Команда)
	
	ИмяПодсистемы = "";
	
	Если ТипЗнч(Раздел) = Тип("Строка") Тогда
		ИмяПодсистемы = Раздел;
	КонецЕсли;
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник", ЭтаФорма);
	ДополнительныеОтчетыИОбработкиКлиент.ОткрытьФормуКомандДополнительныхОтчетовИОбработок(
			,
			ПараметрыВыполненияКоманды,
			ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительныйОтчет(),
			ИмяПодсистемы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетыРаздела(Команда)
	
	РеквизитыРаздел = ОбщегоНазначенияДокументооборотВызовСервера.ЗначенияРеквизитовОбъекта(
							РазделГипперссылка,"Имя");
							
	ПараметрРаздел = РеквизитыРаздел.Имя;

	ПараметрыФормы = Новый Структура("Раздел", ПараметрРаздел); 

	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма.ФормаПоКатегориям",
		ПараметрыФормы,
		ЭтаФорма, 
		);

КонецПроцедуры

&НаКлиенте
Процедура НеОтображатьИерархию(Команда)
	
	НеОтображатьИерархию = Не НеОтображатьИерархию;
	Элементы.ДеревоОтчетовИВариантовКонтекстноеМенюНеОтображатьИерархию.Пометка = НЕ НеОтображатьИерархию;
	
	ОбновитьДеревоОтчетов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаОжиданияДеревоОтчетовИВариантовПриАктивизацииСтроки()
	ТекущиеДанные = Элементы.ДеревоОтчетовИВариантов.ТекущиеДанные; 
	
	// Доступность кнопки "Открыты". Если нет иерархи категорий, то всегда доступна. 
	//Если есть категории, то доступна для варината и недоступна для категории
	Если НеОтображатьИерархию Тогда
		
		Элементы.ДеревоОтчетовИВариантовОткрытьОтчет.Доступность = Истина;
		
	ИначеЕсли ТекущиеДанные = Неопределено Или ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		
		Элементы.ДеревоОтчетовИВариантовОткрытьОтчет.Доступность = Ложь;
		
	Иначе
		
		Элементы.ДеревоОтчетовИВариантовОткрытьОтчет.Доступность = Истина;
		
	КонецЕсли;
	
	// Кешируем значения КлючаВарианта, имени отчета и необходимости показывать привью отчета
	Если ТекущиеДанные = Неопределено тогда
		// если нет строк
		ТекКлючВарианта = "";
		ТекИмяОтчета = "";
		ТекОтображатьСнимок = Ложь;	
		
	ИначеЕсли ТекущиеДанные.ПолучитьРодителя() = Неопределено И (НЕ НеОтображатьИерархию) Тогда
		//Отчет
		ТекКлючВарианта = "";
		ТекИмяОтчета = "";
		ТекОтображатьСнимок = Ложь;
		
	Иначе
		//Вариант отчета
		ТекКлючВарианта = ТекущиеДанные.КлючВарианта;
		ТекИмяОтчета = ТекущиеДанные.ИмяОтчета;
		ТекОтображатьСнимок = Истина;
		
	КонеЦесли;
	
	ПоказатьСнимокОтчета(ТекИмяОтчета,ТекКлючВарианта,ТекОтображатьСнимок);

КонецПроцедуры

&НаСервере
Процедура ПоказатьСнимокОтчета(ИмяОтчета, КлючВарианта, ОтображатьСнимок)
	
	ВариантОтчета = НастройкиВариантовОтчетовДокументооборот.ПолучитьНастройкуВариантаОтчета(ИмяОтчета, КлючВарианта);
	
	Если (Не ОтображатьСнимок) Или (ВариантОтчета = Неопределено)  Тогда
		КартинкаОтчета = "";
		Возврат;
	КонецЕсли;
	
	ХранилищеСнимок = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВариантОтчета, "ХранилищеСнимокОтчета");
	ДвоичныеДанные = ХранилищеСнимок.Получить();
	
	ЕстьКартинка = ЗначениеЗаполнено(ДвоичныеДанные);
	
	Если НЕ ВариантОтчета.Пустая()И ЕстьКартинка Тогда
		
		КартинкаОтчета = ПолучитьНавигационнуюСсылку(ВариантОтчета.Ссылка, "ХранилищеСнимокОтчета");
			
	Иначе
		КартинкаОтчета = "";
			
	Конецесли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоОтчетов()
	
	// Кешируем список функциональных опций используемых для отчетов и их настройки использования
	КешФО = Новый ТаблицаЗначений;
	КешФО = ОбновитьКешФО();
	
	Дерево = РеквизитФормыВЗначение("ДеревоОтчетовИВариантов");
	Дерево.Строки.Очистить();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	&ПараметрКатегория
	| 
	|	НастройкиВариантовОтчетовДокументооборот.Наименование КАК Наименование,
	|	НастройкиВариантовОтчетовДокументооборот.КлючВарианта КАК КлючВарианта,
	|	НЕ НастройкиВариантовОтчетовДокументооборот.Пользовательский КАК Предопределенный,
	|	НастройкиВариантовОтчетовДокументооборот.Отчет
	|ИЗ
	|	Справочник.НастройкиВариантовОтчетовДокументооборот.Категории КАК ТаблицаКатегорий
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КатегорииОтчетов КАК КатегорииОтчетов
	|		ПО ТаблицаКатегорий.Категория = КатегорииОтчетов.Ссылка
	|			И (НЕ КатегорииОтчетов.ПометкаУдаления)";
	
	Если ЗначениеЗаполнено(СписокКатегорий) Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|			И ТаблицаКатегорий.Категория В(&СписокКатегорий)";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Раздел) Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиВариантовОтчетовДокументооборот.Размещение КАК ТаблицаРазделов
		|		ПО ТаблицаКатегорий.Ссылка = ТаблицаРазделов.Ссылка
		|			И ТаблицаРазделов.Раздел = &Раздел";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиВариантовОтчетовДокументооборот КАК НастройкиВариантовОтчетовДокументооборот
	|		ПО ТаблицаКатегорий.Ссылка = НастройкиВариантовОтчетовДокументооборот.Ссылка
	|			И (НЕ НастройкиВариантовОтчетовДокументооборот.ПометкаУдаления)
	|ГДЕ
	|	(НЕ НастройкиВариантовОтчетовДокументооборот.ТолькоДляАвтора
	|			ИЛИ НастройкиВариантовОтчетовДокументооборот.Автор = &ТекущийПользователь)
	|	И НЕ НастройкиВариантовОтчетовДокументооборот.Вспомогательный
	|
	|	 УПОРЯДОЧИТЬ ПО
	|		&ПорядокКатегория
	|	 	НастройкиВариантовОтчетовДокументооборот.Наименование";

	
	Если НеОтображатьИерархию Тогда
		ТекстЗапроса = ТекстЗапроса + " 
			|ИТОГИ ПО
			|	Общие
			|	";
	Иначе
		 ТекстЗапроса = ТекстЗапроса + " 
			|ИТОГИ ПО
			|	Категория
			|	";
		
	КонецЕсли;

	Если НеОтображатьИерархию Тогда
		
		ПараметрКатегория = "";
		ПорядокКатегория = "";
		
	Иначе
		
		ПараметрКатегория = "КатегорииОтчетов.Ссылка КАК Категория,";
		ПорядокКатегория = "КатегорииОтчетов.Наименование,";
		
	Конецесли;

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПараметрКатегория", ПараметрКатегория);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПорядокКатегория", ПорядокКатегория);

	
	ЗапросПоВариантам = Новый Запрос;
	ЗапросПоВариантам.Текст = ТекстЗапроса;
	
	ЗапросПоВариантам.УстановитьПараметр("ТекущийПользователь", 
							ПользователиКлиентСервер.ТекущийПользователь());
	ЗапросПоВариантам.УстановитьПараметр("СписокКатегорий", СписокКатегорий);
	
	Если ЗначениеЗаполнено(Раздел) Тогда
		
		Если ТипЗнч(Раздел) = Тип("Строка") Тогда
			
			Подсистема = Метаданные.Подсистемы.Найти(Раздел);
			ОтборРаздел = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Подсистема);
			
		Иначе
			
			ОтборРаздел = Раздел;
		
		КонецЕсли;
	
		ЗапросПоВариантам.УстановитьПараметр("Раздел", ОтборРаздел);
		
	КонецЕсли;
	
	ВыборкаКатегории = ЗапросПоВариантам.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаКатегории.Следующий() Цикл
		
		ВыборкаВариантОтчета = ВыборкаКатегории.Выбрать();
		
		// Добавляем Категорию
		Если НЕ НеОтображатьИерархию Тогда
			
			ВетвьОтчет = Дерево.Строки.Добавить();
			ВетвьОтчет.КлючВарианта = "";
			ВетвьОтчет.ИндексКартинки = 100;
		КонецЕсли;
		
		Пока ВыборкаВариантОтчета.Следующий() Цикл
			
			Эл = Метаданные.Отчеты.Найти(ВыборкаВариантОтчета.Отчет.Имя);
			// Проверяем права доступа на отчет
			Если (Эл =Неопределено) ИЛИ (НЕ ПравоДоступа("Использование", Эл)) Тогда
				Продолжить;
			КонецЕсли;

			// Проверяем возможность показа отчета по ФО
			Результат = КешФО.Найти(Эл.Имя, "Отчет");
			
			Если Не Результат = Неопределено И НЕ Результат.ФОВключена Тогда
				Продолжить;
			КонецЕсли;
			
			Если НЕ НеОтображатьИерархию Тогда
				Строка = ВетвьОтчет.Строки.Добавить();
								
			Иначе
				Строка = Дерево.Строки.Добавить();
								
			КонецЕсли;
			
			Строка.Синоним = ВыборкаВариантОтчета.Наименование;
			Строка.КлючВарианта = ВыборкаВариантОтчета.КлючВарианта;
			Строка.ИмяОтчета = ВыборкаВариантОтчета.Отчет.Имя;
			Строка.ИндексКартинки = ?(ВыборкаВариантОтчета.Предопределенный = Истина, 2, 1);
			
		КонецЦикла;
		
		Если НЕ НеОтображатьИерархию  И ЗначениеЗаполнено(ВыборкаКатегории.Категория)  Тогда
			
			ВетвьОтчет.Синоним = ВыборкаКатегории.Категория.Наименование + 
									" (" + Строка(ВетвьОтчет.Строки.Количество()) + ")";
									
		КонецЕсли;

	КонецЦикла;
		
	ЗначениеВДанныеФормы(Дерево, ДеревоОтчетовИВариантов);
	
КонецПроцедуры

&НаСервере
Функция  ОбновитьКешФО()
	
	Тз = Новый ТаблицаЗначений;
	Тз.Колонки.Добавить("Отчет", Новый ОписаниеТипов("Строка"));
	Тз.Колонки.Добавить("ФО", Новый ОписаниеТипов("Строка"));
	Тз.Колонки.Добавить("ФОВключена", Новый ОписаниеТипов("Булево"));
	
	Для Каждого Отчет из Метаданные.Отчеты Цикл
		
		Для Каждого ФО ИЗ Метаданные.ФункциональныеОпции Цикл
			Если ФО.Состав.Содержит(Отчет) Тогда
				НоваяСтрока = Тз.Добавить();
				НоваяСтрока.Отчет = Отчет.Имя;
				НоваяСтрока.ФО = ФО.Имя;
				НоваяСтрока.ФОВключена = ПолучитьФункциональнуюОпцию(НоваяСтрока.ФО);
			КонеЦесли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТЗ;

КонецФункции

&НаКлиенте
Процедура ОткрытьОтчетВыполнить()
	
	ТекущиеДанные = Элементы.ДеревоОтчетовИВариантов.ТекущиеДанные;
	Если ТекущиеДанные.ПолучитьРодителя() <> Неопределено Или НеОтображатьИерархию Тогда
		
		ПараметрыФормы = Новый Структура("КлючВарианта", ТекущиеДанные.КлючВарианта);
		ИмяФормыОтчета = "Отчет." + ТекущиеДанные.ИмяОтчета + ".ФормаОбъекта";
		ОткрытьФорму(ИмяФормыОтчета, ПараметрыФормы, , ИмяФормыОтчета + ТекущиеДанные.КлючВарианта);
		
	Иначе
		
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите какой-либо вариант отчета!'; en = 'Select a report option!'"));
		
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ЗаписатьНастройкиДереваКатегорий(КлючОбъектаНастроек, КлючВарианта, КатегорияСиноним)
	
	ХранилищеНастроекДанныхФорм.Сохранить(КлючОбъектаНастроек, "КлючВарианта", КлючВарианта);	
	ХранилищеНастроекДанныхФорм.Сохранить(КлючОбъектаНастроек, "КатегорияСиноним", КатегорияСиноним);

КонецПроцедуры

&НаСервере
Функция НеДостаточноВариантовДляГруппировки()
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	НастройкиВариантовОтчетовДокументооборот.КлючВарианта КАК КлючВарианта,
	|	НастройкиВариантовОтчетовДокументооборот.Отчет КАК Отчет
	|ИЗ
	|	Справочник.НастройкиВариантовОтчетовДокументооборот.Категории КАК ТаблицаКатегорий
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КатегорииОтчетов КАК КатегорииОтчетов
	|		ПО ТаблицаКатегорий.Категория = КатегорииОтчетов.Ссылка
	|			И (НЕ КатегорииОтчетов.ПометкаУдаления)";
	
	Если ЗначениеЗаполнено(СписокКатегорий) Тогда
		Запрос.Текст = Запрос.Текст + "
		|			И ТаблицаКатегорий.Категория В(&СписокКатегорий)";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Раздел) Тогда
		Запрос.Текст = Запрос.Текст + "
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиВариантовОтчетовДокументооборот.Размещение КАК ТаблицаРазделов
		|		ПО ТаблицаКатегорий.Ссылка = ТаблицаРазделов.Ссылка
		|			И ТаблицаРазделов.Раздел = &Раздел";
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + "
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиВариантовОтчетовДокументооборот КАК НастройкиВариантовОтчетовДокументооборот
	|		ПО ТаблицаКатегорий.Ссылка = НастройкиВариантовОтчетовДокументооборот.Ссылка
	|			И (НЕ НастройкиВариантовОтчетовДокументооборот.ПометкаУдаления)
	|ГДЕ
	|	(НЕ НастройкиВариантовОтчетовДокументооборот.ТолькоДляАвтора
	|			ИЛИ НастройкиВариантовОтчетовДокументооборот.Автор = &ТекущийПользователь)";
	
	Запрос.УстановитьПараметр("ТекущийПользователь", 
									ПользователиКлиентСервер.ТекущийПользователь());
	Запрос.УстановитьПараметр("СписокКатегорий", СписокКатегорий);
	
	Если ЗначениеЗаполнено(Раздел) Тогда
		
		Если ТипЗнч(Раздел) = Тип("Строка") Тогда
			
			Подсистема = Метаданные.Подсистемы.Найти(Раздел);
			ОтборРаздел = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Подсистема); 
			
		Иначе
			
			ОтборРаздел = Раздел;
		
		КонецЕсли;
	
		Запрос.УстановитьПараметр("Раздел",	ОтборРаздел);
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();

	Кол = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Эл = Метаданные.Отчеты.Найти(Выборка.Отчет.Имя);
		// Проверяем права доступа на отчет
		Если (Эл = Неопределено) ИЛИ (НЕ ПравоДоступа("Использование", Эл)) Тогда
			Продолжить;
		КонецЕсли;
		Кол = Кол +1;
	КонецЦикла;
	
	// Если в дереве категорий получается больше 7 элементов, то строим дерево. Меньше не строим.
	Если Кол > 7 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

&НаСервере
Процедура СформироватьГиперссылкуНаОтчетыРаздела()
	
	Если ЗначениеЗаполнено(РазделГипперссылка) Тогда
		Элементы.ОтчетыРаздела.Видимость = Истина;
		Элементы.ОтчетыРаздела.Заголовок = СтрШаблон(НСтр("ru = 'Все отчеты раздела %1'; en = 'All section %1 reports'"), РазделГипперссылка.Синоним);
	Иначе
		Элементы.ОтчетыРаздела.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти



