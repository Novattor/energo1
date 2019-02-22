
////////////////////////////////////////////////////////////////////////////////
// РаботаСКомплекснымиБизнесПроцессамиКлиентСервер: содержит процедуры работы с комплексными
//													процессами на клиенте и на сервере.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет настроку элементов редактирования маршрута в карточке комплексного процесса/шаблона.
//
// Параметры:
//  Форма - УправляемаяФорма - карточка комплексного процесса/шаблона
//
Процедура НастроитьЭлементыРедактированияМаршрута(Форма) Экспорт
	
	Если Форма.ИспользоватьСхемуПроцесса Тогда
		Форма.Элементы.ГруппаЭтапы.Видимость = Ложь;
		Форма.Элементы.ФормаОбщаяКомандаПечатьСхемыКомплексногоПроцесса.Видимость = Ложь;
		Форма.Элементы.ГруппаМаршрут.Видимость = Истина;
	Иначе
		Форма.Элементы.ГруппаЭтапы.Видимость = Истина;
		Форма.Элементы.ФормаОбщаяКомандаПечатьСхемыКомплексногоПроцесса.Видимость = Истина;
		Форма.Элементы.ГруппаМаршрут.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Вычисляет строковое представление предшественников для всех этапов
// Параметры:
//	Объект - объект (комплексный процесс или шаблон комплексного процесса)
Процедура ВычислитьОписаниеПредшественников(Объект) Экспорт
	
	Для Каждого ЭтапОбъекта Из Объект.Этапы Цикл
		ЭтапОбъекта.ПредшественникиЭтапаСтрокой = "";	
	КонецЦикла;
	
	Для Каждого ЭтапОбъекта Из Объект.Этапы Цикл	
		ИдентификаторЭтапа = ЭтапОбъекта.ИдентификаторЭтапа;
		СтрокаРезультат = "";
		СтрокаСвязка = " " + НСтр("ru = 'и'; en = 'and'") + " ";
		Если ЭтапОбъекта.ПредшественникиВариантИспользования = "ОдинИзПредшественников" Тогда
			СтрокаСвязка = " " + НСтр("ru = 'или'; en = 'or'") + " ";
		КонецЕсли;
		Для Каждого Предшественник Из Объект.ПредшественникиЭтапов Цикл			
			Если Предшественник.ИдентификаторПоследователя = ИдентификаторЭтапа Тогда
				Если ЭтапУдален(Объект, Предшественник.ИдентификаторПредшественника) Тогда
					Продолжить;
				КонецЕсли;
				СтрокаПростоеУсловие = "";
				Если ЗначениеЗаполнено(Предшественник.УсловиеРассмотрения) 
					И Предшественник.ИдентификаторПредшественника <> УникальныйИдентификаторПустой() Тогда
					
					Для Каждого ЭтапПредшественник Из Объект.Этапы Цикл
						Если ЭтапПредшественник.ИдентификаторЭтапа = Предшественник.ИдентификаторПредшественника Тогда
							Прервать;
						КонецЕсли;
					КонецЦикла;
					
					Если ТипЗнч(ЭтапПредшественник.ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныСогласования") Тогда
						Если Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'После завершения '; en = 'After completion '");
						ИначеЕсли Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'Если не согласовано '; en = 'If not approved '");
						ИначеЕсли Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'Если согласовано '; en = 'If approved '");
						ИначеЕсли Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоСогласованияБезЗамечаний") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'Если согласовано без замечаний'; en = 'If approved without reservations'");
						ИначеЕсли Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоСогласованияСЗамечаниями") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'Если согласовано с замечаниями'; en = 'If approved with reservations'");
						КонецЕсли;
					ИначеЕсли ТипЗнч(ЭтапПредшественник.ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныУтверждения") Тогда
						Если Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'После завершения '; en = 'After completion '");
						ИначеЕсли Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'Если не утверждено '; en = 'If not confirmed '");
						ИначеЕсли Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'Если утверждено '; en = 'If confirmed '");
						КонецЕсли;
					ИначеЕсли ТипЗнч(ЭтапПредшественник.ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныРегистрации") Тогда
						Если Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'После завершения '; en = 'After completion '");
						ИначеЕсли Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'Если не зарегистрировано '; en = 'If not registered '");
						ИначеЕсли Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'Если зарегистрировано '; en = 'If registered '");
						КонецЕсли;
					ИначеЕсли ТипЗнч(ЭтапПредшественник.ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныПриглашения") Тогда
						Если Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'После завершения '; en = 'After completion '");
						ИначеЕсли Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'Если не принято '; en = 'If not accepted '");
						ИначеЕсли Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'Если принято '; en = 'If accepted '");
						ИначеЕсли Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоСогласованияСЗамечаниями") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'Если принято обязательными '; en = 'If accepted by the mandatory '");
						ИначеЕсли Предшественник.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоСогласованияБезЗамечаний") Тогда
							СтрокаПростоеУсловие = НСтр("ru = 'Если принято всеми '; en = 'If accepted by everyone '");
						КонецЕсли;
					Иначе
						СтрокаПростоеУсловие = НСтр("ru = 'После завершения '; en = 'After completion '");
					КонецЕсли;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаРезультат) Тогда
					СтрокаРезультат = СтрокаРезультат + СтрокаСвязка + НРег(СтрокаПростоеУсловие) + ПолучитьПредставлениеЭтапа(Объект, Предшественник.ИдентификаторПредшественника);
				Иначе
					СтрокаРезультат = СтрокаПростоеУсловие + ПолучитьПредставлениеЭтапа(Объект, Предшественник.ИдентификаторПредшественника);
				КонецЕсли;
				Если ЗначениеЗаполнено(Предшественник.УсловиеПерехода) Тогда
					СтрокаРезультат = СтрокаРезультат + НСтр("ru = ', если '; en = ',  if '") + Строка(Предшественник.ИмяПредметаУсловия) + "." + НРег(Строка(Предшественник.УсловиеПерехода)) + ",";
				КонецЕсли;	
			КонецЕсли;
		КонецЦикла;
		ЭтапОбъекта.ПредшественникиЭтапаСтрокой = СтрокаРезультат;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_СхемаПроцесса

// Обновляет связь элементов схемы процесса (таблица СхемаКомплексногоПроцесса.ПредшественникиЭлементовСхемы)
// по графической схеме. Обновление производится по соединительным линиям схемы.
//
// Параметры:
//  СхемаПроцесса - ДанныеФормыСтруктура,
//                  СправочникОбъект.СхемыКомплексныхПроцессов - схема процесса.
//  ГрафическаяСхема - ГрафическаяСхема - графическая схема процесса.
//
Процедура ОбновитьСвязиЭлементовСхемыПроцесса(СхемаПроцесса, ГрафическаяСхема) Экспорт
	
	СхемаПроцесса.ПредшественникиЭлементовСхемы.Очистить();
	
	Для Каждого ЭлементГрафическойСхемы Из ГрафическаяСхема.ЭлементыГрафическойСхемы Цикл
		
		ТипЭлементаГрафическойСхемы = ТипЗнч(ЭлементГрафическойСхемы);
		
		// Пропускаем все элементы, которые не являются соединительными линиями.
		Если ТипЭлементаГрафическойСхемы <> Тип("ЭлементГрафическойСхемыСоединительнаяЛиния") Тогда
			Продолжить;
		КонецЕсли;
		
		НачалоЭлемент = ЭлементГрафическойСхемы.НачалоЭлемент;
		КонецЭлемент = ЭлементГрафическойСхемы.КонецЭлемент;
		
		ТипЭлементаНачала = ТипЗнч(НачалоЭлемент);
		
		// Пропускаем линии, у которых один из концов не прикреплен
		// к какому-либо элементу или прикреплен к неподдерживаемому элементу.
		Если ТипЭлементаСхемы(ТипЭлементаНачала) = Неопределено
			Или ТипЭлементаСхемы(ТипЗнч(КонецЭлемент)) = Неопределено Тогда
			
			Продолжить;
		КонецЕсли;
		
		НоваяЗаписьПредшественника = СхемаПроцесса.ПредшественникиЭлементовСхемы.Добавить();
		НоваяЗаписьПредшественника.Имя = КонецЭлемент.Имя;
		НоваяЗаписьПредшественника.ИмяПредшественника = НачалоЭлемент.Имя;
		НоваяЗаписьПредшественника.ИмяСоединительнойЛинии = ЭлементГрафическойСхемы.Имя;
		
		Если ТипЭлементаНачала = Тип("ЭлементГрафическойСхемыУсловие") Тогда
			
			Если ЭлементГрафическойСхемы.Наименование = НСтр("ru = 'Да'; en = 'Yes'") Тогда
				НоваяЗаписьПредшественника.РезультатУсловияПредшественника = Истина;
			Иначе
				НоваяЗаписьПредшественника.РезультатУсловияПредшественника = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		НачалоЭлемент = Неопределено;
		КонецЭлемент = Неопределено;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает тип элемента схемы процесса по типу элемента графической схемы.
// Для типов, которые не являются элементами схемы процесса возвращается Неопределено.
//
// Параметры:
//  ТипЭлементаСхемы - Тип.ЭлементГрафическойСхемыВложенныйБизнесПроцесс,
//                 Тип.ЭлементГрафическойСхемыДействие,
//                 Тип.ЭлементГрафическойСхемыДекоративнаяЛиния,
//                 Тип.ЭлементГрафическойСхемыДекорация,
//                 Тип.ЭлементГрафическойСхемыЗавершение,
//                 Тип.ЭлементГрафическойСхемыРазделение,
//                 Тип.ЭлементГрафическойСхемыСлияние,
//                 Тип.ЭлементГрафическойСхемыСтарт,
//                 Тип.ЭлементГрафическойСхемыУсловие - элемент графической схемы.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыЭлементовСхемыКомплексногоПроцесса, Неопределено
//
Функция ТипЭлементаСхемы(ТипЭлементаГрафическойСхемы) Экспорт
	
	ТипЭлементаСхемы = Неопределено;
	
	Если ТипЭлементаГрафическойСхемы = Тип("ЭлементГрафическойСхемыВложенныйБизнесПроцесс") Тогда
		ТипЭлементаСхемы = ПредопределенноеЗначение(
			"Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.ВложенныйПроцесс");
	ИначеЕсли ТипЭлементаГрафическойСхемы = Тип("ЭлементГрафическойСхемыДействие") Тогда
		ТипЭлементаСхемы = ПредопределенноеЗначение(
			"Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.Действие");
	ИначеЕсли ТипЭлементаГрафическойСхемы = Тип("ЭлементГрафическойСхемыДекоративнаяЛиния") Тогда
		ТипЭлементаСхемы = ПредопределенноеЗначение(
			"Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.ДекоративнаяЛиния");
	ИначеЕсли ТипЭлементаГрафическойСхемы = Тип("ЭлементГрафическойСхемыДекорация") Тогда
		ТипЭлементаСхемы = ПредопределенноеЗначение(
			"Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.Декорация");
	ИначеЕсли ТипЭлементаГрафическойСхемы = Тип("ЭлементГрафическойСхемыЗавершение") Тогда
		ТипЭлементаСхемы = ПредопределенноеЗначение(
			"Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.Завершение");
	ИначеЕсли ТипЭлементаГрафическойСхемы = Тип("ЭлементГрафическойСхемыРазделение") Тогда
		ТипЭлементаСхемы = ПредопределенноеЗначение(
			"Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.Разделение");
	ИначеЕсли ТипЭлементаГрафическойСхемы = Тип("ЭлементГрафическойСхемыСлияние") Тогда
		ТипЭлементаСхемы = ПредопределенноеЗначение(
			"Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.Слияние");
	ИначеЕсли ТипЭлементаГрафическойСхемы = Тип("ЭлементГрафическойСхемыСтарт") Тогда
		ТипЭлементаСхемы = ПредопределенноеЗначение(
			"Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.Старт");
	ИначеЕсли ТипЭлементаГрафическойСхемы = Тип("ЭлементГрафическойСхемыУсловие") Тогда
		ТипЭлементаСхемы = ПредопределенноеЗначение(
			"Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.Условие");
	ИначеЕсли ТипЭлементаГрафическойСхемы = Тип("ЭлементГрафическойСхемыОбработка") Тогда
		ТипЭлементаСхемы = ПредопределенноеЗначение(
			"Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.Обработка");
	КонецЕсли;
	
	Возврат ТипЭлементаСхемы;
	
КонецФункции

// Возвращает линию для рамки пройденного элемента схемы процесса.
//
// Возвращаемое значение:
//  Линия
//
Функция РамкаПройденногоЭлемента() Экспорт
	
	Возврат Новый Линия(ТипСоединительнойЛинии.Сплошная, 2);
	
КонецФункции

// Возвращает линию по умолчанию для рамки элемента схемы процесса.
//
// Возвращаемое значение:
//  Линия
//
Функция РамкаЭлементаПоУмолчанию() Экспорт
	
	Возврат Новый Линия(ТипСоединительнойЛинии.Сплошная, 1);
	
КонецФункции

// Возвращает линию для рамки текущего элемента схемы процесса.
//
// Возвращаемое значение:
//  Линия
//
Функция РамкаТекущегоЭлемента() Экспорт
	
	Возврат Новый Линия(ТипСоединительнойЛинии.Пунктир, 2);
	
КонецФункции

// Выделяет границу элемента схемы в зависимости от признака его прохождения.
//
// Параметры:
//  Схема - ГрафическаяСхема 
//  ИмяЭлемента - Строка - имя элемента в схеме.
//  Пройден - Булево - признак прохождения элемента.
//
Процедура УстановитьОтметкуПройденногоЭлементаВСхеме(Схема, ИмяЭлемента, Пройден) Экспорт
	
	ЭлементГрафическойСхемы = Схема.ЭлементыГрафическойСхемы.Найти(ИмяЭлемента);
	
	ТипЭлемента = ТипЗнч(ЭлементГрафическойСхемы);
	
	Если Пройден Тогда
		Рамка = РамкаПройденногоЭлемента();
	Иначе
		Рамка = РамкаЭлементаПоУмолчанию();
	КонецЕсли;
	
	ЭлементГрафическойСхемы.Рамка = Рамка;
	
КонецПроцедуры

// Выделяет границу элемента схемы как текущего.
//
// Параметры:
//  Схема - ГрафическаяСхема 
//  ИмяЭлемента - Строка - имя элемента в схеме.
//
Процедура УстановитьОтметкуТекущегоЭлементаВСхеме(Схема, ИмяЭлемента) Экспорт
	
	ЭлементГрафическойСхемы = Схема.ЭлементыГрафическойСхемы.Найти(ИмяЭлемента);
	
	ЭлементГрафическойСхемы.Рамка = РамкаТекущегоЭлемента();
	
КонецПроцедуры

// Обновляет представление действия в графической схеме процесса/шаблона.
//
// Параметры:
//  Схема - ГрафическаяСхема
//  ПараметрыДействия - СтрокаТаблицыЗначений, ДанныеФормыЭлементКоллекции - строка таблицы ПараметрыДействия схемы
//                      с доп. полями сроков (СрокИсполненияПроцесса, СрокИсполненияПроцессаДни,
//                      СрокИсполненияПроцессаЧасы, СрокИсполненияПроцессаМинуты) и полем состояния процесса
//                      (СостояниеПроцесса)
//  ПараметрыЭлемента - СтрокаТаблицыЗначений, ДанныеФормыЭлементКоллекции - строка таблицы ЭлементыСхемы схемы.
//  КэшДанныхДействий - Структура - см. РаботаСКомплекснымиБизнесПроцессамиСервер.КэшДанныхДействий.
//  ПроцессыСхемыДляПрерывания - СписокЗначений - список процессов действий схемы, помеченных к прерыванию.
//  ИспользоватьДатуИВремяВСрокахЗадач - Булево - Признак использования времени в сроках.
//  ПоказатьТочныеСроки - Булево - признак необходимости отображения точных сроков.
//  ПоказатьОтносительныеСроки - Булево - признак необходимости отображения относительных сроков.
//
Процедура ОбновитьПредставлениеДействияВСхемеПроцесса(
	Схема, ПараметрыДействия, ПараметрыЭлемента, КэшДанныхДействий,
	ПроцессыСхемыДляПрерывания, ИспользоватьДатуИВремяВСрокахЗадач,
	ПоказатьТочныеСроки = Истина, ПоказатьОтносительныеСроки = Истина) Экспорт
	
	Если ПараметрыЭлемента.Тип <>
		ПредопределенноеЗначение("Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.ВложенныйПроцесс")
		
		И ПараметрыЭлемента.Тип <>
			ПредопределенноеЗначение("Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.Действие") Тогда
		
		Возврат
	КонецЕсли;
	
	ИмяДействия = ПараметрыДействия.Имя;
	
	ЭлементГрафическойСхемы = Схема.ЭлементыГрафическойСхемы.Найти(ИмяДействия);
	
	Если ЭлементГрафическойСхемы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СостояниеПроцесса = Неопределено;
	Если ЗначениеЗаполнено(ПараметрыДействия.Процесс) Тогда
		ДанныеПроцесса = РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.ДанныеДействияВКэше(
			ПараметрыДействия.Процесс, КэшДанныхДействий);
		СостояниеПроцесса = ДанныеПроцесса.СостояниеПроцесса;
	КонецЕсли;
	
	Действие = СсылкаНаДействиеСхемы(
		ПараметрыДействия,
		ПараметрыЭлемента,
		СостояниеПроцесса,
		ПроцессыСхемыДляПрерывания);
	
	Если Не ЗначениеЗаполнено(Действие) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеДействияВКэше = РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.ДанныеДействияВКэше(
		Действие, КэшДанныхДействий);
	
	НаименованиеДействия = ДанныеДействияВКэше.Описание;
	
	СрокИсполненияДействия = Дата(1,1,1);
	
	// Заполним наименование действия.
	
	Если ПоказатьТочныеСроки Или ПоказатьОтносительныеСроки Тогда
		
		СтруктураСроков = Новый Структура;
		СтруктураСроков.Вставить("СрокИсполненияПроцесса", Дата(1,1,1));
		СтруктураСроков.Вставить("СрокИсполненияПроцессаДни", 0);
		СтруктураСроков.Вставить("СрокИсполненияПроцессаЧасы", 0);
		СтруктураСроков.Вставить("СрокИсполненияПроцессаМинуты", 0);
		СтруктураСроков.Вставить("СрокИсполненияПроцессаПредставление", "");
		
		ИсключенныеСвойства = "";
		
		Если Не ПоказатьТочныеСроки Тогда
			ИсключенныеСвойства = "СрокИсполненияПроцесса";
		КонецЕсли;
		
		Если Не ПоказатьОтносительныеСроки Тогда
			ИсключенныеСвойства = ИсключенныеСвойства
				+ "СрокИсполненияПроцессаДни, СрокИсполненияПроцессаЧасы, СрокИсполненияПроцессаМинуты";
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтруктураСроков, ПараметрыДействия,, ИсключенныеСвойства);
		
		Если ЗначениеЗаполнено(СтруктураСроков.СрокИсполненияПроцесса)
			Или ЗначениеЗаполнено(СтруктураСроков.СрокИсполненияПроцессаДни)
			Или ЗначениеЗаполнено(СтруктураСроков.СрокИсполненияПроцессаЧасы)
			Или ЗначениеЗаполнено(СтруктураСроков.СрокИсполненияПроцессаМинуты) Тогда
		
			СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСрокаИсполненияПроцесса(
				СтруктураСроков.СрокИсполненияПроцессаПредставление,
				СтруктураСроков.СрокИсполненияПроцесса,
				СтруктураСроков.СрокИсполненияПроцессаДни,
				СтруктураСроков.СрокИсполненияПроцессаЧасы,
				СтруктураСроков.СрокИсполненияПроцессаМинуты,
				ИспользоватьДатуИВремяВСрокахЗадач);
			
			НаименованиеДействия = НаименованиеДействия
				+ Символы.ПС + Символы.ПС
				+ СтрШаблон(НСтр("ru = 'Срок: %1'; en = 'Date: %1'"), СтруктураСроков.СрокИсполненияПроцессаПредставление);
		КонецЕсли;
		
		СрокИсполненияДействия = СтруктураСроков.СрокИсполненияПроцесса;
		
	КонецЕсли;
	
	ЭлементГрафическойСхемы.Наименование = НаименованиеДействия;
	
	// Заполним пояснение (исполнителей) действия.
	
	Если ПараметрыЭлемента.Тип = ПредопределенноеЗначение(
		"Перечисление.ТипыЭлементовСхемыКомплексногоПроцесса.Действие") Тогда
		
		ЭлементГрафическойСхемы.Пояснение = ДанныеДействияВКэше.Исполнители;
	КонецЕсли;
	
	// Установим выделение истекшего срока действия.
	СрокИсполненияДействияИстек = Ложь;
	СрокиИсполненияПроцессовКлиентСерверКОРП.ОбновитьПризнакИстекшегоСрокаПроцесса(
		СрокИсполненияДействия, ДанныеДействияВКэше.ДатаЗавершения, СрокИсполненияДействияИстек);
	
	Если СрокИсполненияДействияИстек Тогда
		// Соответствует стилю ПросроченныеДанныеЦвет
		ЭлементГрафическойСхемы.ЦветРамки = Новый Цвет(178, 34, 34);
	Иначе
		// Цвет рамки по умолчанию.
		ЭлементГрафическойСхемы.ЦветРамки = Новый Цвет(160, 160, 160);
	КонецЕсли;
	
КонецПроцедуры

// Обновляет представление всех действий (элементов) схемы (графической схемы) процесса.
//
// Параметры:
//  Схема - ГрафическаяСхема
//  ПараметрыДействия - ТабличнаяЧасть, ДанныеФормыКоллекция - таблица ПараметрыДействия схемы
//                      с доп. полями сроков (СрокИсполненияПроцесса, СрокИсполненияПроцессаДни,
//                      СрокИсполненияПроцессаЧасы, СрокИсполненияПроцессаМинуты) и полем состояния процесса
//                      (СостояниеПроцесса)
//  ПараметрыЭлемента - ТабличнаяЧасть, ДанныеФормыКоллекция - таблица ЭлементыСхемы схемы.
//  КэшДанныхДействий - Структура - см. РаботаСКомплекснымиБизнесПроцессамиСервер.КэшДанныхДействий.
//  ИспользоватьДатуИВремяВСрокахЗадач - Булево - Признак использования времени в сроках.
//  ПоказатьТочныеСроки - Булево - признак необходимости отображения точных сроков.
//  ПоказатьОтносительныеСроки - Булево - признак необходимости отображения относительных сроков.
//  ПроцессыСхемыДляПрерывания - СписокЗначений - список процессов действий схемы, помеченных к прерыванию.
//
Процедура ОбновитьПредставленияДействийВСхемеПроцесса(
	Схема, ПараметрыДействий, ПараметрыЭлементов, КэшДанныхДействий,
	ИспользоватьДатуИВремяВСрокахЗадач, ПоказатьТочныеСроки, ПоказатьОтносительныеСроки,
	ПроцессыСхемыДляПрерывания = Неопределено) Экспорт
	
	КэшПараметровЭлементов = Новый Соответствие;
	Для Каждого ПараметрыЭлемента Из ПараметрыЭлементов Цикл
		КэшПараметровЭлементов.Вставить(ПараметрыЭлемента.Имя, ПараметрыЭлемента);
	КонецЦикла;
	
	Если ПроцессыСхемыДляПрерывания = Неопределено Тогда
		ПроцессыСхемыДляПрерывания = Новый СписокЗначений;
	КонецЕсли;
	
	Для Каждого ПараметрыДействия Из ПараметрыДействий Цикл
		
		ПараметрыЭлемента = КэшПараметровЭлементов.Получить(ПараметрыДействия.Имя);
		
		ОбновитьПредставлениеДействияВСхемеПроцесса(
			Схема,
			ПараметрыДействия,
			ПараметрыЭлемента,
			КэшДанныхДействий,
			ПроцессыСхемыДляПрерывания,
			ИспользоватьДатуИВремяВСрокахЗадач,
			ПоказатьТочныеСроки,
			ПоказатьОтносительныеСроки);
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает строку таблицы элементов схемы.
//
// Параметры:
//  СхемаОбъект - ДанныеФормыСтруктура,
//                СправчоникОбъект.СхемыКомплексныхПроцессов - объект схемы в форме.
//  ИмяДействий - Строка - имя действия в схеме.
//
// Возвращаемое значение:
//  ДанныеФормыЭлементКоллекции, СтрокаТаблицыЗначений - строка таблицы ЭлементыСхемы.
//  Неопределено - если строка не найдена.
//
Функция СтрокаЭлементаСхемы(СхемаОбъект, ИмяЭлемента) Экспорт
	
	СтрокаЭлементаСхемы = Неопределено;
	
	Для Каждого СтрокаТаблицы Из СхемаОбъект.ЭлементыСхемы Цикл
		Если СтрокаТаблицы.Имя = ИмяЭлемента Тогда
			СтрокаЭлементаСхемы = СтрокаТаблицы;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаЭлементаСхемы;
	
КонецФункции

// Возвращает строку таблицы параметров действий.
//
// Параметры:
//  СхемаОбъект - ДанныеФормыСтруктура,
//                СправчоникОбъект.СхемыКомплексныхПроцессов - объект схемы в форме.
//  ИмяДействий - Строка - имя действия в схеме.
//
// Возвращаемое значение:
//  ДанныеФормыЭлементКоллекции, СтрокаТаблицыЗначений - строка таблицы ПараметрыДействий.
//  Неопределено - если строка не найдена.
//
Функция СтрокаПараметровДействий(СхемаОбъект, ИмяДействий) Экспорт
	
	СтрокаПараметровДействий = Неопределено;
	
	Для Каждого СтрокаТаблицы Из СхемаОбъект.ПараметрыДействий Цикл
		Если СтрокаТаблицы.Имя = ИмяДействий Тогда
			СтрокаПараметровДействий = СтрокаТаблицы;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаПараметровДействий;
	
КонецФункции

// Возвращает ссылку на действие схемы по параметрам этого действия.
// При этом учитывается состояние процесса и его пометка к прерыванию в карточке процесса.
//
// Параметры:
//  ПараметрыДействия - СтрокаТаблицыЗначений, ДанныеФормыЭлементКоллекции - строка таблицы ПараметрыДействия схемы.
//  ПараметрыЭлемента - СтрокаТаблицыЗначений, ДанныеФормыЭлементКоллекции - строка таблицы ЭлементыСхемы схемы.
//  СостояниеПроцесса - ПеречислениеСсылка - состояние процесса, указанного в параметрах действий.
//  ПроцессыСхемыДляПрерывания - СписокЗначений - список процессов действий схемы, помеченных к прерыванию.
//
// Возвращаемое значение:
//  ОписаниеТипов - ДействиеКомплексногоПроцесса, ШаблонДействияКомплексногоПроцесса.
//
Функция СсылкаНаДействиеСхемы(
	ПараметрыДействия, ПараметрыЭлемента, СостояниеПроцесса, ПроцессыСхемыДляПрерывания) Экспорт
	
	Если Не ЗначениеЗаполнено(ПараметрыДействия.ШаблонПроцесса) Тогда
		// Если нет шаблона процесса, то это элемент схемы без настройки.
		Действие = Неопределено;
	ИначеЕсли ЗначениеЗаполнено(ПараметрыДействия.Процесс) Тогда
		// Если текущее действие прервано или помечено как к прерыванию,
		// и имеет признак текущего элемента, то считаем, актуальные настройки содержит
		// шаблон и именно его сроки должны учитываться при настройке.
		Если (СостояниеПроцесса = ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Прерван")
			Или ПроцессыСхемыДляПрерывания.НайтиПоЗначению(ПараметрыДействия.Процесс) <> Неопределено)
			
			И ПараметрыЭлемента.Текущий Тогда
			
			Действие = ПараметрыДействия.ШаблонПроцесса;
		Иначе
			Действие = ПараметрыДействия.Процесс;
		КонецЕсли;
		
	Иначе
		Действие = ПараметрыДействия.ШаблонПроцесса;
	КонецЕсли;
	
	Возврат Действие;
	
КонецФункции

// Возвращает возможные пути схемы комплексного процесса по таблице предшественников,
// исключая циклы.
//
// Параметры:
//  ИмяПервогоЭлемента - Строка - имя первого элемента в пути (старт).
//  ПредшественникиЭлементовСхемы - ТабличнаяЧасть, ТаблицаЗначений - таблица ПредшественникиЭлементовСхемы схемы.
//
// Возвращаемое значение:
//  Массив - список путей.
//   * Массив - каждый путь это массив имен элементов в этом пути.
//
Функция ПутиСхемыКомплексногоПроцесса(ИмяПервогоЭлемента, ПредшественникиЭлементовСхемы) Экспорт
	
	ВсеПути = Новый Массив;
	
	Если ЗначениеЗаполнено(ИмяПервогоЭлемента) Тогда
		// Добавим первый путь в массив всех путей.
		ВсеПути.Добавить(Новый Массив);
		
		ДобавитьПоследователейЭлементаСхемыВПуть(
			ВсеПути, 0, ПредшественникиЭлементовСхемы, ИмяПервогоЭлемента);
	КонецЕсли;
	
	Возврат ВсеПути;
	
КонецФункции

#Область Действия

// Возвращает имя формы действия схемы.
//
// Параметры:
//  Форма - УправляемаяФормы - карточка комплексного процесса/шаблона.
//  Действие - ОпределяемыйТип.ШаблонДействияКомплексногоПроцесса,
//             ОпределяемыйТип.ДействиеКомплексногоПроцесса - действие или шаблон действия схемы.
//
Функция ИмяФормыДействияСхемы(Форма, Действие) Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("ТипДействия", ТипЗнч(Действие));
	
	НайденныеФормы = Форма.ФормыДействийСхемы.НайтиСтроки(Отбор);
	
	// Значение не может быть пустым.
	Возврат НайденныеФормы[0].ИмяФормы;
	
КонецФункции

#КонецОбласти

#Область Условия

// Возвращает структуру условия по предмету для элемента отбора компоновки данных.
//
// Параметры:
//  Условие - СправочникСсылка.УсловияМаршрутизации
//  ИмяПредмета - СправочникСсылка.ИменаПредметов
//
// Возвращаемое значение:
//  Структура
//   * УсловиеПоПредмету - СправочникСсылка.УсловияМаршрутизации
//   * ИмяПредмета - СправочникСсылка.ИменаПредметов
//
Функция СтруктураУсловияПоПредметуДляЭлементаОтбораКомпоновкиДанных(
	Условие, ИмяПредмета) Экспорт
	
	ЗначениеОтбораНастройки = Новый Структура;
	ЗначениеОтбораНастройки.Вставить("Условие", Условие);
	ЗначениеОтбораНастройки.Вставить("ИмяПредмета", ИмяПредмета);
	
	Возврат ЗначениеОтбораНастройки;
	
КонецФункции

// Возвращает структуру условия выполнения действия для элемента отбора компоновки данных.
//
// Параметры:
//  РезультатВыполнения - ПеречислениеСсылка.РезультатыЗавершенияДействийКомплексныхПроцессов
//  Действие - Строка - Имя действия в схеме комплексного процесса.
//
// Возвращаемое значение:
//  Структура
//   * РезультатВыполнения - ПеречислениеСсылка.РезультатыЗавершенияДействийКомплексныхПроцессов
//   * Действие - Строка
//
Функция СтруктураУсловияВыполненияДляЭлементаОтбораКомпоновкиДанных(
	РезультатВыполнения, Действие) Экспорт
	
	ЗначениеОтбораНастройки = Новый Структура;
	ЗначениеОтбораНастройки.Вставить("РезультатВыполнения", РезультатВыполнения);
	ЗначениеОтбораНастройки.Вставить("Действие", Действие);
	
	Возврат ЗначениеОтбораНастройки;
	
КонецФункции

// Возвращает структуру условия на встроенном языке для элемента отбора компоновки данных.
//
// Параметры:
//  Наименование - Строка - наименование условия.
//  Выражение - УникальныИдентификатор - Идентификатор выражения схемы.
//              Текст выражения хранится в регистре СкриптыСхемКомплексныхПроцессов.
//
// Возвращаемое значение:
//  Структура
//   * Наименование - Строка
//   * Выражение - УникальныИдентификатор
//
Функция СтруктураУсловияНаВстроенномЯзыкеДляЭлементаОтбораКомпоновкиДанных(
	Наименование, Выражение) Экспорт
	
	ЗначениеОтбораНастройки = Новый Структура;
	ЗначениеОтбораНастройки.Вставить("Наименование", Наименование);
	ЗначениеОтбораНастройки.Вставить("Выражение", Выражение);
	
	Возврат ЗначениеОтбораНастройки;
	
КонецФункции

#КонецОбласти

#Область КэшДанныхДействий

// Возвращает данные действия из кэша.
//
// Параметры:
//  ПроцессШаблон - БизнесПроцессСсылка, СправочникСсылка - процесс или шаблон действия.
//  КэшДанныхДействий - Структура - см. функцию РаботаСКомплекснымиБизнесПроцессамиСервер.КэшДанныхДействий.
//
// Возвращаемое значение:
//  Структура - см. СтруктураДанныхДействия.
//
Функция ДанныеДействияВКэше(ПроцессШаблон, КэшДанныхДействий) Экспорт
	
	ИмяКлючаВКэше = ИмяКлючаВКэшеДанныхДействий(ПроцессШаблон);
	
	Возврат КэшДанныхДействий[ИмяКлючаВКэше];
	
КонецФункции

// Возвращает пустую структуру данных действия в кэше.
//
// Возвращаемое значение:
//  Структура
//   * Описание - Строка - описание действия.
//   * Исполнители - Строка - описание исполнителей.
//   * СостояниеПроцесса - ПеречислениеСсылка.СостоянияБизнесПроцессов - состояние процесса (актуально только для процессов).
//   * ПроцессЗавершен - Булево - признак завершенности процесса (актуально только для процессов).
//   * СрокИсполненияПроцесса - Дата - Срок исполнения действия датой.
//   * СрокИсполненияПроцессаДни - Дата - длительность срока исполнения, кол. целых дней.
//   * СрокИсполненияПроцессаЧасы - Дата - длительность срока исполнения, кол. целых часов.
//   * СрокИсполненияПроцессаМинуты - Дата - длительность срока исполнения, кол. целых минут.
//   * ДатаЗавершения - Дата - дата завершения процесса (актуально только для процессов).
//
Функция СтруктураДанныхДействия() Экспорт
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Описание", "");
	СтруктураДанных.Вставить("Исполнители", "");
	
	СтруктураДанных.Вставить("СостояниеПроцесса", 
		ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.ПустаяСсылка"));
	
	СтруктураДанных.Вставить("ПроцессЗавершен", Ложь);
	
	СтруктураДанных.Вставить("СрокИсполненияПроцесса", Дата(1,1,1));
	СтруктураДанных.Вставить("СрокИсполненияПроцессаДни", 0);
	СтруктураДанных.Вставить("СрокИсполненияПроцессаЧасы", 0);
	СтруктураДанных.Вставить("СрокИсполненияПроцессаМинуты", 0);
	
	СтруктураДанных.Вставить("ДатаЗавершения", Дата(1,1,1));
	
	Возврат СтруктураДанных;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтапУдален(Знач Объект, ИдентификаторЭтапа)
	
	Если ТипЗнч(Объект) = Тип("ДанныеФормыСтруктура") Тогда
		Для Каждого ЭтапПроцесса Из Объект.Этапы Цикл
			Если ЭтапПроцесса.ИдентификаторЭтапа = ИдентификаторЭтапа И ЭтапПроцесса.Удален Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ПолучитьПредставлениеЭтапа(Знач Объект, ИдентификаторЭтапа) Экспорт
	
	Если ИдентификаторЭтапа = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
		Возврат НСтр("ru = 'При старте процесса'; en = 'Upon process start'");
	Иначе
		ПараметрыОтбора = Новый Структура("ИдентификаторЭтапа", ИдентификаторЭтапа);
		МассивНайденных = Объект.Этапы.НайтиСтроки(ПараметрыОтбора);
		Если МассивНайденных.Количество() > 0 Тогда
			НайденныйЭтап = МассивНайденных[0];
			Возврат Строка(Объект.Этапы.Индекс(НайденныйЭтап) + 1);
		КонецЕсли;
	КонецЕсли;
	Возврат "";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_СхемаПроцесса

// Добавляет последователей элемента схемы в путь.
// Процедура рекурсивная. Используется в функции ПутиСхемыКомплексногоПроцесса.
//
// Параметры:
//  ВсеПути - массив - все возможные пути.
//   * Массив - каждый путь это массив имен элементов схемы.
//  ИндексТекущегоПути - Число - индекс пути текущего элемента.
//  Предшественники - ТабличнаяЧасть, ТаблицаЗначений - таблица ПредшественникиЭлементовСхемы схемы.
//  ЭлементСхемы - Строка - имя элемента схемы, последователи которого добавляются в путь.
//
Процедура ДобавитьПоследователейЭлементаСхемыВПуть(
	ВсеПути, ИндексТекущегоПути, Предшественники, ЭлементСхемы)
	
	// Определяем по индексу текущий путь.
	ТекущийПуть = ВсеПути[ИндексТекущегоПути];
	
	// Добавляем элемент в путь.
	ТекущийПуть.Добавить(ЭлементСхемы);
	
	// Находим последователей элемента схемы.
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяПредшественника", ЭлементСхемы);
	Последователи = Предшественники.НайтиСтроки(Отбор);
	КоличествоПоследователей = Последователи.Количество();
	
	// Если нет, то выходим из процедуры - текущий путь сформирован.
	Если КоличествоПоследователей = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИндексПоследователя = КоличествоПоследователей - 1;
	
	// Создаем новые пути для каждого, кроме первого, последователя
	// и добавляем них соответствующих последователей.
	Пока ИндексПоследователя > 0 Цикл
		
		ПоследовательЭлементаСхемы = Последователи[ИндексПоследователя].Имя;
		
		ИндексПоследователя = ИндексПоследователя - 1;
		
		Если ТекущийПуть.Найти(ПоследовательЭлементаСхемы) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйПуть = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(ТекущийПуть);
		ВсеПути.Добавить(НовыйПуть);
		
		ИндексНовогоПути = ВсеПути.Количество() - 1;
		
		ДобавитьПоследователейЭлементаСхемыВПуть(
			ВсеПути, ИндексНовогоПути, Предшественники, ПоследовательЭлементаСхемы);
	КонецЦикла;
	
	// Первого последователя добавляем в текущий путь.
	ПоследовательЭлементаСхемы = Последователи[0].Имя;
	Если ТекущийПуть.Найти(ПоследовательЭлементаСхемы) = Неопределено Тогда
		ДобавитьПоследователейЭлементаСхемыВПуть(
			ВсеПути, ИндексТекущегоПути, Предшественники, ПоследовательЭлементаСхемы);
	КонецЕсли;
	
КонецПроцедуры

#Область КэшДанныхДействий

// Возвращает имя ключа в кэше данных действий.
//
// Параметры:
//  ПроцессШаблон - БизнесПроцессСсылка, СправочникСсылка - ссылка на процесс или шаблон процесса.
//
// Возвращаемое значение:
//  Строка
//
Функция ИмяКлючаВКэшеДанныхДействий(ПроцессШаблон) Экспорт
	
	ИмяКлючаВКэше = Строка(ПроцессШаблон.УникальныйИдентификатор());
	
	ИмяКлючаВКэше = "_" + СтрЗаменить(ИмяКлючаВКэше, "-", "");
	
	Возврат ИмяКлючаВКэше;
	
КонецФункции

#КонецОбласти

#КонецОбласти
