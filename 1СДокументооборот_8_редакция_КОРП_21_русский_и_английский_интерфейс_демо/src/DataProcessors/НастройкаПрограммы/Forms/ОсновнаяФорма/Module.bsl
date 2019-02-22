#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда 
		Элементы.ГруппаДанныеПредприятия.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаИПП.Видимость = ИнтернетПоддержкаПользователейВызовСервера.ДоступнаНастройкаПараметровПодключенияКИнтернетПоддержке();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбщиеНастройки(Команда)
	
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.ОбщиеНастройки",, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.ПраваДоступа",, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеПредприятия(Команда)
	
	ОткрытьФорму("Справочник.Организации.ФормаОбъекта", Новый Структура("Ключ", РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию()));
	
КонецПроцедуры

&НаКлиенте
Процедура Делопроизводство(Команда)
	
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.Делопроизводство",, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура Файлы(Команда)
	
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.Файлы",, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтернетПоддержка(Команда)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьФормуНастроекПараметровПодключения(ЭтаФорма, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессыИЗадачи(Команда)
	
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.ПроцессыИЗадачи",, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбменДанными(Команда)
	
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.ОбменДанными",, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектыИТрудозатраты(Команда)
	
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.ПроектыИТрудозатраты",, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура Почта(Команда)
	
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.Почта",, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещенияОПроблемах(Команда)
	
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.ОповещенияОПроблемах",, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура Контрагенты(Команда)
	
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.Контрагенты",, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

#КонецОбласти
