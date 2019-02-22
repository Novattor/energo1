
&НаКлиенте
Процедура ОтправительНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ОтправительСсылка) Тогда
		ПоказатьЗначение(, ОтправительСсылка);
	Иначе
		ПоказатьЗначение(, ОтправительНаименование);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Документ = Параметры.Документ;
	Получатель = Параметры.Получатель;
	ОтправительСсылка = Параметры.ОтправительСсылка;
	ОтправительНаименование = Параметры.НазваниеОтправителя;
	
	СписокНастроекДляОтображенияСостояний = 
		Справочники.ВидыСостоянийДокументовВСВД.ПолучитьДанныеДляВыводаСостояний();
	СессииСВДДокумента = РаботаССВД.ПолучитьИдентификаторыСессийСВД(Документ, Получатель);
	ДобавляемыеРеквизиты = Новый Массив;
	Если СессииСВДДокумента.Количество() = 0 Тогда 
		СообщениеОбОшибке = НСтр("ru = 'Некорректные данные в идентификаторах сессий СВД.
			|Обратитесь к администратору.';
			|en = 'Incorrect data identifiers sessions EDES.
			|Please contact your administrator.'");
			
		ВызватьИсключение СообщениеОбОшибке;
	ИначеЕсли СессииСВДДокумента.Количество() > 1 Тогда
		ЭтаФорма.Ширина = 90;
		Элементы.ГруппаВариантыСостояний.ТекущаяСтраница = Элементы.МногоСессий;
		// На основании статусов в реквизит-таблицу добавляются реквизиты-колонки и элементы-колонки
		// Добавление реквизитов
		РеквизитЗаголовок = Новый РеквизитФормы(
				"НаименованиеСессии",
				Новый ОписаниеТипов("Строка"),
				"Состояния",
				"Сессия");
		ДобавляемыеРеквизиты.Добавить(РеквизитЗаголовок);		   
		Для Каждого Настройка Из СписокНастроекДляОтображенияСостояний Цикл
			ИмяРеквизита = СтрЗаменить(Строка(Настройка.Значение.Состояние), " ", "");
			ЗаголовокРеквизита = Строка(Настройка.Значение.Состояние);
			
			РеквизитСтатусСВД = Новый РеквизитФормы(
				ИмяРеквизита,
				Новый ОписаниеТипов("Число"),
				"Состояния",
				ЗаголовокРеквизита);
				
			ДобавляемыеРеквизиты.Добавить(РеквизитСтатусСВД);
			
			РеквизитСтатусСВД = Новый РеквизитФормы(
				"Строка" + ИмяРеквизита,
				Новый ОписаниеТипов("Строка"),
				"Состояния",
				ЗаголовокРеквизита);
				
			ДобавляемыеРеквизиты.Добавить(РеквизитСтатусСВД);
			
			РеквизитСтатусСВД = Новый РеквизитФормы(
				"Ссылка" + ИмяРеквизита,
				Новый ОписаниеТипов(
				"ДокументСсылка.ВходящееСообщениеСВД,ДокументСсылка.ИсходящееСообщениеСВД"),
				"Состояния",
				ЗаголовокРеквизита);
				
			ДобавляемыеРеквизиты.Добавить(РеквизитСтатусСВД);
			
		КонецЦикла;
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		
		// Добавление элементов
		// Добавление колонки в таблицу для отображения заголовка
		ЭлементКолонка = Элементы.Добавить("НаименованиеСессии", Тип("ПолеФормы"), Элементы.Состояния);			
		ЭлементКолонка.Вид = ВидПоляФормы.ПолеВвода;
		ЭлементКолонка.ПутьКДанным = "Состояния.НаименованиеСессии";  
		ЭлементКолонка.Подсказка = НСтр("ru = 'Сессия отправки документа'; en = 'Document sending session'");
		ЭлементКолонка.Ширина = 15;
		ЭлементКолонка.ТолькоПросмотр = Истина;
		
		// Добавление колонок для состояний
		Для каждого Настройка Из СписокНастроекДляОтображенияСостояний Цикл
			
			ИмяРеквизита = СтрЗаменить(Строка(Настройка.Значение.Состояние), " ", "");
			Подсказка = Строка(Настройка.Значение.Состояние);
			
			ГруппаКолонок = Элементы.Добавить("Группа" + ИмяРеквизита, Тип("ГруппаФормы"), Элементы.Состояния);
			ГруппаКолонок.Группировка = ГруппировкаКолонок.ВЯчейке;
		
			ЭлементКолонка = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), ГруппаКолонок);
			ЭлементКолонка.Вид = ВидПоляФормы.ПолеКартинки;
			ЭлементКолонка.ПутьКДанным = "Состояния." + ИмяРеквизита;
			ЭлементКолонка.КартинкаЗначений = БиблиотекаКартинок.СостояниеОперацииСВД;
			ЭлементКолонка.Подсказка = Подсказка;
			ЭлементКолонка.ГиперссылкаЯчейки = Истина;
			ЭлементКолонка.Ширина = 1;	
			
			ЭлементКолонка = Элементы.Добавить("Строка" + ИмяРеквизита, Тип("ПолеФормы"), ГруппаКолонок);
			ЭлементКолонка.Вид = ВидПоляФормы.ПолеВвода;
			ЭлементКолонка.ПутьКДанным = "Состояния." + "Строка" + ИмяРеквизита;   
			ЭлементКолонка.Подсказка = Подсказка;
			ЭлементКолонка.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			ЭлементКолонка.Ширина = 12;
			ЭлементКолонка.РастягиватьПоГоризонтали = Ложь;
			ЭлементКолонка.ОтображатьВШапке = Ложь;
			ЭлементКолонка.ТолькоПросмотр = Истина;
			
		КонецЦикла;
	Иначе 
		ЭтаФорма.Ширина = 45;
		Элементы.ГруппаВариантыСостояний.ТекущаяСтраница = Элементы.ОднаСессия;
		Сессия = СессииСВДДокумента[0];
		ИсторияСостояний = РаботаССВД.ПолучитьИсториюСтатусовСессииСВД(
			Документ, 
			Получатель, 
			Сессия.ИдентификаторСессии);
			Для Каждого Настройка Из СписокНастроекДляОтображенияСостояний Цикл
									
				// Добавление реквизитов на форму
				ДобавляемыеРеквизиты.Очистить();
				ИмяРеквизита = СтрЗаменить(Строка(Настройка.Значение.Состояние), " ", "");
				ЗаголовокРеквизита = Строка(Настройка.Значение.Состояние);
				
				РеквизитСтатусСВД = Новый РеквизитФормы(
					ИмяРеквизита,
					Новый ОписаниеТипов("Число"),
					"",
					ЗаголовокРеквизита);
					
				ДобавляемыеРеквизиты.Добавить(РеквизитСтатусСВД);
				
				РеквизитСтатусСВД = Новый РеквизитФормы(
					"Строка" + ИмяРеквизита,
					Новый ОписаниеТипов("Строка"),
					"",
					ЗаголовокРеквизита);
					
				ДобавляемыеРеквизиты.Добавить(РеквизитСтатусСВД);
				
				РеквизитСтатусСВД = Новый РеквизитФормы(
					"Ссылка" + ИмяРеквизита,
					Новый ОписаниеТипов(
					"ДокументСсылка.ВходящееСообщениеСВД,ДокументСсылка.ИсходящееСообщениеСВД"),
					"",
					ЗаголовокРеквизита);
					
				ДобавляемыеРеквизиты.Добавить(РеквизитСтатусСВД);
				
				ИзменитьРеквизиты(ДобавляемыеРеквизиты);
				
				// Добавление элементов на форму
				ЭлементГруппа = Элементы.Добавить(
					"Группа" + ИмяРеквизита, Тип("ГруппаФормы"), Элементы.ГруппаЗаголовок);		
				ЭлементГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
				ЭлементГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
				ЭлементГруппа.ОтображатьЗаголовок = Ложь;
				ЭлементГруппа.Отображение = ОтображениеОбычнойГруппы.Нет;
				
				ЭлементКартинка = Элементы.Добавить("Картинка" + ИмяРеквизита, Тип("ПолеФормы"), ЭлементГруппа);
				ЭлементКартинка.Вид = ВидПоляФормы.ПолеКартинки;
				ЭлементКартинка.ПутьКДанным = ИмяРеквизита;
				ЭлементКартинка.КартинкаЗначений = БиблиотекаКартинок.СостояниеОперацииСВД;
				ЭлементКартинка.Подсказка = Подсказка;
				ЭлементКартинка.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
				ЭлементКартинка.РастягиватьПоГоризонтали = Ложь;
				ЭлементКартинка.РастягиватьПоВертикали = Ложь;
				ЭлементКартинка.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.БезРамки); 
				ЭлементКартинка.Ширина = 2;
				ЭлементКартинка.Высота = 1;
				
				ЭлементДекорацияНадпись = Элементы.Добавить(
					"Надпись" + ИмяРеквизита, Тип("ДекорацияФормы"), ЭлементГруппа);
				ЭлементДекорацияНадпись.Вид = ВидДекорацииФормы.Надпись;
				ЭлементДекорацияНадпись.Заголовок = ЗаголовокРеквизита + ":";
				
				ЭлементГруппаДата = Элементы.Добавить(
					"ГруппаДата" + ИмяРеквизита, Тип("ГруппаФормы"), Элементы.ГруппаДатаИСообщение);		
				ЭлементГруппаДата.Вид = ВидГруппыФормы.ОбычнаяГруппа;
				ЭлементГруппаДата.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
				ЭлементГруппаДата.ОтображатьЗаголовок = Ложь;
				ЭлементГруппаДата.Отображение = ОтображениеОбычнойГруппы.Нет;
				
				ЭлементНадпись = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), ЭлементГруппаДата);
				ЭлементНадпись.Вид = ВидПоляФормы.ПолеНадписи;
				ЭлементНадпись.ПутьКДанным = "Строка" + ИмяРеквизита;
				ЭлементНадпись.Подсказка = Подсказка;
				ЭлементНадпись.Гиперссылка = Истина;
				ЭлементНадпись.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			    ЭлементНадпись.УстановитьДействие("Нажатие", "Подключаемый_СостояниеНажатие");
				ЭлементНадпись.Высота = 1;
					
				ЭлементГруппа.Видимость = Ложь;
				ЭлементГруппаДата.Видимость = Ложь;
				
			КонецЦикла;	
			ЭлементКнопка = Элементы.Добавить("КнопкаОбновить", Тип("КнопкаФормы"), Элементы.ГруппаЗаголовок);		
			ЭлементКнопка.Вид = ВидКнопкиФормы.ОбычнаяКнопка;
			ЭлементКнопка.Заголовок = НСтр("ru = 'Обновить'; en = 'Refresh'");
			ЭлементКнопка.ИмяКоманды = "Обновить";
	КонецЕсли;	
	ЗаполнитьСостояния();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСостояния()
	
	СписокНастроекДляОтображенияСостояний = 
		Справочники.ВидыСостоянийДокументовВСВД.ПолучитьДанныеДляВыводаСостояний();
	СессииСВДДокумента = РаботаССВД.ПолучитьИдентификаторыСессийСВД(Документ, Получатель);
	Если СессииСВДДокумента.Количество() > 1 
		И Элементы.ГруппаВариантыСостояний.ТекущаяСтраница = Элементы.МногоСессий Тогда
		Состояния.Очистить();
		Элементы.ТекстОшибки.Видимость = Ложь;
		// Для каждой сессии будет добавлена строка со статусами
		Для каждого Сессия Из СессииСВДДокумента Цикл
			
			НоваяСтрока = Состояния.Добавить();
			Если СессииСВДДокумента.Количество() > 1 Тогда
				НоваяСтрока.НаименованиеСессии = 
					НСтр("ru = 'Сессия '; en = 'Session '") + (СессииСВДДокумента.Количество() - СессииСВДДокумента.Индекс(Сессия));
			КонецЕсли;
			
			ИсторияСостояний = 
				РаботаССВД.ПолучитьИсториюСтатусовСессииСВД(Документ, Получатель, Сессия.ИдентификаторСессии);

			Для каждого Настройка Из СписокНастроекДляОтображенияСостояний Цикл
				ИмяРеквизита = СтрЗаменить(Строка(Настройка.Значение.Состояние), " ", "");
				НоваяСтрока[ИмяРеквизита] = 0;
				Для Каждого Состояние Из ИсторияСостояний Цикл
					Если Состояние.Состояние = Настройка.Значение.Состояние Тогда
						НоваяСтрока[ИмяРеквизита] = Настройка.Значение.НомерВКоллекции;
						НоваяСтрока["Строка" + ИмяРеквизита] = Формат(Состояние.ДатаУстановки, "ДФ='dd.MM.yyyy HH:mm'");
						Если ЗначениеЗаполнено(Состояние.ТекстОшибки) Тогда
							НоваяСтрока["Строка" + ИмяРеквизита] = НоваяСтрока["Строка" + ИмяРеквизита] + " " +
								Состояние.ТекстОшибки;
							Элементы.ТекстОшибки.Видимость = Истина;								
						КонецЕсли;
						НоваяСтрока["Ссылка" + ИмяРеквизита] = Состояние.Сообщение;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	ИначеЕсли СессииСВДДокумента.Количество() = 1
		ИЛИ СессииСВДДокумента.Количество() > 1
		И Элементы.ГруппаВариантыСостояний.ТекущаяСтраница = Элементы.ОднаСессия Тогда
		Для каждого Настройка Из СписокНастроекДляОтображенияСостояний Цикл
			ИмяРеквизита = СтрЗаменить(Строка(Настройка.Значение.Состояние), " ", "");
			Элементы["Группа" + ИмяРеквизита].Видимость = Ложь;
			Элементы["ГруппаДата" + ИмяРеквизита].Видимость = Ложь;
		КонецЦикла;
		Сессия = СессииСВДДокумента[0];
		ИсторияСостояний = РаботаССВД.ПолучитьИсториюСтатусовСессииСВД(
			Документ, 
			Получатель, 
			Сессия.ИдентификаторСессии);
		Элементы.ТекстОшибки1.Видимость = Ложь;
		Для Каждого Состояние Из ИсторияСостояний Цикл
			Для каждого Настройка Из СписокНастроекДляОтображенияСостояний Цикл
				ИмяРеквизита = СтрЗаменить(Строка(Настройка.Значение.Состояние), " ", "");
				Если Состояние.Состояние = Настройка.Значение.Состояние Тогда
					Элементы["Группа" + ИмяРеквизита].Видимость = Истина;
					Элементы["ГруппаДата" + ИмяРеквизита].Видимость = Истина;
					ЭтаФорма[ИмяРеквизита] = Настройка.Значение.НомерВКоллекции;
					ЭтаФорма[ИмяРеквизита] = Настройка.Значение.НомерВКоллекции;
					ЭтаФорма["Строка" + ИмяРеквизита] = Формат(Состояние.ДатаУстановки, "ДФ='dd.MM.yyyy HH:mm'");
					Если ЗначениеЗаполнено(Состояние.ТекстОшибки) Тогда
						ЭтаФорма["Строка" + ИмяРеквизита] = ЭтаФорма["Строка" + ИмяРеквизита];
						ТекстОшибки = Состояние.ТекстОшибки;
						Элементы.ТекстОшибки1.Видимость = Истина;
					КонецЕсли;
					ЭтаФорма["Ссылка" + ИмяРеквизита] = Состояние.Сообщение;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьСостояния();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СостоянияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекстОшибки = "";
	Если Поле.Имя = "НаименованиеСессии" Тогда
		Возврат;
	КонецЕсли;
	ИмяПоля = СтрЗаменить(Поле.Имя, "Строка", "Ссылка");
	ТекущиеДанные = Элементы.Состояния.ТекущиеДанные;
	Если ИмяПоля <> "СсылкаОшибка" Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные[ИмяПоля]) Тогда
			ПоказатьЗначение(, ТекущиеДанные[ИмяПоля]);
		КонецЕсли;
	Иначе
		ТекстОшибки = ТекущиеДанные.СтрокаОшибка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СостояниеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИмяПоля = "Ссылка" + Элемент.Имя;
	ПоказатьЗначение(, ЭтаФорма[ИмяПоля]);
	
КонецПроцедуры

&НаКлиенте
Процедура СостоянияПриАктивизацииСтроки(Элемент)
	
	ТекстОшибки = "";
	
КонецПроцедуры


