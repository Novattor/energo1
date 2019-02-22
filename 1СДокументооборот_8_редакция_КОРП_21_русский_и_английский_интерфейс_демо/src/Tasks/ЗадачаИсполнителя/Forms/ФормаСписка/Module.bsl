
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("РежимВыбора") И Параметры.РежимВыбора Тогда 
		КлючНазначенияИспользования = "Выбор";
		Элементы.Список.РежимВыбора = Истина;
		Элементы.Создать.Видимость = Ложь;
		Элементы.Выбрать.Видимость = Истина;
		Элементы.Выбрать.КнопкаПоУмолчанию = Истина;
		Элементы.ВыбратьКомПанель.Видимость = Истина;
		Элементы.СписокКонтекстноеМенюВыбрать.Видимость = Истина;
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокФормы") И ЗначениеЗаполнено(Параметры.ЗаголовокФормы) Тогда 
		Заголовок = Параметры.ЗаголовокФормы;
		АвтоЗаголовок = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("БизнесПроцесс") Тогда
		СтрокаБизнесПроцесса = Параметры.БизнесПроцесс;
		СтрокаЗадачи = Параметры.Задача;
		Элементы.ГруппаЗаголовок.Видимость = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("ВидимостьОтборов") Тогда
		Элементы.ГруппаОтбор.Видимость = Параметры.ВидимостьОтборов;
	КонецЕсли;
	
	Если ПоИсполнителю = Неопределено Тогда
		ПоИсполнителю = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
	ПоказыватьУдаленные = Ложь;
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
	Если Параметры.Свойство("ПоказыватьЗадачи") Тогда
		ПоказыватьЗадачи = Параметры.ПоказыватьЗадачи;
	Иначе	
		ПоказыватьЗадачи = 0;
	КонецЕсли;
	
	НастройкиОтбора = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы + "/ТекущиеДанные");
	Если Не ЗначениеЗаполнено(НастройкиОтбора) Тогда
		УстановитьОтбор();
		
		ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ПоказыватьЗадачи,
			ПоказыватьЗадачи, 0);
		ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ПоАвтору, ПоАвтору);
		ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ПоИсполнителю, ПоИсполнителю);
		ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ПоПроекту, ПоПроекту);
		ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ТочкаМаршрута, ТочкаМаршрута);
	КонецЕсли;
	
	Если Параметры.Свойство("БлокировкаОкнаВладельца") Тогда
		РежимОткрытияОкна = Параметры.БлокировкаОкнаВладельца;
	КонецЕсли;	
		
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	ФорматДатыДляКолонок = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДФ='dd.MM.yyyy HH:mm'", "ДЛФ=D");
	
	Элементы.Дата.Формат = ФорматДатыДляКолонок;
	Элементы.СрокИсполнения.Формат = ФорматДатыДляКолонок;
	Элементы.ДатаИсполнения.Формат = ФорматДатыДляКолонок;
	
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список.УсловноеОформление);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,
		"ИспользоватьДатуИВремяВСрокахЗадач",
		ИспользоватьДатуИВремяВСрокахЗадач,
		Истина);
	
	// автообновление
	Если ОбщегоНазначенияДокументооборот.ПриложениеЯвляетсяВебКлиентом() Тогда
		Элементы.Автообновление.Видимость = Ложь;
	Иначе
		НастройкиАвтообновления = Автообновление.ПолучитьНастройкиАвтообновленияФормы(ЭтаФорма);
		Элементы.Автообновление.Видимость = Истина;		
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	
	// Контроль
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда 
		Элементы.СостояниеКонтроля.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ВозможноеОтсутствие") И Параметры.ВозможноеОтсутствие <> Неопределено Тогда
		МассивСсылок = БизнесПроцессыИЗадачиСервер.ПолучитьЗадачиПользователя(
			Параметры.ВозможноеОтсутствие.ДатаНачала,
			Параметры.ВозможноеОтсутствие.ДатаОкончания,
			Параметры.ВозможноеОтсутствие.Сотрудник);
		Список.Параметры.УстановитьЗначениеПараметра("МассивСсылок", МассивСсылок);
		
		Элементы.ГруппаОтбор.Видимость = Ложь;
		Элементы.ГруппаСостояние.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("МассивСсылок") Тогда
		
		Список.Параметры.УстановитьЗначениеПараметра("МассивСсылок", Параметры.МассивСсылок);
		
		Элементы.ГруппаОтбор.Видимость = Ложь;
		Элементы.ГруппаСостояние.Видимость = Ложь;
	КонецЕсли;
	
	СформироватьТаблицуТочекМаршрута();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если Не ВебКлиент Тогда
		УстановитьАвтообновлениеФормы();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗадачаИзменена" И Источник <> ЭтаФорма
		Или ИмяСобытия = "БизнесПроцессСтартован" Тогда
		
		Элементы.Список.Обновить();
		
	ИначеЕсли ИмяСобытия = "ИзменилсяФлаг"
		И ТипЗнч(Параметр[0]) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда

		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ЗаписьКонтроля" Тогда
		Если ЗначениеЗаполнено(Параметр.Предмет)
			И ТипЗнч(Параметр.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда 
			ОповеститьОбИзменении(Параметр.Предмет);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
	УстановитьОтбор();
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ПоказыватьЗадачи,
		ПоказыватьЗадачи, 0);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ПоАвтору, ПоАвтору);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ПоИсполнителю, ПоИсполнителю);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ПоПроекту, ПоПроекту);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ТочкаМаршрута, ТочкаМаршрута);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПоИсполнителюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникНачалоВыбора(
		Элемент, ПоИсполнителю, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюПриИзменении(Элемент)
	
	УстановитьОтбор();
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ПоИсполнителю);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюОчистка(Элемент, СтандартнаяОбработка)
	
	ПоИсполнителю = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТочкаМаршрутаПриИзменении(Элемент)
	
	УстановитьОтбор();
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ТочкаМаршрута);
	
КонецПроцедуры

&НаКлиенте
Процедура ТочкаМаршрутаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", ТочкаМаршрута);
	
	ОткрытьФорму("ОбщаяФорма.ВыборТочкиМаршрута", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ТочкаМаршрутаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		ДанныеВыбора = СформироватьДанныеВыбораТочкиМаршрута(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТочкаМаршрутаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораТочкиМаршрута(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьЗадачиПриИзменении(Элемент)
	
	УстановитьОтбор();
	
	Если ЗначениеЗаполнено(ПоказыватьЗадачи) Тогда 
		Элемент.ЦветФона = ОбщегоНазначенияКлиент.ЦветСтиля("ФонУправляющегоПоля");
	Иначе
		Элемент.ЦветФона = Новый Цвет();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоАвторуПриИзменении(Элемент)
	
	УстановитьОтбор();
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ПоАвтору);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПроектуПриИзменении(Элемент)
	
	УстановитьОтбор();
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ПоПроекту);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.Список.РежимВыбора
		И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ОповеститьОВыборе(Элементы.Список.ТекущиеДанные.Ссылка);
	Иначе 
		БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ОткрытьФорму("ОбщаяФорма.СозданиеБизнесПроцесса");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	БизнесПроцессыИЗадачиКлиент.СписокЗадачПередНачаломИзменения(Элемент, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ПоказатьЗначение(, ТекущиеДанные.БизнесПроцесс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиАвтообновление(Команда)
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения(
			"ЗадачиАвтообновлениеПродолжение",
			ЭтотОбъект);
	
	АвтообновлениеКлиент.УстановитьПараметрыАвтообновленияФормы(
		ЭтаФорма,
		НастройкиАвтообновления,
		ОписаниеОповещения);

	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиАвтообновлениеПродолжение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		НастройкиАвтообновления = Результат;
		УстановитьАвтообновлениеФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОбновитьПараметрыУсловногоОформленияПросроченныхЗадач(
		Список.УсловноеОформление);
		
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчеты(Команда)
		
	Раздел = ПредопределенноеЗначение("Перечисление.РазделыОтчетов.ЗадачиСписок");
	
	ЗаголовокФормы = НСтр("ru = 'Отчеты по задачам'; en = 'Reports on tasks'");
	
	РазделГипперссылка = НастройкиВариантовОтчетовДокументооборот.ПолучитьРазделОтчетаПоИмени("УправлениеБизнесПроцессами");

	ПараметрыФормы = Новый Структура("Раздел, ЗаголовокФормы, НеОтображатьИерархию, РазделГипперссылка", 
										Раздел, ЗаголовокФормы, Истина, РазделГипперссылка);
										
	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма.ФормаПоКатегориям",
		ПараметрыФормы,
		ЭтаФорма, 
		"ЗадачиСписок");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_Подзадачи

&НаКлиенте
Процедура ПроцессСогласование(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Согласование");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессУтверждение(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Утверждение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессРегистрация(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Регистрация");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессРассмотрение(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Рассмотрение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессИсполнение(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Исполнение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОзнакомление(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Ознакомление");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессПриглашение(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Приглашение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОбработка(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("КомплексныйПроцесс");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникСозданияОсновныхПроцессов(ТипыОпераций)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Задача = Неопределено;
	Иначе
		Задача = ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		ТипыОпераций, Задача, ЭтаФорма, "ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтбор()
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоАвтору", ПоАвтору);
	ПараметрыОтбора.Вставить("ПоИсполнителю", ПоИсполнителю);
	ПараметрыОтбора.Вставить("ПоказыватьЗадачи", ПоказыватьЗадачи);
	ПараметрыОтбора.Вставить("ПоПроекту", ПоПроекту);
	ПараметрыОтбора.Вставить("ТочкаМаршрута", ТочкаМаршрута);
	Параметрыотбора.Вставить("ПоказыватьУдаленные", ПоказыватьУдаленные);
	
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	ПоАвтору = ПараметрыОтбора["ПоАвтору"];
	Если ЗначениеЗаполнено(ПоАвтору) Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Автор", ПоАвтору);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Автор");
	КонецЕсли;
	
	ТочкаМаршрута = ПараметрыОтбора["ТочкаМаршрута"];
	Если ЗначениеЗаполнено(ТочкаМаршрута) Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ТочкаМаршрута", ТочкаМаршрута);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ТочкаМаршрута");
	КонецЕсли;
	
	ПоИсполнителю = ПараметрыОтбора["ПоИсполнителю"];
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Исполнитель");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "РольИсполнителя");
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,
		"Исполнитель",
		Неопределено,
		Ложь);
				
	Если ЗначениеЗаполнено(ПоИсполнителю) Тогда
		
		Если ТипЗнч(ПоИсполнителю) = Тип("СправочникСсылка.ПолныеРоли") Тогда 
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "РольИсполнителя", ПоИсполнителю);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Исполнитель", Справочники.Пользователи.ПустаяСсылка());
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
				Список,
				"Исполнитель",
				ПоИсполнителю);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда
		ПоПроекту = ПараметрыОтбора["ПоПроекту"];
		Если ЗначениеЗаполнено(ПоПроекту) Тогда 
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Проект", ПоПроекту);
		Иначе
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Проект");
		КонецЕсли;
	КонецЕсли;	
	
	ПоказыватьЗадачи = ПараметрыОтбора["ПоказыватьЗадачи"];
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Выполнена");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "СостояниеБизнесПроцесса");
	Если ЗначениеЗаполнено(ПоказыватьЗадачи) Тогда
		Если ПоказыватьЗадачи = 1 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Выполнена", Истина);
		ИначеЕсли ПоказыватьЗадачи = 2 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Выполнена", Ложь);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"СостояниеБизнесПроцесса", Перечисления.СостоянияБизнесПроцессов.Активен);
		ИначеЕсли ПоказыватьЗадачи = 3 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Выполнена", Ложь);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"СостояниеБизнесПроцесса", Перечисления.СостоянияБизнесПроцессов.Остановлен);
		ИначеЕсли ПоказыватьЗадачи = 4 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Выполнена", Ложь);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"СостояниеБизнесПроцесса", Перечисления.СостоянияБизнесПроцессов.Прерван);
		КонецЕсли;
	КонецЕсли;
	
	ПоказыватьУдаленные = ПараметрыОтбора["ПоказыватьУдаленные"];
	Если ПоказыватьУдаленные = Истина Тогда 
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ПометкаУдаления");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ПометкаУдаления", 
			Ложь);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьАвтообновлениеФормы()
	
	Если ТипЗнч(НастройкиАвтообновления) = Тип("Структура")
		И НастройкиАвтообновления.Автообновление Тогда
		ПодключитьОбработчикОжидания("Автообновление", НастройкиАвтообновления.ПериодАвтоОбновления, Ложь);
	Иначе
		ОтключитьОбработчикОжидания("Автообновление");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Автообновление()
	
	Если ТипЗнч(НастройкиАвтообновления) <> Тип("Структура")
		Или (ТипЗнч(НастройкиАвтообновления) = Тип("Структура")
		И Не НастройкиАвтообновления.Автообновление) Тогда
		ОтключитьОбработчикОжидания("Автообновление");
	Иначе
		ОбновитьСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСервер()

	Элементы.Список.Обновить();

КонецПроцедуры

&НаСервере
Процедура СформироватьТаблицуТочекМаршрута()
	
	Для Каждого БизнесПроцесс Из Метаданные.БизнесПроцессы Цикл
		
		ТочкиМаршрута = БизнесПроцессы[БизнесПроцесс.Имя].ТочкиМаршрута;
		Для Каждого СтрокаТочкаМаршрута Из ТочкиМаршрута Цикл
			Если СтрокаТочкаМаршрута.Вид = ВидТочкиМаршрутаБизнесПроцесса.Действие Тогда 
				СтрокаТаблицы = ТаблицаТочекМаршрута.Добавить();
				СтрокаТаблицы.ТочкаМаршрута = СтрокаТочкаМаршрута;
				СтрокаТаблицы.Представление = Строка(СтрокаТочкаМаршрута) + " ("
					+ Строка(БизнесПроцесс.Имя) + ")";
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СформироватьДанныеВыбораТочкиМаршрута(Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	Текст = ВРег(Текст);
	
	Для Каждого Строка Из ТаблицаТочекМаршрута Цикл
		Если ВРег(Лев(Строка.ТочкаМаршрута, СтрДлина(Текст))) = Текст Тогда 
			ДанныеВыбора.Добавить(Строка.ТочкаМаршрута, Строка.Представление);
		КонецЕсли;
	КонецЦикла;
		
	Возврат ДанныеВыбора;
	
КонецФункции

#КонецОбласти
