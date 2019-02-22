
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПротоколированиеРаботыПользователей.ЗаписатьОткрытие(Объект.Ссылка);
	
	УстановитьДоступностьЭлементовПоПравуДоступа(); 
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗаголовокФормы = НСтр("ru = 'Согласование (Создание)'; en = 'Approval (Create)'");
		
		Если Не ЗначениеЗаполнено(Объект.Ответственный) Тогда 
			Объект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
		
	Иначе
		ЗаголовокФормы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Согласование ""%1""'; en = 'Approval ""%1""'"), 
			Объект.НаименованиеБизнесПроцесса);
	КонецЕсли;
	
	// Рабочие группы
	РаботаСРабочимиГруппами.ШаблонПриСозданииНаСервере(ЭтаФорма);
	
	// Инициализация формы механизмом комплексных процессов 
	РаботаСКомплекснымиБизнесПроцессамиСервер.КарточкаШаблонаБизнесПроцессаПриСозданииНаСервере(
		ЭтаФорма, 
		ЗаголовокФормы);
		
	// Инициализация учета времени в сроках задач
	ВестиУчетПлановыхТрудозатратВБизнесПроцессах = ПолучитьФункциональнуюОпцию("ВестиУчетПлановыхТрудозатратВБизнесПроцессах");
	
	// Учет переносов сроков выполнения
	ПереносСроковВыполненияЗадач.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Отложенный старт.
	СтартПроцессовСервер.КарточкаШаблонаПриСозданииНаСервере(ЭтаФорма);
	
	// Сроки выполнения
	УстановитьУсловноеОформлениеИстекшихСроков();
	СрокиИсполненияПроцессов.КарточкаШаблонаПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "Свойства"
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(Объект.Ссылка, ПустойБизнесПроцесс);
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", ПустойБизнесПроцесс);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// Остальная инициализация формы	
	ПредыдущийВариантСогласования = Объект.ВариантСогласования;
	
	Элементы.ИсполнителиИспользоватьУсловия.Пометка = Объект.ИспользоватьУсловия;
	Элементы.Исполнители.ПодчиненныеЭлементы.ИсполнителиОписаниеУсловия.Видимость = Объект.ИспользоватьУсловия;
    
	Элементы.ПодписыватьЭП.Видимость = 
		ПолучитьФункциональнуюОпцию("ИспользоватьВизыСогласования") 
		И ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныеПодписи");
	УстановитьДоступность();
	
	Мультипредметность.ШаблонПриСозданииНаСервере(ЭтаФорма, Объект);
	
	РаботаСБизнесПроцессамиКлиентСервер.ЗаполнитьШаг(Объект.Исполнители);
	
	// Заполнение трудозатрат
	ЕдиницаТрудозатрат = Константы.ОсновнаяЕдиницаТрудозатрат.Получить();
	ЗаполнитьОписаниеТрудозатрат(ЭтаФорма);
	
	// Заголовки команд
	РаботаСБизнесПроцессамиВызовСервера.УстановитьЗаголовкиКомандШаблонаБизнесПроцесса(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.СтандартныеКомандыФормы);
	// Конец СтандартныеПодсистемы.Печать

	// СтандартныеПодсистемы.БазоваяФункциональность
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// Настроим отображение группы доступности шаблона.
	ШаблоныБизнесПроцессов.НастроитьОбластьДоступностиШаблонов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьТрудозатратыУчастниковПроцесса" И Источник = ЭтаФорма Тогда
		ЗаполнитьОписаниеТрудозатрат(ЭтаФорма);
	КонецЕсли;
	
	// Сроки выполнения
	СрокиИсполненияПроцессовКлиент.ОбработкаОповещенияПослеПереносаСрока(
		ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Рабочие группы
	РаботаСРабочимиГруппами.ДокументПриЧтенииНаСервере(ЭтаФорма);
	
	// Формирование исходной рабочей группы.
	Участники = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(Объект.Ссылка);
	ИсходнаяРабочаяГруппа.Очистить();
	Для каждого Эл Из Участники Цикл
		
		Строка = ИсходнаяРабочаяГруппа.Добавить();
		Строка.Участник = Эл.Участник; 
		Строка.Изменение = Эл.Изменение;
		
	КонецЦикла;
	
	МультипредметностьКлиентСервер.ЗаполнитьТаблицуПредметовФормы(Объект);
	МультипредметностьКлиентСервер.ЗаполнитьОписаниеУсловийФормы(Объект);
			
	// СтандартныеПодсистемы.Свойства
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(Объект.Ссылка, ПустойБизнесПроцесс);
	ПустойБизнесПроцессОбъект =
		РеквизитФормыВЗначение("ПустойБизнесПроцесс", Тип("БизнесПроцессОбъект.Согласование"));
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ПустойБизнесПроцессОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	ПрочитатьДоступностьШаблона();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОбщегоНазначенияДокументооборотКлиент.УдалитьПустыеСтрокиТаблицы(Объект.Исполнители, "Исполнитель");
	
	// Сроки исполнения процессов
	СрокиИсполненияПроцессовКлиент.ПодтвердитьПереносСрокаПроцесса(ЭтаФорма, Отказ, ПараметрыЗаписи);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Отложенный старт.
	СтартПроцессовКлиент.КарточкаШаблонаПередЗаписью(ЭтаФорма);
	
	РаботаСКомплекснымиБизнесПроцессамиКлиент.ФормаНастройкиДействияПередЗаписью(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", НЕ ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// Рабочая группа
	РабочаяГруппаТаблицаКоличество = РабочаяГруппаТаблица.Количество();
	Для Инд = 1 По РабочаяГруппаТаблицаКоличество Цикл
		Строка = РабочаяГруппаТаблица[РабочаяГруппаТаблицаКоличество - Инд];
		Если Не ЗначениеЗаполнено(Строка.Участник) Тогда 
			РабочаяГруппаТаблица.Удалить(Строка);
		КонецЕсли;	
	КонецЦикла;
	
	НоваяРабочаяГруппа = РабочаяГруппаТаблица.Выгрузить();
	РабочаяГруппаДобавить = Новый Массив;
	РабочаяГруппаУдалить = Новый Массив;
	
	// Формирование списка удаленных участников рабочей группы
	Для каждого Эл Из ИсходнаяРабочаяГруппа Цикл
		
		Найден = Ложь;
		
		Для каждого Эл2 Из НоваяРабочаяГруппа Цикл
			Если Эл.Участник = Эл2.Участник 
				И Эл.Изменение = Эл2.Изменение Тогда
				
				Найден = Истина;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		
		Если Не Найден Тогда
			РабочаяГруппаУдалить.Добавить(
				Новый Структура("Участник, Изменение", 
					Эл.Участник,
					Эл.Изменение));
		КонецЕсли;
		
	КонецЦикла;	
	
	// Формирование списка добавленных участников рабочей группы
	Для каждого Эл Из НоваяРабочаяГруппа Цикл
		
		Найден = Ложь;
		
		Для каждого Эл2 Из ИсходнаяРабочаяГруппа Цикл
			Если Эл.Участник = Эл2.Участник 
				И Эл.Изменение = Эл2.Изменение Тогда
				
				Найден = Истина;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		
		Если Не Найден Тогда
			РабочаяГруппаДобавить.Добавить(
				Новый Структура("Участник, Изменение", 
					Эл.Участник,
					Эл.Изменение));
		КонецЕсли;
		
	КонецЦикла;	
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("РабочаяГруппаУдалить", РабочаяГруппаУдалить);	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("РабочаяГруппаДобавить", РабочаяГруппаДобавить);
	
	// Учет переноса сроков
	ПереносСроковВыполненияЗадач.ПередатьПричинуИЗаявкуНаПереносаСрока(ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаписатьДоступностьШаблона(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если Объект.ШаблонВКомплексномПроцессе Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Согласование ""%1""'; en = 'Approval ""%1""'"), 
			Объект.НаименованиеБизнесПроцесса);
	КонецЕсли;
	ПротоколированиеРаботыПользователей.ЗаписатьСоздание(Объект.Ссылка, ПараметрыЗаписи.ЭтоНовыйОбъект);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	
	// Рабочая группа
	РаботаСРабочимиГруппами.ОбъектПослеЗаписиНаСервере(ЭтаФорма, ПараметрыЗаписи);
	
	// Формирование исходной рабочей группы.
	Участники = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(Объект.Ссылка);
	ИсходнаяРабочаяГруппа.Очистить();
	Для каждого Эл Из Участники Цикл
		
		Строка = ИсходнаяРабочаяГруппа.Добавить();
		Строка.Участник = Эл.Участник; 
		Строка.Изменение = Эл.Изменение;
		
	КонецЦикла;
	
	МультипредметностьКлиентСервер.ЗаполнитьТаблицуПредметовФормы(Объект);
	МультипредметностьКлиентСервер.ЗаполнитьОписаниеПредметовШаблона(Объект);
	МультипредметностьКлиентСервер.ЗаполнитьОписаниеУсловийФормы(Объект);
	
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковВТаблицеИсполнителей(
		Объект.Исполнители,
		ИспользоватьДатуИВремяВСрокахЗадач,
		ЗначениеЗаполнено(ДатаОтсчетаДляРасчетаСроков));
	ОбновитьПризнакиИстекшихСроков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Сроки выполнения
	СрокиИсполненияПроцессовКлиент.ОповеститьОПереносеСроков(ЭтаФорма);
	
	РаботаСБизнесПроцессамиКлиентСервер.ЗаполнитьШаг(Объект.Исполнители);
	
	Если Объект.ШаблонВКомплексномПроцессе Тогда
		РаботаСКомплекснымиБизнесПроцессамиКлиент.ОповеститьПослеЗаписиНастройкиДействия(ЭтаФорма);
	КонецЕсли;
	
	ШаблоныБизнесПроцессовКлиент.ПоказатьОповещениеПослеЗаписиШаблона(ЭтаФорма);
	
	Оповестить("Запись_ШаблонПроцесса", Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНедоступенДляЗапускаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПроверитьДоступностьШаблона();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРучнойЗапускОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	ПоказатьНезаполненныеПоляНеобходимыеДляСтарта();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Объект.Ответственный);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантСогласованияПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ВариантСогласованияПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантСогласованияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоИтерацийПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.КоличествоИтерацийПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеОтложенногоСтартаНажатие(Элемент, СтандартнаяОбработка)
	
	СтартПроцессовКлиент.ОписаниеОтложенногоСтартаНажатие(ЭтаФорма, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеТрудозатратНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Настройки = Новый Структура;
	Настройки.Вставить("ЕдиницаИзмеренияТрудозатрат", ЕдиницаТрудозатрат);
	Настройки.Вставить("ВариантМаршрутизацииЗадач", Объект.ВариантСогласования);
	Настройки.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	Настройки.Вставить("Участники", Новый Массив);
	
	ВариантыСогласования = РаботаСБизнесПроцессамиКлиентСервер.ВариантыМаршуртизацииЗадач();
	
	Если Объект.ВариантСогласования = ВариантыСогласования.Параллельно Тогда
		
		ТрудозатратыИсполнителей = РаботаСБизнесПроцессамиКлиент.
			СтруктураСтрокиТрудозатратУчастникаПроцесса(
				НСтр("ru = 'Согласующие'; en = 'Approved by'"),
				"ТрудозатратыПланИсполнителя",
				Объект.ТрудозатратыПланИсполнителя);
		Настройки.Участники.Добавить(ТрудозатратыИсполнителей);
		
	Иначе
		
		Для Каждого СтрИсполнитель ИЗ Объект.Исполнители Цикл
		
			ТрудозатратыИсполнителя = РаботаСБизнесПроцессамиКлиент.
				СтруктураСтрокиТрудозатратУчастникаПроцесса(
					НСтр("ru = 'Согласующий'; en = 'Approving'"),
					"ТрудозатратыПланИсполнителя",
					СтрИсполнитель.ТрудозатратыПланИсполнителя,
					СтрИсполнитель.Исполнитель,
					СтрИсполнитель.Шаг,
					СтрИсполнитель.НомерСтроки);
			Настройки.Участники.Добавить(ТрудозатратыИсполнителя);
		
		КонецЦикла;
		
	КонецЕсли;
	
	ТрудозатратыАвтора = РаботаСБизнесПроцессамиКлиент.
		СтруктураСтрокиТрудозатратУчастникаПроцесса(
			НСтр("ru = 'Автор'; en = 'Author'"),
			"ТрудозатратыПланАвтора",
			Объект.ТрудозатратыПланАвтора,
			Объект.Автор);
	Настройки.Участники.Добавить(ТрудозатратыАвтора);
	
	РаботаСБизнесПроцессамиКлиент.НастроитьТрудозатратУчастниковПроцесса(ЭтаФорма, Настройки);
	
КонецПроцедуры

// Шаблоны текста для наименования и описания
&НаКлиенте
Процедура НаименованиеБизнесПроцессаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

    Если ЭтаФорма.Объект.ШаблонВКомплексномПроцессе Тогда  
        РаботаСБизнесПроцессамиКлиент.ВыбратьШаблонТекстаРеализация(ЭтаФорма, "НаименованиеБизнесПроцесса",
		    ПредопределенноеЗначение("Перечисление.ОбластиПримененияШаблоновТекстов.ПроцессСогласованиеНаименование"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    
    Если ЭтаФорма.Объект.ШаблонВКомплексномПроцессе Тогда  
        РаботаСБизнесПроцессамиКлиент.ВыбратьШаблонТекстаРеализация(ЭтаФорма, "Описание",
		    ПредопределенноеЗначение("Перечисление.ОбластиПримененияШаблоновТекстов.ПроцессСогласованиеОписание"));
        КонецЕсли;
        
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеБизнесПроцессаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) и ЭтаФорма.Объект.ШаблонВКомплексномПроцессе Тогда 
		ДанныеВыбора = РаботаСШаблонамиТекстовСервер.СформироватьДанныеВыбораШаблона(
			ПараметрыПолученияДанных, 
			ПредопределенноеЗначение("Перечисление.ОбластиПримененияШаблоновТекстов.ПроцессСогласованиеНаименование"));
			
		Если ДанныеВыбора.Количество() <> 0 Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеБизнесПроцессаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура")  Тогда 
		Объект.НаименованиеБизнесПроцесса = ВыбранноеЗначение.Шаблон;
		Модифицированность = Истина;	
	КонецЕсли;	
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы_Автор

&НаКлиенте
Процедура АвторПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.АвторСоСрокомИсполненияПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Объект.Автор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы_СрокОбработкиРезультатовПредставление

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеПриИзменении(Элемент)
	
	ДопПараметры = СрокиИсполненияПроцессовКлиент.ДопПараметрыДляИзмененияСрокаПоПредставлению();
	ДопПараметры.Форма = ЭтаФорма;
	ДопПараметры.Поле = "СрокОбработкиРезультатовПредставление";
	ДопПараметры.НаименованиеИзмененногоРеквизита = "СрокОбработкиРезультатов";
	ДопПараметры.Исполнитель = Объект.Автор;
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияУчастникаПроцессаПоПредставлению(
		Объект.СрокОбработкиРезультатов,
		Объект.СрокОбработкиРезультатовДни,
		Объект.СрокОбработкиРезультатовЧасы,
		Объект.СрокОбработкиРезультатовМинуты,
		Объект.ВариантУстановкиСрокаОбработкиРезультатов,
		СрокОбработкиРезультатовПредставление,
		ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбораСрока = СрокиИсполненияПроцессовКлиент.ПараметрыВыбораСрокаУчастникаПроцесса();
	ПараметрыВыбораСрока.Форма = ЭтаФорма;
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполнения = "СрокОбработкиРезультатов";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияДни = "СрокОбработкиРезультатовДни";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияЧасы = "СрокОбработкиРезультатовЧасы";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияМинуты = "СрокОбработкиРезультатовМинуты";
	ПараметрыВыбораСрока.ИмяРеквизитаВариантУстановкиСрока = "ВариантУстановкиСрокаОбработкиРезультатов";
	ПараметрыВыбораСрока.ИмяРеквизитаПредставлениеСрока = "СрокОбработкиРезультатовПредставление";
	ПараметрыВыбораСрока.ИмяОбъектаФормы = "Объект";
	ПараметрыВыбораСрока.СрокиПредшественников = Объект.Исполнители;
	ПараметрыВыбораСрока.НаименованиеСрокаУчастника = "СрокОбработкиРезультатов";
	ПараметрыВыбораСрока.Участник = Объект.Автор;
	
	СрокиИсполненияПроцессовКлиент.ВыбратьСрокУчастникаПроцесса(ПараметрыВыбораСрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьОтносительныйСрокУчастникаПроцесса(
		ЭтаФорма,
		Объект.СрокОбработкиРезультатов,
		Объект.СрокОбработкиРезультатовДни,
		Объект.СрокОбработкиРезультатовЧасы,
		Объект.СрокОбработкиРезультатовМинуты,
		СрокОбработкиРезультатовПредставление,
		Объект.ВариантУстановкиСрокаОбработкиРезультатов,
		Направление,
		"СрокОбработкиРезультатов");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_РабочаяГруппаТаблица

&НаКлиенте
Процедура РабочаяГруппаТаблицаУчастникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСАдреснойКнигойКлиент.ВыбратьУчастникаРабочейГруппы(ЭтаФорма, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаУчастникАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСРабочимиГруппамиКлиент.ДокументРабочаяГруппаУчастникАвтоПодбор(
		Элемент,
		Текст,
		ДанныеВыбора,
		Ожидание,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаПриНачалеРедактирования(Элемент, НоваяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)

	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаПриОкончанииРедактирования(
		ЭтаФорма,
		Элемент,
		ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаПередУдалением(Элемент, Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"РабочаяГруппаТаблицаПередУдалениемПродолжение",
		ЭтотОбъект);
	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаТаблицаПередУдалением(ЭтаФорма, Отказ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаПередУдалениемПродолжение(Результат, Параметры) Экспорт
	
	ТаблицаРГ = Элементы.РабочаяГруппаТаблица;
	Для Каждого Индекс Из ТаблицаРГ.ВыделенныеСтроки Цикл
		РабочаяГруппаТаблица.Удалить(ТаблицаРГ.ДанныеСтроки(Индекс));
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Исполнители

&НаКлиенте
Процедура ИсполнителиПриИзменении(Элемент)
	
	ОтключитьДоступностьШаблона();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиВыбор(
		ЭтаФорма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПриАктивизацииСтроки(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиСогласованияПриАктивизацииСтроки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиПриНачалеРедактирования(
		ЭтаФорма, НоваяСтрока,
		Элементы.Исполнители,
		Объект.Исполнители,
		Объект.ВариантСогласования,
		"ПорядокСогласования");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиПриОкончанииРедактирования(
		ЭтаФорма, НоваяСтрока, ОтменаРедактирования, Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПослеУдаления(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиСогласованияПослеУдаления(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Поле Исполнитель

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительПриИзменении(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительСогласованияНачалоВыбора(
		ЭтаФорма, СтандартнаяОбработка, Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОчистка(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительОчистка(
		СтандартнаяОбработка, Элементы.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительОбработкаВыбора(
		ЭтаФорма, ВыбранноеЗначение, Элементы.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительОкончаниеВводаТекста(
		ЭтаФорма, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительОкончаниеВводаТекста(
		ЭтаФорма, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Поле ПорядокСогласования

&НаКлиенте
Процедура ПорядокСогласованияПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ПорядокИсполненияПриИзмененииТаблицыИсполнители(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

// Поле ИсполнителиСрокИсполненияПредставление

&НаКлиенте
Процедура ИсполнителиСрокИсполненияПредставлениеПриИзменении(Элемент)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияПоПредставлениюВТаблицеИсполнители(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, Объект.ВариантСогласования);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСрокИсполненияПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ВыбратьСрокИсполненияДляСтрокиТаблицыИсполнители(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, Объект.ВариантСогласования);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСрокИсполненияПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияВТаблицеИсполнители(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, Направление, Объект.ВариантСогласования);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПредметы

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	МультипредметностьКлиент.ПредметыШаблонаИзменитьПредмет(ЭтаФорма, Объект, ВыбраннаяСтрока, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ПредметыПриАктивизацииСтрокиОтложенно", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПриАктивизацииСтрокиОтложенно()
	
	МультипредметностьКлиент.ПредметыШаблонаПриАктивизацииСтроки(ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	МультипредметностьКлиент.ПредметыШаблонаПередНачаломДобавления(ЭтаФорма, Объект, Отказ, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ВыбраннаяСтрока = Элементы.Предметы.ТекущаяСтрока;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		МультипредметностьКлиент.ПредметыШаблонаИзменитьПредмет(ЭтаФорма, Объект, ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередУдалением(Элемент, Отказ)
	
	МультипредметностьКлиент.ПредметыПередУдалением(ЭтаФорма, Объект, Отказ, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПослеУдаления(Элемент)
	
	МультипредметностьКлиентСервер.УстановитьДоступностьКнопокУправленияПредметами(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ТочкиМаршрута
 
&НаКлиенте
Процедура ТочкиМаршрутаПриИзменении(Элемент)
	
	МультипредметностьКлиент.ТочкиМаршрутаПриИзменении(ЭтаФорма, Объект, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУсловияЗапретаВыполнения

&НаКлиенте
Процедура УсловияЗапретаВыполненияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ШаблоныБизнесПроцессовКлиент.УсловияЗапретаВыполненияВыбор(ЭтаФорма, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ЗаписатьИЗакрыть(Команда, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыДобавитьВспомогательный(Команда)
	
	МультипредметностьКлиент.ПредметыДобавитьВспомогательный(ЭтаФорма, Объект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыДобавитьЗаполняемый(Команда)
	
	МультипредметностьКлиент.ПредметыДобавитьЗаполняемый(ЭтаФорма, Объект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыДобавитьОсновной(Команда)
	
	МультипредметностьКлиент.ПредметыДобавитьОсновной(ЭтаФорма, Объект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыИзменитьПредмет(Команда)
	
	ВыбраннаяСтрока = Элементы.Предметы.ТекущаяСтрока;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		МультипредметностьКлиент.ПредметыШаблонаИзменитьПредмет(ЭтаФорма, Объект, ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыИзменитьРоль(Команда)
	
	ВыбраннаяСтрока = Элементы.Предметы.ТекущаяСтрока;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		МультипредметностьКлиент.ИзменитьРольПредмета(ЭтаФорма, Объект, ВыбраннаяСтрока, Ложь);
		МультипредметностьКлиент.ПредметыШаблонаПриАктивизацииСтроки(ЭтаФорма, Объект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьУчастниковРабочейГруппы(Команда)
	
	РаботаСАдреснойКнигойКлиент.ПодобратьУчастниковРабочейГруппы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
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

#Область ОбработчикиКомандФормы_Исполнители

&НаКлиенте
Процедура Подобрать(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ПодобратьИсполнителейСогласования(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ПереместитьИсполнителяПроцессаСогласования(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, -1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ПереместитьИсполнителяПроцессаСогласования(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУсловия(Команда)
	
	Элементы.Исполнители.ПодчиненныеЭлементы.ИсполнителиОписаниеУсловия.Видимость = 
		НЕ Элементы.Исполнители.ПодчиненныеЭлементы.ИсполнителиОписаниеУсловия.Видимость;
	 
	Элементы.ИсполнителиИспользоватьУсловия.Пометка = 
		Элементы.Исполнители.ПодчиненныеЭлементы.ИсполнителиОписаниеУсловия.Видимость;
		
	Объект.ИспользоватьУсловия = Элементы.ИсполнителиИспользоватьУсловия.Пометка;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьОписаниеТрудозатрат(Форма)
	
	ПараметрыОписания = Новый Структура;
	
	ВариантыМаршуртизацииЗадач = РаботаСБизнесПроцессамиКлиентСервер.ВариантыМаршуртизацииЗадач();
	
	Если Форма.Объект.ВариантСогласования = ВариантыМаршуртизацииЗадач.Параллельно Тогда

		ПараметрыОписания.Вставить("Исполнитель", Истина);
		ПараметрыОписания.Вставить("ПредставлениеИсполнителя", "Согласующие (для каждого)");
	Иначе
		ПараметрыОписания.Вставить("Исполнители", Истина);
		ПараметрыОписания.Вставить("ПредставлениеИсполнителей", "Согласующие");
	КонецЕсли;
	
	ПараметрыОписания.Вставить("Автор", Истина);
	
	РаботаСБизнесПроцессамиКлиентСервер.ЗаполнитьОписаниеТрудозатрат(Форма, ПараметрыОписания);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность() Экспорт
	
	Если Объект.ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно Тогда 
		Элементы.ПорядокСогласования.Видимость = Истина;
		Элементы.Шаг.Видимость = Истина;
	Иначе
		Элементы.ПорядокСогласования.Видимость = Ложь;
		Элементы.Шаг.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает доступность элементов формы при ее открытии в зависимости от
// прав доступа к шаблону.
//
&НаСервере
Процедура УстановитьДоступностьЭлементовПоПравуДоступа()
	
	Если НЕ Объект.Ссылка.Пустая()
		И НЕ ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка).Изменение Тогда
		
		ТолькоПросмотр = Истина;
		
		Элементы.РабочаяГруппаТаблица.ТолькоПросмотр = Истина;
		Элементы.ТочкиМаршрута.ТолькоПросмотр = Истина;
		
		Элементы.ФормаЗакрытьФорму.Видимость = Истина;
		Элементы.ФормаЗакрытьФорму.КнопкаПоУмолчанию = Истина;
		Элементы.ФормаЗаписатьИЗакрыть.Видимость = Ложь;
		
		Элементы.ПереместитьВверх.Доступность = Ложь;
		Элементы.ПереместитьВниз.Доступность = Ложь;
		Элементы.ИсполнителиИспользоватьУсловия.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции_ПодсистемаСвойств

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
      УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
      УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_СрокиИсполненияПроцессов

// Заполняет представление сроков в карточке процесса
//
&НаСервере
Процедура ОбновитьСрокиИсполненияНаСервере() Экспорт
	
	РассчитатьОтносительныйСрок = Ложь;
	РассчитьтатьТочныйСрок = Ложь;
	
	Смещение = СрокиИсполненияПроцессовКлиентСерверКОРП.СмещенияДатыОтсчетаВКарточке(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.ВладелецШаблона)
		Или ЭтоДействиеШаблонаКомплексногоПроцесса
		Или (ЭтоДействиеКомплексногоПроцессаПоШаблону И Не КомплексныйПроцессСтартован) Тогда
		
		РассчитатьОтносительныйСрок = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаОтсчетаДляРасчетаСроков)
		И (Не КомплексныйПроцессСтартован
			Или ЗначениеЗаполнено(РеквизитТаблицаСИзмененнымСроком)) Тогда
		
		РассчитьтатьТочныйСрок = Истина;
	КонецЕсли;
	
	Если РассчитатьОтносительныйСрок Тогда
		ДлительностьПроцесса = СрокиИсполненияПроцессов.ДлительностьИсполненияПроцесса(Объект, Смещение);
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ДлительностьПроцесса);
	КонецЕсли;
	
	Если РассчитьтатьТочныйСрок Тогда
		ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
		ПараметрыДляРасчетаСроков.ДатаОтсчета = ДатаОтсчетаДляРасчетаСроков;
		ПараметрыДляРасчетаСроков.РеквизитТаблицаСИзмененнымСроком = РеквизитТаблицаСИзмененнымСроком;
		ПараметрыДляРасчетаСроков.ИндексСтроки = ИндексСтрокиСИзмененнымСроком;
		ПараметрыДляРасчетаСроков.Смещение = Смещение;
		
		СрокиИсполненияПроцессов.РассчитатьСрокиСогласования(Объект, ПараметрыДляРасчетаСроков);
		
		СрокиИсполненияПроцессовКОРП.ПроверитьИзменениеСроковВКарточкеШаблонаПроцесса(ЭтаФорма);
	КонецЕсли;
	
	РеквизитТаблицаСИзмененнымСроком = "";
	ИндексСтрокиСИзмененнымСроком = 0;
	
	ОбновитьПризнакиИстекшихСроков();
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

// см. ОбновитьСрокиИсполненияНаСервере
&НаКлиенте
Процедура ОбновитьСрокиИсполнения()
	
	ОбновитьСрокиИсполненияНаСервере();
	
КонецПроцедуры

// см. ОбновитьСрокиИсполнения
&НаКлиенте
Процедура ОбновитьСрокиИсполненияОтложенно(РеквизитТаблица = "", ИндексСтроки = 0) Экспорт
	
	РеквизитТаблицаСИзмененнымСроком = РеквизитТаблица;
	ИндексСтрокиСИзмененнымСроком = ИндексСтроки;
	
	ПодключитьОбработчикОжидания("ОбновитьСрокиИсполнения", 0.2, Истина);
	
КонецПроцедуры

// Заполняет представление сроков исполнения в карточке процесса.
//
&НаКлиенте
Процедура ЗаполнитьПредставлениеСроковИсполнения() Экспорт
	
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

// Обновляет форму процесса после переноса сроков действий
//
&НаСервере
Процедура ОбновитьФормуПослеПереносаСроковИсполнения() Экспорт
	
	Прочитать();
	ОбновитьСрокиИсполненияНаСервере();
	
КонецПроцедуры

// Устанавливает условное оформление истекших сроков.
//
&НаСервере
Процедура УстановитьУсловноеОформлениеИстекшихСроков()
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок исполнения истек (Исполнители)'; en = 'Due date is expired (Performers)'"),
		"Объект.Исполнители.СрокИсполненияИстек",
		"ИсполнителиСрокИсполненияПредставление");
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок обработки результатов истек'; en = 'Results processing due date is expired'"),
		"СрокОбработкиРезультатовИстек",
		"СрокОбработкиРезультатовПредставление");
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок исполнения процесса истек'; en = 'Process due date is expired'"),
		"СрокИсполненияПроцессаИстек",
		"СрокИсполненияПроцессаПредставление");
	
КонецПроцедуры

// Обновляет признаки истекших сроков в карточке.
//
&НаСервере
Процедура ОбновитьПризнакиИстекшихСроков()
	
	Если ЗначениеЗаполнено(ДатаОтсчетаДляРасчетаСроков) Тогда
		СрокиИсполненияПроцессов.ОбновитьПризнакИстекшихСроковВТаблицеИсполнителей(
			Объект.Исполнители, ТекущаяДатаСеанса());
		
		СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаУчастника(
			Объект.СрокОбработкиРезультатов,
			СрокОбработкиРезультатовИстек,
			ТекущаяДатаСеанса());
			
		СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаПроцесса(
			Объект.СрокИсполненияПроцесса, ТекущаяДатаСеанса(), СрокИсполненияПроцессаИстек);
	Иначе
		Для Каждого СтрокаИсполнитель Из Объект.Исполнители Цикл
			СтрокаИсполнитель.СрокИсполненияИстек = Ложь;
		КонецЦикла;
		СрокОбработкиРезультатовИстек = Ложь;
		СрокИсполненияПроцессаИстек = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ДоступностьШаблоновПроцессов

// Помещает доступность шаблона процесса в карточку.
//
&НаСервере
Процедура ПрочитатьДоступностьШаблона()
	
	ШаблоныБизнесПроцессов.ПрочитатьДоступностьШаблона(ЭтаФорма);
	
КонецПроцедуры

// Записывает доступность шаблона процесса из карточки.
//
// Параметры:
//  ШаблонОбъект - СправочникОбъект.<ИмяШаблонаПроцесса> - объект шаблона процесса.
//
&НаСервере
Процедура ЗаписатьДоступностьШаблона(ШаблонОбъект)
	
	ШаблоныБизнесПроцессов.ЗаписатьДоступностьШаблонаИзФормы(ШаблонОбъект, ЭтаФорма);
	
КонецПроцедуры

// Проверяет доступность шаблона и помещает результат в реквизиты
// ДоступенРучнойЗапускПоШаблону, ДоступенАвтоматическийЗапускПоШаблону.
//
&НаСервере
Процедура ПроверитьДоступностьШаблона()
	
	ШаблоныБизнесПроцессов.ПроверитьДоступностьШаблона(ЭтаФорма);
	
КонецПроцедуры

// Выводить сообщения пользователю с привязкой к незаполненным полям
// необходимым для старта процессов по шаблону.
//
&НаСервере
Процедура ПоказатьНезаполненныеПоляНеобходимыеДляСтарта()
	
	ШаблоныБизнесПроцессов.ПоказатьНезаполненныеПоляНеобходимыеДляСтарта(ЭтаФорма);
	
КонецПроцедуры

// Сбрасывает доступность в карточке шаблона процесса.
//
&НаКлиенте
Процедура ОтключитьДоступностьШаблона()
	
	ШаблоныБизнесПроцессовКлиент.ОтключитьДоступностьШаблона(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
