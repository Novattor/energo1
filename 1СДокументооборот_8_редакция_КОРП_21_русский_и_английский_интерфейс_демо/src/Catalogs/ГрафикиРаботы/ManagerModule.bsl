#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей графика работы
//
// Возвращаемое значение:
//   Структура
//     Наименование
//     Календарь
//     КоличествоРабочихЧасовВДне
//     КоличествоРабочихЧасовВНеделе
//     КоличествоРабочихДнейВМесяце
//     РабочееВремя - ТаблицаЗначений
//        ВремяНачала
//        ВремяОкончания
//     ОсобоеРабочееВремя - ТаблицаЗначений
//        РабочийДень
//        ВремяНачала
//        ВремяОкончания
//
Функция ПолучитьСтруктуруГрафикаРаботы() Экспорт
	
	СвойстваЭлемента = Новый Структура;
	СвойстваЭлемента.Вставить("Наименование");
	СвойстваЭлемента.Вставить("Календарь");
	СвойстваЭлемента.Вставить("КоличествоРабочихЧасовВДне");
	СвойстваЭлемента.Вставить("КоличествоРабочихЧасовВНеделе");
	СвойстваЭлемента.Вставить("КоличествоРабочихДнейВМесяце");
	
	РабочееВремя = Новый ТаблицаЗначений;
	РабочееВремя.Колонки.Добавить("ВремяНачала");
	РабочееВремя.Колонки.Добавить("ВремяОкончания");
	СвойстваЭлемента.Вставить("РабочееВремя", РабочееВремя);
	
	ОсобоеРабочееВремя = Новый ТаблицаЗначений;
	ОсобоеРабочееВремя.Колонки.Добавить("РабочийДень");
	ОсобоеРабочееВремя.Колонки.Добавить("ВремяНачала");
	ОсобоеРабочееВремя.Колонки.Добавить("ВремяОкончания");
	СвойстваЭлемента.Вставить("ОсобоеРабочееВремя", ОсобоеРабочееВремя);
	
	Возврат СвойстваЭлемента;
	
КонецФункции

// Создает и записывает в БД элемент справочника.
//
// Параметры:
//   СтруктураГрафикаРаботы - Структура - структура графика работы.
//
Функция СоздатьГрафикРаботы(СтруктураГрафикаРаботы) Экспорт
	
	НовыйЭлемент = СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(
		НовыйЭлемент,
		СтруктураГрафикаРаботы,,
		"РабочееВремя, ОсобоеРабочееВремя");
		
	Для Каждого СтрокаРабочегоВремени Из СтруктураГрафикаРаботы.РабочееВремя Цикл
		НоваяСтрокаРабочегоВремени = НовыйЭлемент.РабочееВремя.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаРабочегоВремени, СтрокаРабочегоВремени);
	КонецЦикла;
	
	Для Каждого СтрокаОсобогоРабочегоВремени Из СтруктураГрафикаРаботы.ОсобоеРабочееВремя Цикл
		НоваяСтрокаОсобогоРабочегоВремени = НовыйЭлемент.РабочееВремя.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаОсобогоРабочегоВремени, СтрокаОсобогоРабочегоВремени);
	КонецЦикла;
	
	НовыйЭлемент.Записать();
	
	Возврат НовыйЭлемент.Ссылка;
	
КонецФункции

#КонецОбласти

#КонецЕсли
