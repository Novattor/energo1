&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ВидПапки = Перечисления.ВидыПапокПисем.Общая;
		Объект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	
	Если РегистрыСведений.ПапкиПисемБыстрогоДоступа.ЭтоПапкаПисемБыстрогоДоступа(Объект.Ссылка) Тогда
		ВключитьВМоиПапки = Истина;
	Иначе
		ВключитьВМоиПапки = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаОчисткаПапки.Видимость =
		Объект.ВидПапки = Перечисления.ВидыПапокПисем.Общая 
		Или Объект.ВидПапки = Перечисления.ВидыПапокПисем.Корзина;
		
	Если ЗначениеЗаполнено(Объект.Ссылка) И Элементы.ГруппаОчисткаПапки.Видимость Тогда
		
		ПериодУстаревания = РегистрыСведений.НастройкиАвтоочисткиПапокПисем.ПолучитьПериодУстареванияПисем(Объект.Ссылка);
		Если ПериодУстаревания <> Неопределено Тогда
			ВключитьАвтоОчисткуПапки = Истина;
			ПериодУстареванияПисем = ПериодУстаревания;
		КонецЕсли;
		Элементы.ПериодУстареванияПисем.АвтоОтметкаНезаполненного = ВключитьАвтоОчисткуПапки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПрав(Команда)
	
	ИмяОсновногоРеквизита = "Объект";
	ИмяПодчиненнойФормы = "ОбщаяФорма.НастройкиПравПапок";
	
	ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
		|Выполнение команды ""Настройка прав"" возможно только после записи данных.
		|Данные будут записаны.';
		|en = 'The data have not yet been saved.
		|Performing the command ""Permissions setting"" is possible only after the data is saved.
		|Data will be saved.'");
	
	ДокументооборотПраваДоступаКлиент.ЗаписатьОбъектЕслиНовыйИОткрытьПодчиненнуюФорму(
		ЭтаФорма, ИмяОсновногоРеквизита, ТекстВопроса, ИмяПодчиненнойФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ПапкаПисемСохранена", Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВМоиПапкиПриИзменении(Элемент)
	
	ВключитьВМоиПапкиПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ВключитьВМоиПапкиПриИзмененииСервер()
	
	РегистрыСведений.ПапкиПисемБыстрогоДоступа.УстановитьБыстрыйДоступДляПапки(Объект.Ссылка, ВключитьВМоиПапки);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина
		И ВключитьВМоиПапки Тогда	
		
		РегистрыСведений.ПапкиПисемБыстрогоДоступа.УстановитьБыстрыйДоступДляПапки(ТекущийОбъект.Ссылка, ВключитьВМоиПапки);
		
	КонецЕсли;
	
	РегистрыСведений.НастройкиАвтоочисткиПапокПисем.УстановитьАвтоОчисткуПапки(
		ТекущийОбъект.Ссылка, ПериодУстареванияПисем, ВключитьАвтоОчисткуПапки);
	
	КонецПроцедуры
	
&НаКлиенте
Процедура ВключитьАвтоОчисткуПапкиПриИзменении(Элемент)
	
	Модифицированность = Истина;
	Элементы.ПериодУстареванияПисем.АвтоОтметкаНезаполненного = ВключитьАвтоОчисткуПапки;
	
КонецПроцедуры


