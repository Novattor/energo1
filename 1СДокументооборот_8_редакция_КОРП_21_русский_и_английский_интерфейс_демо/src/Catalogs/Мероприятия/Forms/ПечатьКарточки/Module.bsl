#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовокОтчета = "";
	
	ВыводитьДатуИМестоПроведения = Истина;
	ВыводитьОрганизацию = Истина;
	ВыводитьПрограмму = Истина;
	ВыводитьУчастников = Истина;
	ВыводитьПредседателяИСекретаря = Истина;
	ВыводитьОрганизатора = Истина;
	ВыводитьПротокол = Истина;
	
	Мероприятие = Параметры.ПараметрКоманды[0];
	РеквизитыМероприятия = 
		ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Мероприятие,
			"ТипПротокола, ТипПрограммы, ВидМероприятия");
	
	ТипПротокола = РеквизитыМероприятия.ТипПротокола;
	ТипПрограммы = РеквизитыМероприятия.ТипПрограммы;
	ПротокольноеМероприятие = РеквизитыМероприятия.ВидМероприятия.ПротокольноеМероприятие;
	
	Элементы.ВыводитьПротокол.Видимость =
		(ТипПротокола = Перечисления.ТипыПрограммыПротокола.ВТаблице И ПротокольноеМероприятие);
	Элементы.ВыводитьПрограмму.Видимость =
		(ТипПрограммы = Перечисления.ТипыПрограммыПротокола.ВТаблице);
	Элементы.ВыводитьПредседателяИСекретаря.Видимость = ПротокольноеМероприятие;
	
	Если ТипЗнч(Параметры.ПараметрКоманды) <> Тип("Массив") Или Параметры.ПараметрКоманды.Количество() > 1 Тогда
		Заголовок = НСтр("ru = 'Печать карточек мероприятий'; en = 'Printing event forms'");
	Иначе
		Заголовок = НСтр("ru = 'Печать карточки мероприятия'; en = 'Printing event form'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ЗаголовокФормы", Заголовок);
	ПараметрыПечати.Вставить("ЗаголовокОтчета", ЗаголовокОтчета);
	ПараметрыПечати.Вставить("ВыводитьДатуИМестоПроведения", ВыводитьДатуИМестоПроведения);
	ПараметрыПечати.Вставить("ВыводитьОрганизацию", ВыводитьОрганизацию);
	ПараметрыПечати.Вставить("ВыводитьУчастников", ВыводитьУчастников);
	ПараметрыПечати.Вставить("ВыводитьОрганизатора", ВыводитьОрганизатора);
	
	Если ПротокольноеМероприятие Тогда 
		ПараметрыПечати.Вставить("ВыводитьПредседателяИСекретаря", ВыводитьПредседателяИСекретаря);
	Иначе
		ПараметрыПечати.Вставить("ВыводитьПредседателяИСекретаря", Ложь);
	КонецЕсли;
	
	Если ТипПрограммы = ПредопределенноеЗначение("Перечисление.ТипыПрограммыПротокола.ВТаблице") Тогда 
		ПараметрыПечати.Вставить("ВыводитьПрограмму", ВыводитьПрограмму);
	Иначе
		ПараметрыПечати.Вставить("ВыводитьПрограмму", Ложь);
	КонецЕсли;
	
	Если ТипПротокола = ПредопределенноеЗначение("Перечисление.ТипыПрограммыПротокола.ВТаблице")
		И ПротокольноеМероприятие Тогда 
		ПараметрыПечати.Вставить("ВыводитьПротокол", ВыводитьПротокол);
	Иначе	
		ПараметрыПечати.Вставить("ВыводитьПротокол", Ложь);	
	КонецЕсли;
	
	Закрыть();
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.Мероприятия", "Карточка", Параметры.ПараметрКоманды, ВладелецФормы, ПараметрыПечати);
	
КонецПроцедуры

#КонецОбласти
