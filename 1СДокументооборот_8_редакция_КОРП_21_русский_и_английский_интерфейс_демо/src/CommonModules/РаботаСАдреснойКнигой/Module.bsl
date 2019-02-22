
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список функций для автоподстановки адресатов в адресной книге
Функция ПолучитьСписокДоступныхФункций() Экспорт
	
	ДоступныеФункции = РаботаСАдреснойКнигойПереопределяемый.ПолучитьСписокДоступныхФункций();
	
	ДоступныеФункции.Добавить("РаботаСАдреснойКнигой.ВсеРуководители()", 			 НСтр("ru = 'Все руководители'; en = 'All managers'"));
	ДоступныеФункции.Добавить("РаботаСАдреснойКнигой.ВсеПодчиненные()", 			 НСтр("ru = 'Все подчиненные'; en = 'All subordinates'"));
	ДоступныеФункции.Добавить("РаботаСАдреснойКнигой.ВсеКоллеги()", 				 НСтр("ru = 'Все сотрудники моего подразделения'; en = 'All employees of my department'"));
	
	ДоступныеФункции.Добавить("РаботаСАдреснойКнигой.ВсеРуководителиПредприятия()", 	   НСтр("ru = 'Все руководители предприятия'; en = 'All managers of the enterprise'"));
	ДоступныеФункции.Добавить("РаботаСАдреснойКнигой.ВсеПользователиИнформационнойБазы()", НСтр("ru = 'Все пользователи информационной базы'; en = 'All users of the information base'"));
	
	Возврат ДоступныеФункции;
	
КонецФункции

// Возвращает значение автоподстановки
Функция ПолучитьЗначениеАвтоподстановки(Автоподстановка) Экспорт
	
	ФункцияАвтоподстановки = "";
	
	СписокФункций = ПолучитьСписокДоступныхФункций();
	Для Инд = 0 По СписокФункций.Количество() - 1 Цикл
		Если СписокФункций[Инд].Представление = Автоподстановка Тогда 
			ФункцияАвтоподстановки = СписокФункций[Инд].Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;	
	
	Если ФункцияАвтоподстановки = "" Тогда 
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не определена автоподстановка %1'; en = 'Auto-substitution %1 is not defined'"), Автоподстановка);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	РезультатФункции = Неопределено;
	Попытка
		Выполнить("РезультатФункции = " + ФункцияАвтоподстановки);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при выполнении автоподстановки %1:
			|%2'; en = 'Error performing auto-substitution %1: %2'"), Автоподстановка, ИнформацияОбОшибке().Описание);
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
	
	Если (ТипЗнч(РезультатФункции) = Тип("Массив") И РезультатФункции.Количество() > 0) Тогда 
		Возврат РезультатФункции;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_Автоподстановки

// автоподстановка ВсеРуководители
Функция ВсеРуководители() Экспорт
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	МассивРуководителей = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователяхДокументооборот.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|ГДЕ
	|	СведенияОПользователяхДокументооборот.Пользователь = &Пользователь
	|	И СведенияОПользователяхДокументооборот.Пользователь.Недействителен = ЛОЖЬ";
	Запрос.УстановитьПараметр("Пользователь", ТекущийПользователь);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат МассивРуководителей;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Подразделение = Выборка.Подразделение;
	
	Пока ЗначениеЗаполнено(Подразделение) Цикл
		Руководитель = Подразделение.Руководитель;
		Если ЗначениеЗаполнено(Руководитель) И Руководитель <> ТекущийПользователь Тогда 
			МассивРуководителей.Добавить(Руководитель);
		КонецЕсли;	
		
		Подразделение = Подразделение.Родитель;
	КонецЦикла;
	
	Возврат МассивРуководителей;
	
КонецФункции

// автоподстановка ВсеПодчиненные
Функция ВсеПодчиненные() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СведенияОПользователяхДокументооборот.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|ГДЕ
	|	СведенияОПользователяхДокументооборот.Подразделение В ИЕРАРХИИ
	|			(ВЫБРАТЬ
	|				Справочник.СтруктураПредприятия.Ссылка
	|			ИЗ
	|				Справочник.СтруктураПредприятия
	|			ГДЕ
	|				Справочник.СтруктураПредприятия.Руководитель = &Руководитель)
	|	И СведенияОПользователяхДокументооборот.Пользователь <> &Руководитель
	|	И СведенияОПользователяхДокументооборот.Пользователь.Недействителен = ЛОЖЬ";
	Запрос.УстановитьПараметр("Руководитель", ПользователиКлиентСервер.ТекущийПользователь());
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
	
КонецФункции	

// автоподстановка ВсеКоллеги
Функция ВсеКоллеги() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СведенияОПользователяхДокументооборот.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|ГДЕ
	|	СведенияОПользователяхДокументооборот.Подразделение В
	|			(ВЫБРАТЬ
	|				РегистрСведений.СведенияОПользователяхДокументооборот.Подразделение
	|			ИЗ
	|				РегистрСведений.СведенияОПользователяхДокументооборот
	|			ГДЕ
	|				РегистрСведений.СведенияОПользователяхДокументооборот.Пользователь = &Пользователь)
	|	И СведенияОПользователяхДокументооборот.Пользователь <> &Пользователь
	|	И СведенияОПользователяхДокументооборот.Пользователь.Недействителен = ЛОЖЬ";
	Запрос.УстановитьПараметр("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
	
КонецФункции	

// автоподстановка ВсеРуководителиПредприятия
Функция ВсеРуководителиПредприятия() Экспорт 
	
	МассивРуководителей = Новый Массив;
	
	Выборка = Справочники.СтруктураПредприятия.Выбрать();
	Пока Выборка.Следующий() Цикл
		Руководитель = Выборка.Руководитель;
		Если ЗначениеЗаполнено(Руководитель) Тогда 
			Если МассивРуководителей.Найти(Руководитель) = Неопределено Тогда 
				МассивРуководителей.Добавить(Руководитель);
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;	
	
	Возврат МассивРуководителей;
	
КонецФункции

// автоподстановка ВсеПользователиИнформационнойБазы
Функция ВсеПользователиИнформационнойБазы() Экспорт 
	
	МассивПользователей = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Пользователи.Ссылка,
		|	Пользователи.ИдентификаторПользователяИБ
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.Недействителен = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Пользователи.Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.ИдентификаторПользователяИБ) Тогда 
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Выборка.ИдентификаторПользователяИБ);
			Если ПользовательИБ <> Неопределено Тогда 
				МассивПользователей.Добавить(Выборка.Ссылка);
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;	
	
	Возврат МассивПользователей;
	
КонецФункции

#КонецОбласти

#КонецЕсли
