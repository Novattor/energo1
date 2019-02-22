&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ОткрытиеИзСписка") Тогда
		// Открытие по навигационной ссылке.
		Если РаботаСБанками.КлассификаторАктуален() Тогда
			ОповеститьКлассификаторАктуален = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		АвтоматическоеСохранениеДанныхВНастройках = АвтоматическоеСохранениеДанныхФормыВНастройках.НеИспользовать;
		Элементы.ВариантЗагрузки.Доступность = Ложь;
		Элементы.ПутьКДискуИТС.Доступность = Ложь;
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ЗагрузкаССайтаРБК;
	Иначе
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
	КонецЕсли;
	
	ВыполнитьПроверкуПравДоступа("Изменение", Метаданные.Справочники.КлассификаторБанковРФ);
	ВариантЗагрузки = "РБК";
	
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ОповеститьКлассификаторАктуален Тогда
		РаботаСБанкамиКлиент.ОповеститьКлассификаторАктуален();
		Отказ = Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантЗагрузкиПриИзменении(Элемент)
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры

&НаКлиенте
Процедура ПутьКДискуИТСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОчиститьСообщения();
	
	ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораКаталога.Заголовок = НСтр("ru = 'Укажите путь к диску ИТС'; en = 'Specify the disk path to ITS'");
	ДиалогВыбораКаталога.Каталог   = ПутьКДискуИТС;
	
	Если НЕ ДиалогВыбораКаталога.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКДискуИТС = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ДиалогВыбораКаталога.Каталог);
	
	ФайлДанных = Новый Файл(ПутьКДискуИТС + "Database\Garant\MorphDB\Morph.dlc");
	Если НЕ ФайлДанных.Существует() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru ='В указанном каталоге не обнаружены данные классификатора. Необходимо указать путь к диску 1С:ИТС, на котором содержится база ""Гарант. Налоги, бухучет, предпринимательство.""'; en = 'Classifier data is not found in the specified directory. One must specify the path to the 1C:ITS disc that contains database ""Garant. Taxes, accounting, business"".'"),
			,
			"ПутьКДискуИТС");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРезультат Тогда
		Закрыть();
	Иначе
		ОчиститьСообщения();
		Если ВариантЗагрузки = "ИТС" Тогда
			Если НЕ ЗначениеЗаполнено(ПутьКДискуИТС) И Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
				// Не в Windows перебор букв дисков невозможен.
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'При работе не в ОС Windows необходимо явно указать путь к диску'; en = 'If you are not running Windows, you must explicitly specify the drive path'"),
					,
					"ПутьКДискуИТС");
				Возврат;
			КонецЕсли;
			Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыполняетсяЗагрузка;
			УстановитьИзмененияВИнтерфейсе();
		КонецЕсли;
		ПодключитьОбработчикОжидания("ЗагрузитьКлассификатор", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ТекущаяСтраница = Элементы.СтраницыФормы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.СтраницаРезультат Тогда
		#Если ВебКлиент Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ЗагрузкаССайтаРБК;
		#Иначе
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
		#КонецЕсли
	КонецЕсли;
	
	УстановитьИзмененияВИнтерфейсе();

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ЗавершитьФоновоеЗадание(ИдентификаторЗадания);
	КонецЕсли;
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьКлассификатор()
	
	
	ПараметрыЗагрузкиКлассификатора = Новый Соответствие;
	// (Число) Количество новых записей классификатора:
	ПараметрыЗагрузкиКлассификатора.Вставить("Загружено", 0);
	// (Число) Количество обновленных записей классификатора:
	ПараметрыЗагрузкиКлассификатора.Вставить("Обновлено", 0);
	// (Строка) Тест сообщения о результатах загрузки:
	ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", "");
	// (Булево) Флаг успешного завершения загрузки данных классификатора:
	ПараметрыЗагрузкиКлассификатора.Вставить("ЗагрузкаВыполнена", Ложь);
	
	Если ВариантЗагрузки = "ИТС" Тогда
		ПолучитьДанныеБИКРФДискИТС(ПараметрыЗагрузкиКлассификатора);
		АдресХранилища = ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, УникальныйИдентификатор);
		ЗагрузитьРезультат(АдресХранилища);
		Возврат;
	ИначеЕсли ВариантЗагрузки = "РБК" Тогда
		ДлительнаяОперация = ПолучитьДанныеРБКНаСервере(ПараметрыЗагрузкиКлассификатора);
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыполняетсяЗагрузка;
		УстановитьИзмененияВИнтерфейсе();
		
		ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииОперацииЗагрузки", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииОперацииЗагрузки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(НСтр("ru = 'Загрузка классификатора банков'; en = 'Import classifier banks'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			"Ошибка", Результат.ПодробноеПредставлениеОшибки, , Истина);
			
		Элементы.ПоясняющийТекст.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загрузка классификатора банков прервана по причине:
				|%1
				|Подробности см. в журнале регистрации.';
				|en = 'Importing banks classifier aborted because: 
				|%1 
				|See details in the event log.'"),
			Результат.КраткоеПредставлениеОшибки);
			
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРезультат;
		УстановитьИзмененияВИнтерфейсе();
		Возврат;
	КонецЕсли;
	
	ЗагрузитьРезультат(Результат.АдресРезультата);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРезультат(АдресХранилища)
	
	// и в форме загрузки.
	
	Если ВариантЗагрузки = "ИТС" Тогда
		Источник = НСтр("ru ='Диск ИТС'; en = 'Disk ITS'");
	Иначе
		Источник = НСтр("ru ='Сайт РБК'; en = 'Site RBC'");
	КонецЕсли;
	
	ПараметрыЗагрузкиКлассификатора = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	ИмяСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru ='Загрузка классификатора банков. %1.'; en = 'Import classifier banks. %1.'"), Источник);
	
	Если ПараметрыЗагрузкиКлассификатора["ЗагрузкаВыполнена"] Тогда
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия,, 
			ПараметрыЗагрузкиКлассификатора["ТекстСообщения"],, Истина);
		РаботаСБанкамиКлиент.ОповеститьКлассификаторУспешноОбновлен();
	Иначе
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия, 
			"Ошибка", ПараметрыЗагрузкиКлассификатора["ТекстСообщения"],, Истина);
	КонецЕсли;
	Элементы.ПоясняющийТекст.Заголовок = ПараметрыЗагрузкиКлассификатора["ТекстСообщения"];
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРезультат;
	УстановитьИзмененияВИнтерфейсе();
	
	Если (ПараметрыЗагрузкиКлассификатора["Обновлено"] > 0) Или (ПараметрыЗагрузкиКлассификатора["Загружено"] > 0) Тогда
		ОповеститьОбИзменении(Тип("СправочникСсылка.КлассификаторБанковРФ"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеБИКРФДискИТС(ПараметрыЗагрузкиКлассификатора) 
	
	
	ПараметрыЗагрузкиФайловИТС = Новый Соответствие;
	// (Строка) Путь к диску ИТС:
	ПараметрыЗагрузкиФайловИТС.Вставить("ПутьКДискуИТС", "");
	// (Строка) Адрес во временном хранилище, по которому размещен файл данных классификатора:
	ПараметрыЗагрузкиФайловИТС.Вставить("ДанныеИТСАдресДвоичныхДанных", "");
	// (Строка) Адрес во временном хранилище, по которому размещен файл обработки подготовки данных:
	ПараметрыЗагрузкиФайловИТС.Вставить("ПодготовкаИТСАдресДвоичныхДанных", "");
	// (Строка) Текст ошибки:
	ПараметрыЗагрузкиФайловИТС.Вставить("ТекстСообщения", ПараметрыЗагрузкиКлассификатора["ТекстСообщения"]);
	// Другие параметры - см. описание переменной ПараметрыЗагрузкиФайловРБК в ЗагрузитьКлассификатор():
	ПараметрыЗагрузкиФайловИТС.Вставить("Загружено", ПараметрыЗагрузкиКлассификатора["Загружено"]);
	ПараметрыЗагрузкиФайловИТС.Вставить("Обновлено", ПараметрыЗагрузкиКлассификатора["Обновлено"]);
	
	ПолучитьДанныеБИКДискИТС(ПараметрыЗагрузкиФайловИТС);
	
	Если Не ПустаяСтрока(ПараметрыЗагрузкиФайловИТС["ТекстСообщения"]) Тогда
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ПараметрыЗагрузкиФайловИТС["ТекстСообщения"]);
		Возврат;
	КонецЕсли;
	
	ПолучитьСортировщикДискИТС(ПараметрыЗагрузкиФайловИТС);
	
	Если Не ПустаяСтрока(ПараметрыЗагрузкиФайловИТС["ТекстСообщения"]) Тогда
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ПараметрыЗагрузкиФайловИТС["ТекстСообщения"]);
		Возврат;
	КонецЕсли;
	
	ЗагрузитьДанныеДискИТСНаСервере(ПараметрыЗагрузкиФайловИТС);
	
	ПараметрыЗагрузкиКлассификатора.Вставить("Загружено", ПараметрыЗагрузкиФайловИТС["Загружено"]);
	ПараметрыЗагрузкиКлассификатора.Вставить("Обновлено", ПараметрыЗагрузкиФайловИТС["Обновлено"]);
	ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ПараметрыЗагрузкиФайловИТС["ТекстСообщения"]);
	ПараметрыЗагрузкиКлассификатора.Вставить("ЗагрузкаВыполнена", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеБИКДискИТС(ПараметрыЗагрузкиФайловИТС)
	
	// 
// Параметры:
	//   ПараметрыЗагрузкиФайловИТС - см. описание одноименной переменной в ПолучитьДанныеБИКРФДискИТС().
	
	ФайлДанных = Неопределено;
	ФайлНайден = Ложь;
	
	Результат = Новый Структура;
	Если ЗначениеЗаполнено(ПутьКДискуИТС) Тогда
		// Путь к диску указан явно.
		ПутьКДискуИТС = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКДискуИТС);
		ФайлДанных = Новый Файл(ПутьКДискуИТС + "Database\Garant\MorphDB\Morph.dlc");
		Если ФайлДанных.Существует() Тогда
			ПараметрыЗагрузкиФайловИТС.Вставить("ПутьКДискуИТС", ПутьКДискуИТС);
			ФайлНайден = Истина;
		Иначе
			ДанныеИТС = "";
		КонецЕсли;
	Иначе
		// Под Linux - проверка расположена ранее в Далее().
		// Под Windows - перебор букв дисков с D по Z.
		Для Индекс = 68 По 90 Цикл
			НайденныйПутьКДискуИТС = Символ(Индекс) + ":\";
			ФайлДанных = Новый Файл(НайденныйПутьКДискуИТС + "Database\Garant\MorphDB\Morph.dlc");
			Если ФайлДанных.Существует() Тогда
				ПараметрыЗагрузкиФайловИТС.Вставить("ПутьКДискуИТС", НайденныйПутьКДискуИТС);
				ФайлНайден = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ФайлНайден Тогда
		ДанныеИТСАдресДвоичныхДанных = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ФайлДанных.ПолноеИмя));
		ПараметрыЗагрузкиФайловИТС.Вставить("ДанныеИТСАдресДвоичныхДанных", ДанныеИТСАдресДвоичныхДанных);
		ФайлДанных = Неопределено;
	Иначе
		ТекстСообщения = НСтр("ru ='На диске 1С:ИТС не обнаружены данные классификатора БИК РФ. 
		|Для установки требуется диск 1С:ИТС, на котором содержится база ""Гарант. Налоги, бухучет, предпринимательство.""'; en = 'The 1C:ITS disc does not contain the classifier data. To import rhe data one must provide the 1C:ITS disc that contains database ""Garant. Taxes, accounting, business"".'");
		ПараметрыЗагрузкиФайловИТС.Вставить("ТекстСообщения", ТекстСообщения);
	КонецЕсли;
	
	ПараметрыЗагрузкиФайловИТС.Вставить("ТекстСообщения", ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСортировщикДискИТС(ПараметрыЗагрузкиФайловИТС)
	
	// 
// Параметры:
	//   ПараметрыЗагрузкиФайловИТС - см. описание одноименной переменной в ПолучитьДанныеБИКРФДискИТС().
	
	ФайлОбработки = Новый Файл(ПараметрыЗагрузкиФайловИТС["ПутьКДискуИТС"] + "1CITS\EXE\EXTDB\BIKr5v82_MA.epf");
	
	Если ФайлОбработки.Существует() Тогда
		АдресДвоичныхДанных = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ФайлОбработки.ПолноеИмя));
		ПараметрыЗагрузкиФайловИТС.Вставить("ПодготовкаИТСАдресДвоичныхДанных", АдресДвоичныхДанных);
	Иначе
		ПараметрыЗагрузкиФайловИТС.Вставить("ТекстСообщения", НСтр("ru ='На диске ИТС не обнаружен файл обработки подготовки данных классификатора БИК РФ.'; en = 'Data processor file requred to prepare bank classifier data was not found on the ITS disc.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИзмененияВИнтерфейсе()
	
	
	Элементы.ПутьКДискуИТС.Доступность = (ВариантЗагрузки = "ИТС");
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника
		Или Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ЗагрузкаССайтаРБК Тогда
		Элементы.ФормаКнопкаНазад.Видимость  = Ложь;
		Элементы.ФормаКнопкаДалее.Заголовок = НСтр("ru ='Загрузить'; en = 'Import'");
		Элементы.ФормаКнопкаОтмена.Доступность = Истина;
		Элементы.ФормаКнопкаДалее.Доступность  = Истина;
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыполняетсяЗагрузка Тогда
		Элементы.ФормаКнопкаНазад.Видимость = Ложь;
		Элементы.ФормаКнопкаДалее.Доступность  = Ложь;
		Элементы.ФормаКнопкаОтмена.Доступность = Истина;
	Иначе
		Элементы.ФормаКнопкаНазад.Видимость = Истина;
		Элементы.ФормаКнопкаДалее.Заголовок = НСтр("ru ='Закрыть'; en = 'Close'");
		Элементы.ФормаКнопкаОтмена.Доступность = Ложь;
		Элементы.ФормаКнопкаДалее.Доступность  = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьФоновоеЗадание(ИдентификаторЗадания)
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		ФоновоеЗадание.Отменить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеДискИТСНаСервере(ПараметрыЗагрузкиФайловИТС)
	
	// 
// Параметры:
	//   ПараметрыЗагрузкиФайловИТС - см. описание переменной ПараметрыЗагрузкиКлассификатора в
	//                                ПолучитьДанныеБИКРФДискИТС().
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ВызватьИсключение ТекстЗагрузкаЗапрещена();
	КонецЕсли;
	
	РаботаСБанками.ЗагрузитьДанныеДискИТС(ПараметрыЗагрузкиФайловИТС);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеРБКНаСервере(ПараметрыЗагрузкиФайловРБК)
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ВызватьИсключение ТекстЗагрузкаЗапрещена();
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка классификатора банков РФ'; en = 'Import the classifier of Russian banks'");
	
	Результат = ДлительныеОперации.ВыполнитьВФоне("РаботаСБанками.ПолучитьДанныеРБК", ПараметрыЗагрузкиФайловРБК, ПараметрыВыполнения);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ТекстЗагрузкаЗапрещена()
	Возврат НСтр("ru = 'Загрузка классификатора банков в разделенном режиме запрещена.'; en = 'Loading classifier banks in the separated mode is forbidden.'");
КонецФункции

#КонецОбласти
