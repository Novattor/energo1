
#Область ПрограммныйИнтерфейс

// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ЗначенияРеквизитовОбъекта()
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка, ОтветственныеЗаОбработкуПисем";
	
КонецФункции

// Проверяет наличие метода.
// 
Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет переданную таблицу дескрипторов объекта.
// 
Процедура ЗаполнитьДескрипторыОбъекта(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено) Экспорт
	
	ТаблицаОтветственных = ОбъектДоступа.ОтветственныеЗаОбработкуПисем.Выгрузить();
	Для Каждого СтрОтветственного Из ТаблицаОтветственных Цикл
		ДокументооборотПраваДоступа.ДобавитьИндивидуальныйДескриптор(
			ОбъектДоступа, ТаблицаДескрипторов, СтрОтветственного.Пользователь, Истина);
	КонецЦикла;
	
	Если ПротоколРасчетаПрав <> Неопределено Тогда
		ЗаписьПротокола = Новый Структура("Элемент, Описание",
			ОбъектДоступа.Ссылка, НСтр("ru = 'Ответственные за обработку писем'; en = 'Responsible for processing emails'"));
		ПротоколРасчетаПрав.Добавить(ЗаписьПротокола);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьПредставлениеАдреса(УчетнаяЗапись) Экспорт
	
	ДанныеУчетнойЗаписи = Почта.ПолучитьДанныеУчетнойЗаписи(УчетнаяЗапись);	
	ПредставлениеАдреса = РаботаСоСтроками.ПолучитьПредставлениеАдресаЭлектроннойПочты(
		ДанныеУчетнойЗаписи.ИмяПользователя,
		ДанныеУчетнойЗаписи.АдресЭлектроннойПочты);
		
	Возврат ПредставлениеАдреса;
	
КонецФункции

// Переносит данные из реквизита УдалитьОтветственныйЗаОбработкуПисем
// в табличную часть ОтветственныеЗаОбработкуПисем
Процедура ПеренестиОтветственныхВТабличнуюЧасть() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетныеЗаписиЭлектроннойПочты.Ссылка
		|ИЗ
		|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты";

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		УчетнаяЗаписьОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		УчетнаяЗаписьОбъект.Заблокировать();
		Если УчетнаяЗаписьОбъект.ОтветственныеЗаОбработкуПисем.Количество() = 0 Тогда
			Строка = УчетнаяЗаписьОбъект.ОтветственныеЗаОбработкуПисем.Добавить();
			Строка.Пользователь = УчетнаяЗаписьОбъект.УдалитьОтветственныйЗаОбработкуПисем;
			УчетнаяЗаписьОбъект.Записать();
		КонецЕсли;	
	КонецЦикла;

КонецПроцедуры	

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ИспользоватьДляОтправки");
	Результат.Добавить("ИспользоватьДляПолучения");
	Возврат Результат;
	
КонецФункции

Функция ЕстьУчетнаяЗаписьСТакимАдресом(АдресЭлектроннойПочты, ВариантИспользования, СсылкаНаСуществующуюЗапись) Экспорт
	
	Если Не ЗначениеЗаполнено(АдресЭлектроннойПочты) Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(УчетныеЗаписиЭлектроннойПочты.Ссылка) КАК Количество
	               |ИЗ
	               |	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	               |ГДЕ
	               |	УчетныеЗаписиЭлектроннойПочты.АдресЭлектроннойПочты = &АдресЭлектроннойПочты
	               |	И УчетныеЗаписиЭлектроннойПочты.Ссылка <> &Ссылка
	               |	И УчетныеЗаписиЭлектроннойПочты.ВариантИспользования = &ВариантИспользования
	               |	И УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = Ложь";
	
	Запрос.Параметры.Вставить("АдресЭлектроннойПочты", АдресЭлектроннойПочты);
	Запрос.Параметры.Вставить("ВариантИспользования", ВариантИспользования);
	Запрос.Параметры.Вставить("Ссылка", СсылкаНаСуществующуюЗапись);
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.Количество = 0 Тогда
			Возврат Ложь;
		Иначе
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" И Не Параметры.Свойство("ЗначениеКопирования")
		И (Не Параметры.Свойство("Ключ") Или Не РаботаСПочтовымиСообщениямиВызовСервера.УчетнаяЗаписьНастроена(Параметры.Ключ)) Тогда
		ВыбраннаяФорма = "ПомощникНастройкиУчетнойЗаписи";
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция РазрешенияУчетныхЗаписей(УчетнаяЗапись = Неопределено) Экспорт
	
	Результат = Новый Соответствие;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	УчетныеЗаписиЭлектроннойПочты.ПротоколВходящейПочты КАК Протокол,
	|	УчетныеЗаписиЭлектроннойПочты.СерверВходящейПочты КАК Сервер,
	|	УчетныеЗаписиЭлектроннойПочты.ПортСервераВходящейПочты КАК Порт,
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ПОМЕСТИТЬ СервераЭлектроннойПочты
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.ПротоколВходящейПочты <> """"
	|	И УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = ЛОЖЬ
	|	И УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляПолучения = ИСТИНА
	|	И УчетныеЗаписиЭлектроннойПочты.СерверВходящейПочты <> """"
	|	И УчетныеЗаписиЭлектроннойПочты.ПортСервераВходящейПочты > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""SMTP"",
	|	УчетныеЗаписиЭлектроннойПочты.СерверИсходящейПочты,
	|	УчетныеЗаписиЭлектроннойПочты.ПортСервераИсходящейПочты,
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = ЛОЖЬ
	|	И УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляОтправки = ИСТИНА
	|	И УчетныеЗаписиЭлектроннойПочты.СерверИсходящейПочты <> """"
	|	И УчетныеЗаписиЭлектроннойПочты.ПортСервераИсходящейПочты > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СервераЭлектроннойПочты.Ссылка КАК Ссылка,
	|	СервераЭлектроннойПочты.Протокол КАК Протокол,
	|	СервераЭлектроннойПочты.Сервер КАК Сервер,
	|	СервераЭлектроннойПочты.Порт КАК Порт
	|ИЗ
	|	СервераЭлектроннойПочты КАК СервераЭлектроннойПочты
	|ГДЕ
	|	&Ссылка = НЕОПРЕДЕЛЕНО
	|
	|СГРУППИРОВАТЬ ПО
	|	СервераЭлектроннойПочты.Протокол,
	|	СервераЭлектроннойПочты.Сервер,
	|	СервераЭлектроннойПочты.Порт,
	|	СервераЭлектроннойПочты.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СервераЭлектроннойПочты.Ссылка,
	|	СервераЭлектроннойПочты.Протокол,
	|	СервераЭлектроннойПочты.Сервер,
	|	СервераЭлектроннойПочты.Порт
	|ИЗ
	|	СервераЭлектроннойПочты КАК СервераЭлектроннойПочты
	|ГДЕ
	|	СервераЭлектроннойПочты.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	СервераЭлектроннойПочты.Протокол,
	|	СервераЭлектроннойПочты.Сервер,
	|	СервераЭлектроннойПочты.Порт,
	|	СервераЭлектроннойПочты.Ссылка
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", УчетнаяЗапись);
	
	УчетныеЗаписи = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока УчетныеЗаписи.Следующий() Цикл
		Разрешения = Новый Массив;
		НастройкиУчетнойЗаписи = УчетныеЗаписи.Выбрать();
		Пока НастройкиУчетнойЗаписи.Следующий() Цикл
			Разрешения.Добавить(
				РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
					НастройкиУчетнойЗаписи.Протокол,
					НастройкиУчетнойЗаписи.Сервер,
					НастройкиУчетнойЗаписи.Порт,
					НСтр("ru = 'Электронная почта.'; en = 'Email.'")));
		КонецЦикла;
		Результат.Вставить(УчетныеЗаписи.Ссылка, Разрешения);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ОпределитьНастройкиУчетнойЗаписи(Параметры, АдресРезультата) Экспорт
	
	АдресЭлектроннойПочты = Параметры.АдресЭлектроннойПочты;
	Пароль = Параметры.Пароль;
	
	НайденныйПрофильSMTP = Неопределено;
	НайденныйПрофильIMAP = Неопределено;
	НайденныйПрофильPOP = Неопределено;
	
	Если Параметры.ДляОтправки Тогда
		НайденныйПрофильSMTP = ОпределитьНастройкиSMTP(АдресЭлектроннойПочты, Пароль);
	КонецЕсли;
	
	Если Параметры.ДляПолучения Тогда
		НайденныйПрофильIMAP = ОпределитьНастройкиIMAP(АдресЭлектроннойПочты, Пароль);
		Если НайденныйПрофильIMAP = Неопределено Тогда
			НайденныйПрофильPOP = ОпределитьНастройкиPOP(АдресЭлектроннойПочты, Пароль);
		КонецЕсли;
	КонецЕсли;
	
	Результат = Новый Структура;
	
	Если НайденныйПрофильIMAP <> Неопределено Тогда
		Результат.Вставить("ИмяПользователяДляПолученияПисем", НайденныйПрофильIMAP.ПользовательIMAP);
		Результат.Вставить("ПарольДляПолученияПисем", НайденныйПрофильIMAP.ПарольIMAP);
		Результат.Вставить("Протокол", "IMAP");
		Результат.Вставить("СерверВходящейПочты", НайденныйПрофильIMAP.АдресСервераIMAP);
		Результат.Вставить("ПортСервераВходящейПочты", НайденныйПрофильIMAP.ПортIMAP);
		Результат.Вставить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты", НайденныйПрофильIMAP.ИспользоватьSSLIMAP);
	КонецЕсли;
	
	Если НайденныйПрофильPOP <> Неопределено Тогда
		Результат.Вставить("ИмяПользователяДляПолученияПисем", НайденныйПрофильPOP.Пользователь);
		Результат.Вставить("ПарольДляПолученияПисем", НайденныйПрофильPOP.Пароль);
		Результат.Вставить("Протокол", "POP");
		Результат.Вставить("СерверВходящейПочты", НайденныйПрофильPOP.АдресСервераPOP3);
		Результат.Вставить("ПортСервераВходящейПочты", НайденныйПрофильPOP.ПортPOP3);
		Результат.Вставить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты", НайденныйПрофильPOP.ИспользоватьSSLPOP3);
	КонецЕсли;
	
	Если НайденныйПрофильSMTP <> Неопределено Тогда
		Результат.Вставить("ИмяПользователяДляОтправкиПисем", НайденныйПрофильSMTP.ПользовательSMTP);
		Результат.Вставить("ПарольДляОтправкиПисем", НайденныйПрофильSMTP.ПарольSMTP);
		Результат.Вставить("СерверИсходящейПочты", НайденныйПрофильSMTP.АдресСервераSMTP);
		Результат.Вставить("ПортСервераИсходящейПочты", НайденныйПрофильSMTP.ПортSMTP);
		Результат.Вставить("ИспользоватьЗащищенноеСоединениеДляИсходящейПочты", НайденныйПрофильSMTP.ИспользоватьSSLSMTP);
	КонецЕсли;
	
	Результат.Вставить("ДляПолучения", НайденныйПрофильIMAP <> Неопределено Или НайденныйПрофильPOP <> Неопределено);
	Результат.Вставить("ДляОтправки", НайденныйПрофильSMTP <> Неопределено);
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Функция ОпределитьНастройкиPOP(АдресЭлектроннойПочты, Пароль)
	Для Каждого Профиль Из ПрофилиPOP(АдресЭлектроннойПочты, Пароль) Цикл
		СообщениеСервера = ПроверитьПодключениеКСерверуВходящейПочты(Профиль, ПротоколИнтернетПочты.POP3);
		
		Если ОшибкаАутентификации(СообщениеСервера) Тогда
			Для Каждого ИмяПользователя Из ВариантыИмениПользователя(АдресЭлектроннойПочты) Цикл
				УстановитьИмяПользователя(Профиль, ИмяПользователя);
				СообщениеОбОшибке = ПроверитьПодключениеКСерверуВходящейПочты(Профиль, ПротоколИнтернетПочты.POP3);
				Если Не ОшибкаАутентификации(СообщениеСервера) Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ОшибкаАутентификации(СообщениеСервера) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Если ПодключениеВыполнено(СообщениеСервера) Тогда
			Возврат Профиль;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

Функция ОпределитьНастройкиIMAP(АдресЭлектроннойПочты, Пароль)
	Для Каждого Профиль Из ПрофилиIMAP(АдресЭлектроннойПочты, Пароль) Цикл
		СообщениеСервера = ПроверитьПодключениеКСерверуВходящейПочты(Профиль, ПротоколИнтернетПочты.IMAP);
		
		Если ОшибкаАутентификации(СообщениеСервера) Тогда
			Для Каждого ИмяПользователя Из ВариантыИмениПользователя(АдресЭлектроннойПочты) Цикл
				УстановитьИмяПользователя(Профиль, ИмяПользователя);
				СообщениеОбОшибке = ПроверитьПодключениеКСерверуВходящейПочты(Профиль, ПротоколИнтернетПочты.IMAP);
				Если Не ОшибкаАутентификации(СообщениеСервера) Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ОшибкаАутентификации(СообщениеСервера) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Если ПодключениеВыполнено(СообщениеСервера) Тогда
			Возврат Профиль;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

Функция ОпределитьНастройкиSMTP(АдресЭлектроннойПочты, Пароль)
	Для Каждого Профиль Из ПрофилиSMTP(АдресЭлектроннойПочты, Пароль) Цикл
		СообщениеСервера = ПроверитьПодключениеКСерверуИсходящейПочты(Профиль, АдресЭлектроннойПочты);
		
		Если ОшибкаАутентификации(СообщениеСервера) Тогда
			Для Каждого ИмяПользователя Из ВариантыИмениПользователя(АдресЭлектроннойПочты) Цикл
				УстановитьИмяПользователя(Профиль, ИмяПользователя);
				СообщениеОбОшибке = ПроверитьПодключениеКСерверуИсходящейПочты(Профиль, АдресЭлектроннойПочты);
				Если Не ОшибкаАутентификации(СообщениеСервера) Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ОшибкаАутентификации(СообщениеСервера) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Если ПодключениеВыполнено(СообщениеСервера) Тогда
			Возврат Профиль;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

Функция ПрофилиPOP(АдресЭлектроннойПочты, Пароль)
	Результат = Новый Массив;
	НастройкиПрофиля = НастройкиПоУмолчанию(АдресЭлектроннойПочты, Пароль);
	
	Для Каждого ВариантНастройкиПодключения Из ВариантыНастройкиПодключенияКСерверуPOP(АдресЭлектроннойПочты) Цикл
		Профиль = Новый ИнтернетПочтовыйПрофиль;
		ЗаполнитьЗначенияСвойств(НастройкиПрофиля, ВариантНастройкиПодключения);
		ЗаполнитьЗначенияСвойств(Профиль, ИнтернетПочтовыйПрофиль(НастройкиПрофиля, ПротоколИнтернетПочты.POP3));
		Результат.Добавить(Профиль);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ПрофилиIMAP(АдресЭлектроннойПочты, Пароль)
	Результат = Новый Массив;
	НастройкиПрофиля = НастройкиПоУмолчанию(АдресЭлектроннойПочты, Пароль);
	
	Для Каждого ВариантНастройкиПодключения Из ВариантыНастройкиПодключенияКСерверуIMAP(АдресЭлектроннойПочты) Цикл
		Профиль = Новый ИнтернетПочтовыйПрофиль;
		ЗаполнитьЗначенияСвойств(НастройкиПрофиля, ВариантНастройкиПодключения);
		ЗаполнитьЗначенияСвойств(Профиль, ИнтернетПочтовыйПрофиль(НастройкиПрофиля, ПротоколИнтернетПочты.IMAP));
		Результат.Добавить(Профиль);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ПрофилиSMTP(АдресЭлектроннойПочты, Пароль)
	Результат = Новый Массив;
	НастройкиПрофиля = НастройкиПоУмолчанию(АдресЭлектроннойПочты, Пароль);
	
	Для Каждого ВариантНастройкиПодключения Из ВариантыНастройкиПодключенияКСерверуSMTP(АдресЭлектроннойПочты) Цикл
		Профиль = Новый ИнтернетПочтовыйПрофиль;
		ЗаполнитьЗначенияСвойств(НастройкиПрофиля, ВариантНастройкиПодключения);
		ЗаполнитьЗначенияСвойств(Профиль, ИнтернетПочтовыйПрофиль(НастройкиПрофиля, ПротоколИнтернетПочты.SMTP));
		Результат.Добавить(Профиль);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ОшибкаАутентификации(СообщениеСервера)
	Возврат СтрНайти(НРег(СообщениеСервера), "authenticat") > 0
		Или СтрНайти(НРег(СообщениеСервера), "password") > 0
		Или СтрНайти(НРег(СообщениеСервера), "[auth]") > 0;
КонецФункции

Функция ПодключениеВыполнено(СообщениеСервера)
	Возврат ПустаяСтрока(СообщениеСервера);
КонецФункции

Процедура УстановитьИмяПользователя(Профиль, ИмяПользователя)
	Если Не ПустаяСтрока(Профиль.Пользователь) Тогда
		Профиль.Пользователь = ИмяПользователя;
	КонецЕсли;
	Если Не ПустаяСтрока(Профиль.ПользовательIMAP) Тогда
		Профиль.ПользовательIMAP = ИмяПользователя;
	КонецЕсли;
	Если Не ПустаяСтрока(Профиль.ПользовательSMTP) Тогда
		Профиль.ПользовательSMTP = ИмяПользователя;
	КонецЕсли;
КонецПроцедуры

Функция НастройкиПоУмолчанию(АдресЭлектроннойПочты, Пароль)
	
	Позиция = СтрНайти(АдресЭлектроннойПочты, "@");
	ИмяСервераВУчетнойЗаписи = Сред(АдресЭлектроннойПочты, Позиция + 1);
	
	Настройки = Новый Структура;
	
	Настройки.Вставить("ИмяПользователяДляПолученияПисем", АдресЭлектроннойПочты);
	Настройки.Вставить("ИмяПользователяДляОтправкиПисем", АдресЭлектроннойПочты);
	
	Настройки.Вставить("ПарольДляОтправкиПисем", Пароль);
	Настройки.Вставить("ПарольДляПолученияПисем", Пароль);
	
	Настройки.Вставить("Протокол", "POP");
	Настройки.Вставить("СерверВходящейПочты", "pop." + ИмяСервераВУчетнойЗаписи);
	Настройки.Вставить("ПортСервераВходящейПочты", 995);
	Настройки.Вставить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты", Истина);
	Настройки.Вставить("ИспользоватьБезопасныйВходНаСерверВходящейПочты", Ложь);
	
	Настройки.Вставить("СерверИсходящейПочты", "smtp." + ИмяСервераВУчетнойЗаписи);
	Настройки.Вставить("ПортСервераИсходящейПочты", 465);
	Настройки.Вставить("ИспользоватьЗащищенноеСоединениеДляИсходящейПочты", Истина);
	Настройки.Вставить("ИспользоватьБезопасныйВходНаСерверИсходящейПочты", Ложь);
	Настройки.Вставить("ТребуетсяВходНаСерверПередОтправкой", Ложь);
	
	Настройки.Вставить("ДлительностьОжиданияСервера", 30);
	Настройки.Вставить("ОставлятьКопииПисемНаСервере", Истина);
	Настройки.Вставить("УдалятьПисьмаССервераЧерез", 0);
	
	Возврат Настройки;
	
КонецФункции

Функция ПроверитьПодключениеКСерверуВходящейПочты(Профиль, Протокол)
	
	ИнтернетПочта = Новый ИнтернетПочта;
	
	ТекстОшибки = "";
	Попытка
		ИнтернетПочта.Подключиться(Профиль, Протокол);
	Исключение
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	ИнтернетПочта.Отключиться();
	
	Если Протокол = ПротоколИнтернетПочты.POP3 Тогда
		ТекстДляЖурнала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1:%2%3 (%4)" + Символы.ПС + "%5",
			Профиль.АдресСервераPOP3,
			Профиль.ПортPOP3,
			?(Профиль.ИспользоватьSSLPOP3, "/SSL", ""),
			Профиль.Пользователь,
			?(ПустаяСтрока(ТекстОшибки), НСтр("ru = 'OK'; en = 'OK'"), ТекстОшибки));
	Иначе
		ТекстДляЖурнала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1:%2%3 (%4)" + Символы.ПС + "%5",
			Профиль.АдресСервераIMAP,
			Профиль.ПортIMAP,
			?(Профиль.ИспользоватьSSLIMAP, "/SSL", ""),
			Профиль.ПользовательIMAP,
			?(ПустаяСтрока(ТекстОшибки), НСтр("ru = 'OK'; en = 'OK'"), ТекстОшибки));
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Проверка подключения к почтовому серверу'; en = 'Mail server connection test'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Информация, , , ТекстДляЖурнала);
	
	Возврат ТекстОшибки;
	
КонецФункции

Функция ПроверитьПодключениеКСерверуИсходящейПочты(Профиль, АдресЭлектроннойПочты)
	
	ПараметрыПисьма = Новый Структура;
	
	Тема = НСтр("ru = 'Тестовое сообщение 1С:Документооборот'; en = 'Test message 1C:Document management'");
	Тело = НСтр("ru = 'Это сообщение отправлено подсистемой электронной почты 1С:Документооборот'; en = 'This message is sent by an email subsystem of 1C:Document management'");
	ИмяОтправителяПисем = НСтр("ru = '1С:Документооборот'; en = '1C:Document management'");
	
	Письмо = Новый ИнтернетПочтовоеСообщение;
	Письмо.Тема = Тема;
	
	Получатель = Письмо.Получатели.Добавить(АдресЭлектроннойПочты);
	Получатель.ОтображаемоеИмя = ИмяОтправителяПисем;
	
	Письмо.ИмяОтправителя = ИмяОтправителяПисем;
	Письмо.Отправитель.ОтображаемоеИмя = ИмяОтправителяПисем;
	Письмо.Отправитель.Адрес = АдресЭлектроннойПочты;
	
	Текст = Письмо.Тексты.Добавить(Тело);
	Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;

	ИнтернетПочта = Новый ИнтернетПочта;
	
	ТекстОшибки = "";
	Попытка
		ИнтернетПочта.Подключиться(Профиль);
		ИнтернетПочта.Послать(Письмо);
	Исключение
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	ИнтернетПочта.Отключиться();
	
	ТекстДляЖурнала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1:%2%3 (%4)" + Символы.ПС + "%5",
		Профиль.АдресСервераSMTP,
		Профиль.ПортSMTP,
		?(Профиль.ИспользоватьSSLSMTP, "/SSL", ""),
		Профиль.ПользовательSMTP,
		?(ПустаяСтрока(ТекстОшибки), НСтр("ru = 'OK'; en = 'OK'"), ТекстОшибки));
		
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Проверка подключения к почтовому серверу'; en = 'Mail server connection test'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Информация, , , ТекстДляЖурнала);
	
	Возврат ТекстОшибки;
	
КонецФункции

Функция ИнтернетПочтовыйПрофиль(НастройкиПрофиля, Протокол)
	
	ДляПолучения = Протокол <> ПротоколИнтернетПочты.SMTP;
	
	Профиль = Новый ИнтернетПочтовыйПрофиль;
	Если ДляПолучения Или НастройкиПрофиля.ТребуетсяВходНаСерверПередОтправкой Тогда
		Если Протокол = ПротоколИнтернетПочты.IMAP Тогда
			Профиль.АдресСервераIMAP = НастройкиПрофиля.СерверВходящейПочты;
			Профиль.ИспользоватьSSLIMAP = НастройкиПрофиля.ИспользоватьЗащищенноеСоединениеДляВходящейПочты;
			Профиль.ПарольIMAP = НастройкиПрофиля.ПарольДляПолученияПисем;
			Профиль.ПользовательIMAP = НастройкиПрофиля.ИмяПользователяДляПолученияПисем;
			Профиль.ПортIMAP = НастройкиПрофиля.ПортСервераВходящейПочты;
			Профиль.ТолькоЗащищеннаяАутентификацияIMAP = НастройкиПрофиля.ИспользоватьБезопасныйВходНаСерверВходящейПочты;
		Иначе
			Профиль.АдресСервераPOP3 = НастройкиПрофиля.СерверВходящейПочты;
			Профиль.ИспользоватьSSLPOP3 = НастройкиПрофиля.ИспользоватьЗащищенноеСоединениеДляВходящейПочты;
			Профиль.Пароль = НастройкиПрофиля.ПарольДляПолученияПисем;
			Профиль.Пользователь = НастройкиПрофиля.ИмяПользователяДляПолученияПисем;
			Профиль.ПортPOP3 = НастройкиПрофиля.ПортСервераВходящейПочты;
			Профиль.ТолькоЗащищеннаяАутентификацияPOP3 = НастройкиПрофиля.ИспользоватьБезопасныйВходНаСерверВходящейПочты;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ДляПолучения Тогда
		Профиль.POP3ПередSMTP = НастройкиПрофиля.ТребуетсяВходНаСерверПередОтправкой;
		Профиль.АдресСервераSMTP = НастройкиПрофиля.СерверИсходящейПочты;
		Профиль.ИспользоватьSSLSMTP = НастройкиПрофиля.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты;
		Профиль.ПарольSMTP = НастройкиПрофиля.ПарольДляОтправкиПисем;
		Профиль.ПользовательSMTP = НастройкиПрофиля.ИмяПользователяДляОтправкиПисем;
		Профиль.ПортSMTP = НастройкиПрофиля.ПортСервераИсходящейПочты;
		Профиль.ТолькоЗащищеннаяАутентификацияSMTP = НастройкиПрофиля.ИспользоватьБезопасныйВходНаСерверИсходящейПочты;
	КонецЕсли;
	
	Профиль.Таймаут = НастройкиПрофиля.ДлительностьОжиданияСервера;
	
	Возврат Профиль;
	
КонецФункции

Функция ВариантыИмениПользователя(АдресЭлектроннойПочты)
	
	Позиция = СтрНайти(АдресЭлектроннойПочты, "@");
	ИмяПользователяВУчетнойЗаписи = Лев(АдресЭлектроннойПочты, Позиция - 1);
	
	Результат = Новый Массив;
	Результат.Добавить(ИмяПользователяВУчетнойЗаписи);
	
	Возврат Результат;
	
КонецФункции

Функция ВариантыНастройкиПодключенияКСерверуIMAP(АдресЭлектроннойПочты)
	
	Позиция = СтрНайти(АдресЭлектроннойПочты, "@");
	ИмяПользователяВУчетнойЗаписи = Лев(АдресЭлектроннойПочты, Позиция - 1);
	ИмяСервераВУчетнойЗаписи = Сред(АдресЭлектроннойПочты, Позиция + 1);
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("СерверВходящейПочты");
	Результат.Колонки.Добавить("ПортСервераВходящейПочты");
	Результат.Колонки.Добавить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты");
	
	// Стандартные настройки, подходящие для ящиков  gmail, yandex и mail.ru
	// имя сервера с префиксом "imap.", защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "imap." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 993;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера с префиксом "mail.", защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 993;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера без префикса "imap.", защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 993;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера с префиксом "imap.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "imap." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 143;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	// Имя сервера с префиксом "mail.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 143;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	// Имя сервера без префикса "imap.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 143;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	Возврат Результат;
	
КонецФункции

Функция ВариантыНастройкиПодключенияКСерверуPOP(АдресЭлектроннойПочты)
	
	Позиция = СтрНайти(АдресЭлектроннойПочты, "@");
	ИмяСервераВУчетнойЗаписи = Сред(АдресЭлектроннойПочты, Позиция + 1);
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("СерверВходящейПочты");
	Результат.Колонки.Добавить("ПортСервераВходящейПочты");
	Результат.Колонки.Добавить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты");
	
	// Стандартные настройки, подходящие для ящиков  gmail, yandex и mail.ru
	// имя сервера с префиксом "pop.", защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "pop." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 995;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера с префиксом "pop3.", защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "pop3." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 995;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера с префиксом "mail.", защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 995;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера без префиксов, защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 995;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера с префиксом "pop.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "pop." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 110;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	// Имя сервера с префиксом "pop3", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "pop3." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 110;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	// Имя сервера с префиксом "mail.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 110;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	// Имя сервера без префиксов, незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 110;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	Возврат Результат;
	
КонецФункции

Функция ВариантыНастройкиПодключенияКСерверуSMTP(АдресЭлектроннойПочты)
	
	Позиция = СтрНайти(АдресЭлектроннойПочты, "@");
	ИмяСервераВУчетнойЗаписи = Сред(АдресЭлектроннойПочты, Позиция + 1);
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("СерверИсходящейПочты");
	Результат.Колонки.Добавить("ПортСервераИсходящейПочты");
	Результат.Колонки.Добавить("ИспользоватьЗащищенноеСоединениеДляИсходящейПочты");
	
	// Стандартные настройки, подходящие для ящиков  gmail, yandex и mail.ru
	// имя сервера с префиксом "smtp.", защищенное соединение, порт 465.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = "smtp." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 465;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Истина;
	
	// Имя сервера с префиксом "mail.", защищенное соединение, порт 465.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 465;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Истина;
	
	// Имя сервера без префиксов, защищенное соединение, порт 465.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 465;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Истина;
	
	// Имя сервера с префиксом "smtp.", защищенное (STARTTLS) соединение, порт 587.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = "smtp." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 587;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
	
	// Имя сервера с префиксом "mail.", защищенное (STARTTLS) соединение, порт 587.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 587;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
	
	// Имя сервера без префиксов, защищенное (STARTTLS) соединение, порт 587.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 587;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
	
	// Имя сервера с префиксом "smtp.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = "smtp." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 25;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
	
	// Имя сервера с префиксом "mail.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 25;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
	
	// Имя сервера без префиксов, незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 25;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
