#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Настройки штрихкода
	НастройкиШтрихкода = ШтрихкодированиеСервер.ПолучитьПерсональныеНастройкиПоложенияШтрихкодаНаСтранице();
	ПоказыватьФормуНастройкиПоложения = НастройкиШтрихкода.ПоказыватьФормуНастройки;
	ПоложениеШтрихкода = НастройкиШтрихкода.ПоложениеНаСтранице;
	СмещениеПоГоризонтали = НастройкиШтрихкода.СмещениеПоГоризонтали;
	СмещениеПоВертикали = НастройкиШтрихкода.СмещениеПоВертикали;
	РазмерНаклейкиШКВерт = НастройкиШтрихкода.ВысотаНаклейки;
	РазмерНаклейкиШКГор = НастройкиШтрихкода.ШиринаНаклейки;
	ВставлятьЦифрыВШК = НастройкиШтрихкода.ПоказыватьЦифры;
	
	СмещениеПоГоризонтали_Сохр = СмещениеПоГоризонтали;
	СмещениеПоВертикали_Сохр = СмещениеПоВертикали;
	
	ОриентацияСтраницы = "Портретная";
	
	ВысотаШтрихкодаПриВставкеВФайл = НастройкиШтрихкода.ВысотаШК;
	Если Не ЗначениеЗаполнено(ВысотаШтрихкодаПриВставкеВФайл)
		Или ВысотаШтрихкодаПриВставкеВФайл < 10 И Не ВставлятьЦифрыВШК
		Или ВысотаШтрихкодаПриВставкеВФайл < 13 И ВставлятьЦифрыВШК Тогда
		Если ВставлятьЦифрыВШК Тогда
			ВысотаШтрихкодаПриВставкеВФайл = 13;
		Иначе
			ВысотаШтрихкодаПриВставкеВФайл = 10;
		КонецЕсли;
	КонецЕсли;
	РежимИспользованияНастроек = 1;
	ПереключитьСтандартныеЗначенияНастроек();
	
	Если ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ПроизвольноеПоложение Тогда
		СмещениеПоГоризонтали = СмещениеПоГоризонтали_Сохр;
		СмещениеПоВертикали = СмещениеПоВертикали_Сохр;
	КонецЕсли;	
	
	ИнформацияОСистеме = Новый СистемнаяИнформация;
	Если ИнформацияОСистеме.ТипПлатформы = ТипПлатформы.Windows_x86
		Или ИнформацияОСистеме.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		ТипОС = "Windows";
	ИначеЕсли ИнформацияОСистеме.ТипПлатформы = ТипПлатформы.Linux_x86
		Или ИнформацияОСистеме.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		ТипОС = "Linux";
	КонецЕсли;
	ПараметрыСканера = ШтрихкодированиеСервер.ЗагрузитьПараметрыПодключенияСканера(ТипОС);
	Если ПараметрыСканера = Неопределено Тогда
		СтатусПодключенияСканераШтрихкодов = НСтр("ru = 'Не подключен'; en = 'Not connected'");
	Иначе
		СтатусПодключенияСканераШтрихкодов = НСтр("ru = 'Подключен к порту '; en = 'Connected to port '") + ПараметрыСканера.Порт; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("ПерсональныеНастройки_Закрытие");
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПередЗакрытиемПродолжение",
		ЭтотОбъект);
	ПоказатьВопрос(
		ОписаниеОповещения,
		НСтр("ru = 'Данные были изменены. Сохранить изменения?'; en = 'Data has been changed. Save changes?'"),
		РежимДиалогаВопрос.ДаНетОтмена,,
		КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	Если НеобходимостьОбновленияИнтерфейса Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПоложениеШтрихкодаПриИзменении(Элемент)
	
	ПереключитьСтандартныеЗначенияНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ВысотаШтрихкодаПриВставкеВФайлОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВысотаШтрихкодаПриВставкеВФайл = 21;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставлятьЦифрыВШКПриИзменении(Элемент)
	
	ПоложениеШтрихкодаПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЛевоВерхНажатие(Элемент)
	
	ПоложениеШтрихкода = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ЛевыйВерхний");
	Модифицированность = Истина;
	ПереключитьСтандартныеЗначенияНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПравоВерхНажатие(Элемент)
	
	ПоложениеШтрихкода = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ПравыйВерхний");
	Модифицированность = Истина;
	ПереключитьСтандартныеЗначенияНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЛевоНизНажатие(Элемент)

	ПоложениеШтрихкода = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ЛевыйНижний");
	Модифицированность = Истина;
	ПереключитьСтандартныеЗначенияНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПравоНизНажатие(Элемент)
	
	ПоложениеШтрихкода = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ПравыйНижний");
	Модифицированность = Истина;
	ПереключитьСтандартныеЗначенияНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроизвольноеПоложениеПриИзменении(Элемент)
	
	ПоложениеШтрихкода = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ПроизвольноеПоложение");
	Модифицированность = Истина;
	ПереключитьСтандартныеЗначенияНастроек();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если Применить() Тогда
		Закрыть(КодВозвратаДиалога.ОК);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСканерШтрихкодов(Команда)
	
	// Обновление текущих настроек сканера
	
	// Получим форму настройки торгового оборудования
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НастроитьСканерШтрихкодовПродолжение",
		ЭтотОбъект);
	
	ОткрытьФорму("Справочник.НастройкиОборудования.ФормаВыбора", 
		Новый Структура("РежимВыбора", Истина),,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытиемПродолжение(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		СохранитьНастройки();
		НеобходимостьОбновленияИнтерфейса = Истина;
		Модифицированность = Ложь;
		Закрыть();
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	Иначе
		Модифицированность = Ложь;
		Если ЭтаФорма.Открыта() Тогда
			ЭтаФорма.Закрыть();
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Функция Применить()
	
	Если ВысотаШтрихкодаПриВставкеВФайл < 10
		И Не ВставлятьЦифрыВШК Тогда
		ОчиститьСообщения();
		ТекстСообщения = НСтр("ru = 'Введена слишком маленькая высота штрихкода. Минимальная высота штрихкода без вставки цифр составляет 10 мм.'; en = 'Specified barcode height is too small. Minimal barcode height without digits is 10 mm.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,, "ВысотаШтрихкодаПриВставкеВФайл");
		Возврат Ложь;
	КонецЕсли;
	
	Если ВысотаШтрихкодаПриВставкеВФайл < 13
		И ВставлятьЦифрыВШК Тогда
		ОчиститьСообщения();
		ТекстСообщения = НСтр("ru = 'Введена слишком маленькая высота штрихкода. Минимальная высота штрихкода со вставкой цифр составляет 13 мм.'; en = 'Specified barcode height is too small. Minimal barcode height without digits is 10 mm.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,, "ВысотаШтрихкодаПриВставкеВФайл");
		Возврат Ложь;
	КонецЕсли;
	
	СохранитьНастройки();
	НеобходимостьОбновленияИнтерфейса = Истина;
	Модифицированность = Ложь;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура СохранитьНастройки()
	
	МассивСтруктур = Новый Массив;
	
	// НастройкиШтрихкода
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиШтрихкода", "ПоказыватьФормуНастройкиШтрихкода", ПоказыватьФормуНастройкиПоложения);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиШтрихкода", "ПоложениеШтрихкодаНаСтранице", ПоложениеШтрихкода);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиШтрихкода", "СмещениеПоГоризонтали", СмещениеПоГоризонтали);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиШтрихкода", "СмещениеПоВертикали", СмещениеПоВертикали);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиШтрихкода", "ШиринаНаклейки", РазмерНаклейкиШКГор);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиШтрихкода", "ВысотаНаклейки", РазмерНаклейкиШКВерт);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиШтрихкода", "ВысотаШтрихкодаПриВставкеВФайл", ВысотаШтрихкодаПриВставкеВФайл);	
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиШтрихкода", "ВставлятьЦифрыВШК", ВставлятьЦифрыВШК);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтруктуруНастройки(МассивСтруктур, Объект, Настройка = Неопределено, Значение)
	
	МассивСтруктур.Добавить(Новый Структура ("Объект, Настройка, Значение", Объект, Настройка, Значение));
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьСтандартныеЗначенияНастроек()
	
	Элементы.СмещениеПоГоризонтали.Доступность = Ложь;
	Элементы.СмещениеПоВертикали.Доступность = Ложь;
	Элементы.СмещениеПоГоризонтали.Маска = "";
	Элементы.СмещениеПоВертикали.Маска = "";
	Элементы.ГруппаОтступСверху.Доступность = Ложь;
	Элементы.ГруппаОтступСлева.Доступность = Ложь;

	Если ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ПравыйНижний Тогда
		СмещениеПоГоризонтали = "MAX";
		СмещениеПоВертикали = "MAX";
	ИначеЕсли ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ПравыйВерхний Тогда
		СмещениеПоГоризонтали = "MAX";
		СмещениеПоВертикали = "MIN";
	ИначеЕсли ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ЛевыйВерхний Тогда
		СмещениеПоГоризонтали = "MIN";
		СмещениеПоВертикали = "MIN";
	ИначеЕсли ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ЛевыйНижний Тогда
		СмещениеПоГоризонтали = "MIN";
		СмещениеПоВертикали = "MAX";
	Иначе
		Элементы.СмещениеПоГоризонтали.Доступность = Истина;
		Элементы.СмещениеПоВертикали.Доступность = Истина;
		Элементы.СмещениеПоГоризонтали.Маска = "999";
		Элементы.СмещениеПоВертикали.Маска = "999";
		СмещениеПоГоризонтали = 0;
		СмещениеПоВертикали = 0;
		Элементы.ГруппаОтступСверху.Доступность = Истина;
		Элементы.ГруппаОтступСлева.Доступность = Истина;
	КонецЕсли;
	
	ПроизвольноеПоложение = (ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ПроизвольноеПоложение);
	
	Если ОриентацияСтраницы = "Альбомная" Тогда
		Элементы.ДекорацияЛевоВерх.Картинка = БиблиотекаКартинок.ШтрихкодЛевоВерхАльбомная;
	Иначе
		Элементы.ДекорацияЛевоВерх.Картинка = БиблиотекаКартинок.ШтрихкодЛевоВерх;
	КонецЕсли;	
	
	Если ОриентацияСтраницы = "Альбомная" Тогда
		Элементы.ДекорацияПравоВерх.Картинка = БиблиотекаКартинок.ШтрихкодПравоВерхАльбомная;
	Иначе
		Элементы.ДекорацияПравоВерх.Картинка = БиблиотекаКартинок.ШтрихкодПравоВерх;
	КонецЕсли;	
	
	Если ОриентацияСтраницы = "Альбомная" Тогда
		Элементы.ДекорацияЛевоНиз.Картинка = БиблиотекаКартинок.ШтрихкодЛевоНизАльбомная;
	Иначе
		Элементы.ДекорацияЛевоНиз.Картинка = БиблиотекаКартинок.ШтрихкодЛевоНиз;
	КонецЕсли;	
	
	Если ОриентацияСтраницы = "Альбомная" Тогда
		Элементы.ДекорацияПравоНиз.Картинка = БиблиотекаКартинок.ШтрихкодПравоНизАльбомная;
	Иначе
		Элементы.ДекорацияПравоНиз.Картинка = БиблиотекаКартинок.ШтрихкодПравоНиз;
	КонецЕсли;	
	
	Если ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ПравыйНижний Тогда
		Если ОриентацияСтраницы = "Альбомная" Тогда
			Элементы.ДекорацияПравоНиз.Картинка = БиблиотекаКартинок.ШтрихкодПравоНизВыделенАльбомная;
		Иначе
			Элементы.ДекорацияПравоНиз.Картинка = БиблиотекаКартинок.ШтрихкодПравоНизВыделен;
		КонецЕсли;	
		
	ИначеЕсли ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ПравыйВерхний Тогда
		
		Если ОриентацияСтраницы = "Альбомная" Тогда
			Элементы.ДекорацияПравоВерх.Картинка = БиблиотекаКартинок.ШтрихкодПравоВерхВыделенАльбомная;
		Иначе
			Элементы.ДекорацияПравоВерх.Картинка = БиблиотекаКартинок.ШтрихкодПравоВерхВыделен;
		КонецЕсли;	
		
	ИначеЕсли ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ЛевыйВерхний Тогда
		
		Если ОриентацияСтраницы = "Альбомная" Тогда
			Элементы.ДекорацияЛевоВерх.Картинка = БиблиотекаКартинок.ШтрихкодЛевоВерхВыделенАльбомная;
		Иначе
			Элементы.ДекорацияЛевоВерх.Картинка = БиблиотекаКартинок.ШтрихкодЛевоВерхВыделен;
		КонецЕсли;	
		
	ИначеЕсли ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ЛевыйНижний Тогда
		
		Если ОриентацияСтраницы = "Альбомная" Тогда
			Элементы.ДекорацияЛевоНиз.Картинка = БиблиотекаКартинок.ШтрихкодЛевоНизВыделенАльбомная;
		Иначе
			Элементы.ДекорацияЛевоНиз.Картинка = БиблиотекаКартинок.ШтрихкодЛевоНизВыделен;
		КонецЕсли;			
		
	КонецЕсли; 
	
	УстановитьИндексКартинки();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИндексКартинки()
	
	КартинкаДляПредпросмотра = -1;
	
	Если СмещениеПоГоризонтали = "MIN" Тогда
		КартинкаДляПредпросмотра = КартинкаДляПредпросмотра + 1;
	ИначеЕсли СмещениеПоГоризонтали = "MAX" Тогда
		КартинкаДляПредпросмотра = КартинкаДляПредпросмотра + 3;
	КонецЕсли;
	
	Если СмещениеПоВертикали = "MAX" Тогда
		КартинкаДляПредпросмотра = КартинкаДляПредпросмотра + 1;
	КонецЕсли;
	
	Если НЕ Элементы.СмещениеПоГоризонтали.Доступность Тогда 
	
		Если РежимИспользованияНастроек = 1 Тогда 
			КартинкаДляПредпросмотра = 2 * КартинкаДляПредпросмотра + 12;	
		ИначеЕсли РежимИспользованияНастроек = 0 И ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкоды") Тогда 
			КартинкаДляПредпросмотра = 2 * КартинкаДляПредпросмотра + 4;
		ИначеЕсли РежимИспользованияНастроек = 2 Тогда 
			КартинкаДляПредпросмотра = КартинкаДляПредпросмотра + 20;
		КонецЕсли;
		
		Если РежимИспользованияНастроек < 2 Тогда 
			Если ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкоды") и Не ВставлятьЦифрыВШК Тогда
				КартинкаДляПредпросмотра = КартинкаДляПредпросмотра + 1;	
			КонецЕсли;
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСканерШтрихкодовПродолжение(ВыбранныеНастройки, Параметры) Экспорт 
	
	// Если настройки выбраны - осуществляем попытку подключения сканера
	Если ВыбранныеНастройки <> Неопределено Тогда
		
		СисИнфо = Новый СистемнаяИнформация;
		
		Если СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86
			Или СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
			
			ТипОС = "Windows";
			
		ИначеЕсли СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86
			Или СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
			
			ТипОС = "Linux";
			
		КонецЕсли;
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ТипОС", ТипОС);
		ПараметрыОповещения.Вставить("ВыбранныеНастройки", ВыбранныеНастройки);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"УстановкаВнешнейКомпонентыДрайверСканераШтрихкодов",
			ЭтотОбъект,
			ПараметрыОповещения);
		
		НачатьУстановкуВнешнейКомпоненты(ОписаниеОповещения, "ОбщийМакет.ДрайверСканераШтрихкодов");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаВнешнейКомпонентыДрайверСканераШтрихкодов(Параметры) Экспорт 

	СохранитьПараметрыПодключенияСканера(Параметры.ТипОС, Параметры.ВыбранныеНастройки);
	// Применение новых настроек подключения сканера штрихкодов
	РаботаСТорговымОборудованием.ОтключитьСканерШтрихкодов();
	РаботаСТорговымОборудованием.ПодключитьСканерШтрихкодов("ПоискДокументовПоШтрихкоду");

КонецПроцедуры

// Заполнение параметров подключения драйвера сканера и их сохранение в хранилище настроек.
//
// Параметры:
//  ТипОС (Строка) – тип операционной системы.  (IN)
//  ВыбранныеПараметры (Структура) – исходные данные для подключения. (IN)
//  АдресДрайвераСканера (Строка) - адрес внешней компоненты сканера
// 
// Возвращаемое значение: 
//  Нет.
&НаСервере
Процедура СохранитьПараметрыПодключенияСканера(ТипОС, ВыбранныеПараметры)

	ПараметрыСканера = Новый Структура();
	ПараметрыСканера.Вставить("БитДанных", ВыбранныеПараметры.БитДанных);
	ПараметрыСканера.Вставить("Скорость", ВыбранныеПараметры.Скорость);
	ПараметрыСканера.Вставить("Порт", ВыбранныеПараметры.Порт);
	
	Если ТипОС = "Windows" Тогда
		
		ХранилищеОбщихНастроек.Сохранить("ТекущиеНастройкиСканераWindows",, ПараметрыСканера);
		
	ИначеЕсли ТипОС = "Linux" Тогда
	
		ХранилищеОбщихНастроек.Сохранить("ТекущиеНастройкиСканераLinux",, ПараметрыСканера);
		
	КонецЕсли;
	
	СтатусПодключенияСканераШтрихкодов = НСтр("ru = 'Подключен к порту '; en = 'Connected to port '") + ВыбранныеПараметры.Порт;

КонецПроцедуры

#КонецОбласти
