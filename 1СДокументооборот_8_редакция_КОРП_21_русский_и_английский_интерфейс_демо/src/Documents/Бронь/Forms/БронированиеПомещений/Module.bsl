#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ТекущаяДата = ТекущаяДатаСеанса();
	ОтображаемаяДата = ТекущаяДатаСеанса();
	ЗаполнитьДеревоТерриторий();
	ОбновитьОтображение(Истина);
	
	Если Элементы.СтраницыПланировщик.ТекущаяСтраница = Элементы.СтраницаНеНайденыПомещения Тогда
		УстановитьПустуюСтраницу = Истина;
		Элементы.СтраницыПланировщик.ТекущаяСтраница = Элементы.СтраницаПланировщик;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если УстановитьПустуюСтраницу Тогда
		ПодключитьОбработчикОжидания("УстановитьПустуюСтраницу", 0.1, Истина);
	КонецЕсли;
	
	УстановитьОтображаемуюДату(ОтображаемаяДата);
	
	ПодключитьОбработчикОжидания("ОбновитьТекущуюДату", 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Создание_Бронь" Тогда
		СброситьНастройкиОтбора();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_НастройкиПросмотраБроней"
		Или ИмяСобытия = "Запись_Бронь"
		Или ИмяСобытия = "БизнесПроцессСтартован"
		Или ИмяСобытия = "Запись_Мероприятие" Тогда
		ОбновитьОтображениеКлиент(Истина);
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_ТерриторииИПомещения"
		Или ИмяСобытия = "Запись_ОтображаемыеТерритории" Тогда
		ОбновитьОтображениеКлиент(, , Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтображаемаяДатаПриИзменении(Элемент)
	
	ПриИзмененииОтображаемойДаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаПриИзменении(Элемент)
	
	Если ВремяНачала > ВремяОкончания Тогда
		ВремяОкончания = ВремяНачала;
	КонецЕсли;
	ОбновитьОтображениеКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Элемент.СписокВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаОчистка(Элемент, СтандартнаяОбработка)
	
	ВремяОкончания = Неопределено;
	ОбновитьОтображениеКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, ВремяНачала);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, ВремяНачала);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияПриИзменении(Элемент)
	
	Если ВремяНачала > ВремяОкончания Тогда
		ВремяОкончания = ВремяНачала;
	КонецЕсли;
	ОбновитьОтображениеКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Элемент.СписокВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияОчистка(Элемент, СтандартнаяОбработка)
	
	ВремяОкончания = ВремяНачала;
	ОбновитьОтображениеКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, ВремяОкончания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, ВремяОкончания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВместимостьПриИзменении(Элемент)
	
	ОбновитьОтображениеКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНеНайденыПомещенияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "v8doc:reservation/territorychoice" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Документ.Бронь.Форма.ОтображаемыеТерритории", , ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяДатаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НоваяОтображаемаяДата = ТекущаяДата;
	УстановитьОтображаемуюДату(НоваяОтображаемаяДата);
	
	ПриИзмененииОтображаемойДаты();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПланировщика

&НаКлиенте
Процедура ПланировщикПередСозданием(Элемент, Начало, Конец, Значения, Текст, СтандартнаяОбработка)
	
	БронированиеПомещенийКлиент.ОбработкаПередСозданием(Элемент, Начало, Конец, Значения, Текст, СтандартнаяОбработка, Вместимость);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикВыбор(Элемент, СтандартнаяОбработка)
	
	БронированиеПомещенийКлиент.ОбработкаВыбораЭлемента(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПриОкончанииРедактирования(Элемент, НовыйЭлемент, ОтменаРедактирования)
	
	БронированиеПомещенийКлиент.ОбработкаОкончанияРедактированияЭлемента(Элемент, НовыйЭлемент, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередНачаломРедактирования(Элемент, НовыйЭлемент, СтандартнаяОбработка)
	
	БронированиеПомещенийКлиент.ОбработкаПередНачаломРедактированиемЭлемента(Элемент, НовыйЭлемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередУдалением(Элемент, Отказ)
	
	БронированиеПомещенийКлиент.ОбработкаПередУдалениемЭлемента(Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПриСменеТекущегоПериодаОтображения(Элемент, ТекущиеПериодыОтображения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередНачаломБыстрогоРедактирования(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТерритории

&НаКлиенте
Процедура ТерриторииОтображатьТерриториюПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Территории.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЭлементДерева = Территории.НайтиПоИдентификатору(Элементы.Территории.ТекущаяСтрока);
	
	БронированиеПомещенийКлиент.ПриИзмененииПометкиОтображенияТерриторий(
		Элементы.Территории, Территории, ЭлементДерева, ТекущиеДанные.ОтображатьТерриторию);
	
	ОбновитьОтображениеКлиент(, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТерриторииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеСтроки = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.ТерриторииДоступнаСхема Тогда
		СтандартнаяОбработка = Ложь;
		БронированиеПомещенийКлиент.ПоказатьСхемуТерритории(ДанныеСтроки.Ссылка);
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеСтроки.ОтображатьТерриторию = Не ДанныеСтроки.ОтображатьТерриторию;
	ЭлементДерева = Территории.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	БронированиеПомещенийКлиент.ПриИзмененииПометкиОтображенияТерриторий(
		Элемент, Территории, ЭлементДерева, ДанныеСтроки.ОтображатьТерриторию);
	
	ОбновитьОтображениеКлиент(, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТерриторииПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Территории.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущаяТерритория = ТекущиеДанные.Ссылка;
	Иначе
		ТекущаяТерритория = Неопределено;
	КонецЕсли;
	
	Если ЕстьОтображаемыеТерритории(Территории) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьОтображениеКлиент();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтобразитьПредыдущийПериод(Команда)
	
	НоваяОтображаемаяДата = РаботаСРабочимКалендаремКлиентСервер.ПолучитьДатуНачалаПредыдущегоПериода(
		ПредопределенноеЗначение("Перечисление.ПериодОтображенияРабочегоКалендаря.День"), ОтображаемаяДата);
	УстановитьОтображаемуюДату(НоваяОтображаемаяДата);
	
	ПриИзмененииОтображаемойДаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСегодня(Команда)
	
	НоваяОтображаемаяДата = ТекущаяДата();
	УстановитьОтображаемуюДату(НоваяОтображаемаяДата);
	
	ПриИзмененииОтображаемойДаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСледующийПериод(Команда)
	
	НоваяОтображаемаяДата = РаботаСРабочимКалендаремКлиентСервер.ПолучитьДатуНачалаСледующегоПериода(
		ПредопределенноеЗначение("Перечисление.ПериодОтображенияРабочегоКалендаря.День"), ОтображаемаяДата);
	УстановитьОтображаемуюДату(НоваяОтображаемаяДата);
	
	ПриИзмененииОтображаемойДаты();
	
КонецПроцедуры

&НаКлиенте
Процедура Настройки(Команда)
	
	БронированиеПомещенийКлиент.ОткрытьФормуНастройкиПросмотраБроней();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТерриторииВидимость(Команда)
	
	ОтборТерриторииВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборДатаИВремяВидимость(Команда)
	
	ОтборДатаИВремяВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленные(Команда)
	
	ОтображатьУдаленные = Не ОтображатьУдаленные;
	ЗаполнитьДеревоТерриторий();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеТерритории(Команда)
	
	БронированиеПомещенийКлиент.УстановитьПометкуОтображенияПодчиненныхТерриторий(Территории, Истина);
	ОбновитьОтображениеКлиент(, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьТерриторию(Команда)
	
	ТекущиеДанные = Элементы.Территории.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыборВсехТерриторий(Команда)
	
	БронированиеПомещенийКлиент.УстановитьПометкуОтображенияПодчиненныхТерриторий(Территории, Ложь);
	ОбновитьОтображениеКлиент(, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВсеБрони(Команда)
	
	ОткрытьФорму("Документ.Бронь.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ЕстьОтображаемыеТерритории(ЭлементДерева)
	
	Для Каждого ПодчиненныйЭлементДерева Из ЭлементДерева.ПолучитьЭлементы() Цикл
		
		Если ПодчиненныйЭлементДерева.ОтображатьТерриторию Тогда
			Возврат Истина;
		КонецЕсли;
		
		Если ЕстьОтображаемыеТерритории(ПодчиненныйЭлементДерева) Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииОтображаемойДаты()
	
	ОбновитьОтображениеКлиент();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтображение(ЗаполнитьСпискиВыбора = Ложь, ЗапомнитьТерритории = Ложь, ЗаполнитьДеревоТерриторий = Ложь)
	
	Если ЗаполнитьДеревоТерриторий Тогда
		ЗаполнитьДеревоТерриторий();
	КонецЕсли;
	
	ПараметрыБрони = БронированиеПомещенийКлиентСервер.ПолучитьПараметрыБрони();
	ПараметрыБрони.Дата = ОтображаемаяДата;
	ПараметрыБрони.Расположение = ОтображаемыеТерритории(ЗапомнитьТерритории);
	ПараметрыБрони.ВремяНачала = ВремяНачала;
	ПараметрыБрони.ВремяОкончания = ВремяОкончания;
	ПараметрыБрони.Вместимость = Вместимость;
	
	ПланировщикОтображен = БронированиеПомещений.ОтобразитьПланировщикБроней(Планировщик, ПараметрыБрони);
	
	Если ПланировщикОтображен Тогда
		Элементы.СтраницыПланировщик.ТекущаяСтраница = Элементы.СтраницаПланировщик;
	Иначе
		Элементы.СтраницыПланировщик.ТекущаяСтраница = Элементы.СтраницаНеНайденыПомещения;
	КонецЕсли;
	
	Если ЗаполнитьСпискиВыбора Тогда
		ЗаполнитьСпискиВыбора();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтображаемуюДату(НоваяОтображаемаяДата)
	
	Элементы.ОтображаемаяДата.ВыделенныеДаты.Очистить();
	ОтображаемаяДата = НоваяОтображаемаяДата;
	Элементы.ОтображаемаяДата.ВыделенныеДаты.Добавить(ОтображаемаяДата);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеКлиент(ЗаполнитьСпискиВыбора = Ложь, ЗапомнитьТерритории = Ложь, ЗаполнитьДеревоТерриторий = Ложь)
	
	Если ЗаполнитьДеревоТерриторий Тогда
		СвернутыеЭлементы = ПолучитьСвернутыеЭлементы();
	КонецЕсли;
	ОбновитьОтображение(ЗаполнитьСпискиВыбора, ЗапомнитьТерритории, ЗаполнитьДеревоТерриторий);
	Если ЗаполнитьДеревоТерриторий Тогда
		ВосстановитьСостояниеТерритории(Территории.ПолучитьЭлементы(), СвернутыеЭлементы);
		ВосстановитьТекущийЭлементДерева(Территории.ПолучитьЭлементы(), ТекущаяТерритория);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСвернутыеЭлементы()
	
	СвернутыеЭлементы = Новый Массив;
	
	Для Каждого ЭлементДерева Из Территории.ПолучитьЭлементы() Цикл
		
		Если Не Элементы.Территории.Развернут(ЭлементДерева.ПолучитьИдентификатор()) Тогда
			СвернутыеЭлементы.Добавить(ЭлементДерева.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СвернутыеЭлементы;
	
КонецФункции

&НаКлиенте
Процедура ВосстановитьСостояниеТерритории(ЭлементыДерева, СвернутыеЭлементы)
	
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		
		Свернут = Ложь;
		Для Каждого СвернутыйЭлемент Из СвернутыеЭлементы Цикл
			Если ЭлементДерева.Ссылка = СвернутыйЭлемент Тогда
				Элементы.Территории.Свернуть(ЭлементДерева.ПолучитьИдентификатор());
				Свернут = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Свернут Тогда
			Элементы.Территории.Свернуть(ЭлементДерева.ПолучитьИдентификатор());
		Иначе
			Элементы.Территории.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
			ВосстановитьСостояниеТерритории(ЭлементДерева.ПолучитьЭлементы(), СвернутыеЭлементы);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьТекущийЭлементДерева(ЭлементыДерева, ТекущийЭлемент)
	
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		
		Если ЭлементДерева.Ссылка = ТекущийЭлемент Тогда
			Элементы.Территории.ТекущаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
			Возврат;
		КонецЕсли;
		
		ВосстановитьТекущийЭлементДерева(ЭлементДерева.ПолучитьЭлементы(), ТекущийЭлемент);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоТерриторий()
	
	Дерево = РеквизитФормыВЗначение("Территории");
	БронированиеПомещений.ЗаполнитьДеревоТерриторий(Дерево, ОтображатьУдаленные);
	ЗначениеВРеквизитФормы(Дерево, "Территории");
	
	Элементы.ТерриторииКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленные;
	
КонецПроцедуры

&НаСервере
Функция ОтображаемыеТерритории(ЗапомнитьТерритории)
	
	Дерево = РеквизитФормыВЗначение("Территории");
	ОтображаемыеТерритории = БронированиеПомещений.ОтображаемыеТерриторииИзДереваТерриторий(Дерево);
	
	Если ЗапомнитьТерритории Тогда
		БронированиеПомещений.УстановитьПерсональнуюНастройку("ОтображаемыеТерритории", ОтображаемыеТерритории);
	КонецЕсли;
	
	Если ОтображаемыеТерритории.Количество() = 0 И ЗначениеЗаполнено(ТекущаяТерритория) Тогда
		ОтображаемыеТерритории.Добавить(ТекущаяТерритория);
	КонецЕсли;
	
	Возврат ОтображаемыеТерритории;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСпискиВыбора()
	
	// Нижняя и время граница списка выбора в номере получаса в дне.
	НижняяГраница = 1 + БронированиеПомещений.ПолучитьПерсональнуюНастройку("ОтображатьВремяС") * 2;
	ВерхняяГраница = 49 - БронированиеПомещений.ПолучитьПерсональнуюНастройку("ОтображатьВремяПо") * 2;
	
	// Заполнение списка выбора даты начала с 00:00 по 23:30 с интервалом в 30 минут.
	Элементы.ВремяНачала.СписокВыбора.Очистить();
	ТекДата = Дата(1,1,1);
	Для Инд = 1 По 48 Цикл
		
		Если Инд < НижняяГраница Или Инд > ВерхняяГраница Тогда
			ТекДата = ТекДата + 1800;
			Продолжить;
		КонецЕсли;
		
		Элементы.ВремяНачала.СписокВыбора.Добавить(ТекДата, Формат(ТекДата, "ДФ=ЧЧ:мм"));
		ТекДата = ТекДата + 1800;
		
	КонецЦикла;
	
	// Заполнение списка выбора даты окончания с 00:30 до 00:00 следующего дня с интервалом в 30 минут.
	Элементы.ВремяОкончания.СписокВыбора.Очистить();
	ТекДата = Дата(1,1,1);
	Для Инд = 1 По 48 Цикл
		
		Если Инд < НижняяГраница Или Инд > ВерхняяГраница Тогда
			ТекДата = ТекДата + 1800;
			Продолжить;
		КонецЕсли;
		
		Элементы.ВремяОкончания.СписокВыбора.Добавить(ТекДата, Формат(ТекДата, "ДФ=ЧЧ:мм"));
		ТекДата = ТекДата + 1800;
		
	КонецЦикла;
	Если ВерхняяГраница = 49 Тогда
		Элементы.ВремяОкончания.СписокВыбора.Добавить(ТекДата, "00:00");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьНастройкиОтбора()
	
	ВремяНачала = Неопределено;
	ВремяОкончания = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПустуюСтраницу()
	
	Элементы.СтраницыПланировщик.ТекущаяСтраница = Элементы.СтраницаНеНайденыПомещения;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	БронированиеПомещений.УстановитьУсловноеОформлениеТерритории(УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура ОтборТерриторииВидимостьНаСервере()
	
	Элементы.ГруппаОтборТерритории.Видимость = Не Элементы.ГруппаОтборТерритории.Видимость;
	Команды.ОтборТерриторииВидимость.Картинка = ?(Элементы.ГруппаОтборТерритории.Видимость,
		БиблиотекаКартинок.СверткаНиз,
		БиблиотекаКартинок.СверткаПраво);
	
КонецПроцедуры

&НаСервере
Процедура ОтборДатаИВремяВидимостьНаСервере()
	
	Элементы.ГруппаОтборДатаИВремя.Видимость = Не Элементы.ГруппаОтборДатаИВремя.Видимость;
	Команды.ОтборДатаИВремяВидимость.Картинка = ?(Элементы.ГруппаОтборДатаИВремя.Видимость,
		БиблиотекаКартинок.СверткаНиз,
		БиблиотекаКартинок.СверткаПраво);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущуюДату()
	
	ТекущаяДата = ТекущаяДата();
	
КонецПроцедуры

#КонецОбласти
