////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки", расширение безопасного режима.
// 
////////////////////////////////////////////////////////////////////////////////

#Область УстаревшийПрограммныйИнтерфейс

// Создает объект ТекстовыйДокумент и инициализирует его данными файла, помещенном во временное хранилище
// по адресу, переданному в качестве значения параметра АдресДвоичныхДанных.
//
// Параметры:
//  АдресДвоичныхДанных - строка, адрес во временном хранилище, по которому были
//    помещены двоичные данные файла,
//  ТипФайла - КодировкаТекста или строка - кодировка текста в открываемом файле,
//    см. описание метода ТекстовыйДокумент.Прочитать() в синтаксис-помощнике,
//  РазделительСтрок - строка, строка, являющаяся разделителем строк,
//    см. описание метода ТекстовыйДокумент.Прочитать() в синтаксис-помощнике.
//
// Возвращаемое значение: ТекстовыйДокумент.
//
Функция ТекстовыйДокументИзДвоичныхДанных(Знач АдресДвоичныхДанных, Знач ТипФайла = Неопределено, Знач РазделительСтрок = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ВременныйФайл = ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПолучитьФайлИзВременногоХранилища(АдресДвоичныхДанных);
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ВременныйФайл, ТипФайла, РазделительСтрок);
	УдалитьФайлы(ВременныйФайл);
	
	Возврат ТекстовыйДокумент;
	
КонецФункции

// Записывает текстовый документ во временный файл, помещает двоичные данные во временное хранилище
// и возвращает адрес двоичных данных файла во временном хранилище.
//
// Параметры:
//  ТекстовыйДокумент - ТекстовыйДокумент, который необходимо сохранить,
//  ТипФайла - КодировкаТекста или строка - кодировка текста в открываемом файле,
//    см. описание метода ТекстовыйДокумент.Записать() в синтаксис-помощнике,
//  РазделительСтрок - строка, строка, являющаяся разделителем строк,
//    см. описание метода ТекстовыйДокумент.Записать() в синтаксис-помощнике,
//  Адрес - строка или УникальныйИдентификатор, адрес во временном хранилище, по которому надо поместить данные
//    или уникальный идентификатор формы, во временное хранилище которой, надо поместить данные и
//    вернуть новый адрес, см. описание метода глобального контекста ПоместитьВоВременноеХранилище.
//    В синтаксис-помощнике.
//
// Возвращаемое значение - строка, адрес во временном хранилище.
//
Функция ТекстовыйДокументВДвоичныеДанные(Знач ТекстовыйДокумент, Знач ТипФайла = Неопределено, Знач РазделительСтрок = Неопределено, Знач Адрес = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ВременныйФайл = ПолучитьИмяВременногоФайла();
	ТекстовыйДокумент.Записать(ВременныйФайл, ТипФайла, РазделительСтрок);
	Адрес = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ВременныйФайл), Адрес);
	УдалитьФайлы(ВременныйФайл);
	
	Возврат Адрес;
	
КонецФункции

// Создает объект ТабличныйДокумент и инициализирует его данными файла, помещенном во временное хранилище
// по адресу, переданному в качестве значения параметра АдресДвоичныхДанных.
//
// Параметры:
//  АдресДвоичныхДанных - строка, адрес во временном хранилище, по которому были
//    помещены двоичные данные файла.
//
// Возвращаемое значение: ТабличныйДокумент.
//
Функция ТабличныйДокументИзДвоичныхДанных(Знач АдресДвоичныхДанных) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ВременныйФайл = ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПолучитьФайлИзВременногоХранилища(АдресДвоичныхДанных);
	ТабличныйДокумент = Новый ТабличныйДокумент();
	ТабличныйДокумент.Прочитать(ВременныйФайл);
	УдалитьФайлы(ВременныйФайл);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Записывает табличный документ во временный файл, помещает двоичные данные во временное хранилище
// и возвращает адрес двоичных данных файла во временном хранилище.
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент, который необходимо сохранить,
//  ТипФайла - ТипФайлаТабличногоДокумента - формат, в котором будет сохранен табличный документ,
//    см. описание метода ТабличныйДокумент.Записать() в синтаксис-помощнике,
//  Адрес - строка или УникальныйИдентификатор, адрес во временном хранилище, по которому надо поместить данные
//    или уникальный идентификатор формы, во временное хранилище которой, надо поместить данные и
//    вернуть новый адрес, см. описание метода глобального контекста ПоместитьВоВременноеХранилище.
//    В синтаксис-помощнике.
//
// Возвращаемое значение - строка, адрес во временном хранилище.
//
Функция ТабличныйДокументВДвоичныеДанные(Знач ТабличныйДокумент, Знач ТипФайла = Неопределено, Знач Адрес = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ВременныйФайл = ПолучитьИмяВременногоФайла();
	ТабличныйДокумент.Записать(ВременныйФайл, ТипФайла);
	Адрес = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ВременныйФайл), Адрес);
	УдалитьФайлы(ВременныйФайл);
	
	Возврат Адрес;
	
КонецФункции

// Записывает форматированный документ во временный файл, помещает двоичные данные во временное хранилище
// и возвращает адрес двоичных данных файла во временном хранилище.
//
// Параметры:
//  ФорматированныйДокумент - ФорматированныйДокумент, который необходимо сохранить,
//  ТипФайла - ТипФайлаФорматированногоДокумента - формат, в котором будет сохранен форматированный документ,
//    см. описание метода ФорматированныйДокумент.Записать() в синтаксис-помощнике,
//  Адрес - строка или УникальныйИдентификатор, адрес во временном хранилище, по которому надо поместить данные
//    или уникальный идентификатор формы, во временное хранилище которой, надо поместить данные и
//    вернуть новый адрес, см. описание метода глобального контекста ПоместитьВоВременноеХранилище.
//    В синтаксис-помощнике.
//
// Возвращаемое значение - строка, адрес во временном хранилище.
//
Функция ФорматированныйДокументВДвоичныеДанные(Знач ФорматированныйДокумент, Знач ТипФайла = Неопределено, Знач Адрес = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ВременныйФайл = ПолучитьИмяВременногоФайла();
	ФорматированныйДокумент.Записать(ВременныйФайл, ТипФайла);
	Адрес = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ВременныйФайл), Адрес);
	УдалитьФайлы(ВременныйФайл);
	
	Возврат Адрес;
	
КонецФункции

// Возвращает текстовое содержимое из файла, помещенного во временное хранилище
// по адресу, переданному в качестве значения параметра АдресДвоичныхДанных.
//
// Параметры:
//  АдресДвоичныхДанных - строка, адрес во временном хранилище, по которому были
//    помещены двоичные данные файла,
//  Кодировка - КодировкаТекста или строка - кодировка текста читаемого файла,
//    см. описание метода ЧтениеТекста.Открыть() в синтаксис-помощнике,
//  РазделительСтрок - строка, строка, являющаяся разделителем строк в файле,
//    см. описание метода ЧтениеТекста.Открыть() в синтаксис-помощнике,
//  КонвертируемыйРазделительСтрок - строка, строка, являющаяся разделителем строк при конвертации
//    в стандартный перевод строк, см. описание метода ЧтениеТекста.Открыть()
//    в синтаксис-помощнике.
//
// Возвращаемое значение: строка.
//
Функция СтрокаИзДвоичныхДанных(Знач АдресДвоичныхДанных, Знач Кодировка = Неопределено, Знач РазделительСтрок = Неопределено, Знач КонвертируемыйРазделительСтрок = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ВременныйФайл = ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПолучитьФайлИзВременногоХранилища(АдресДвоичныхДанных);
	Чтение = Новый ЧтениеТекста();
	Чтение.Открыть(ВременныйФайл, Кодировка, РазделительСтрок, КонвертируемыйРазделительСтрок);
	Результат = Чтение.Прочитать();
	Чтение.Закрыть();
	УдалитьФайлы(ВременныйФайл);
	
	Возврат Результат;
	
КонецФункции

// Записывает переданную строку во временный файл, помещает двоичные данные во временное хранилище
// и возвращает адрес двоичных данных файла во временном хранилище.
//
// Параметры:
//  Строка - ФорматированныйДокумент, который необходимо сохранить,
//  Кодировка - КодировкаТекста или строка - кодировка текста читаемого файла,
//    см. описание метода ЧтениеТекста.Открыть() в синтаксис-помощнике,
//  РазделительСтрок - строка, строка, являющаяся разделителем строк в файле,
//    см. описание метода ЧтениеТекста.Открыть() в синтаксис-помощнике,
//  КонвертируемыйРазделительСтрок - строка, строка, являющаяся разделителем строк при конвертации
//    в стандартный перевод строк, см. описание метода ЧтениеТекста.Открыть()
//    в синтаксис-помощнике.
//  Адрес - строка или УникальныйИдентификатор, адрес во временном хранилище, по которому надо поместить данные
//    или уникальный идентификатор формы, во временное хранилище которой, надо поместить данные и
//    вернуть новый адрес, см. описание метода глобального контекста ПоместитьВоВременноеХранилище
//    в синтаксис-помощнике.
//
// Возвращаемое значение - строка, адрес во временном хранилище.
//
Функция СтрокаВДвоичныеДанные(Знач Строка, Знач Кодировка = Неопределено, Знач РазделительСтрок = Неопределено, Знач КонвертируемыйРазделительСтрок = Неопределено, Знач Адрес = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ВременныйФайл = ПолучитьИмяВременногоФайла();
	Запись = Новый ЗаписьТекста();
	Запись.Открыть(ВременныйФайл, Кодировка, РазделительСтрок, Ложь, КонвертируемыйРазделительСтрок);
	Запись.Записать(Строка);
	Запись.Закрыть();
	Адрес = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ВременныйФайл), Адрес);
	УдалитьФайлы(ВременныйФайл);
	
	Возврат Адрес;
	
КонецФункции

// Функция выполняет распаковку zip-архива.
//
// Параметры:
//  АдресДвоичныхДанных - строка, адрес во временном хранилище, по которому были
//    помещены двоичные данные файла,
//  Пароль - строка, пароль для доступа к ZIP файлу, если файл зашифрован,
//  ИдентификаторФормы - УникальныйИдентификатор, уникальный идентификатор формы,
//    см. описание метода глобального контекста ПоместитьВоВременноеХранилище
//    в синтаксис-помощнике.
//
// Возвращаемое значение:
//  Соответствие:
//    Ключом соответствия являются имена файлов и каталог, содержащихся в архиве,
//    Значением соответствия для файлов из архива является адрес во временном
//      хранилище, по которому помещены двоичные данные файла,
//      для каталогов - аналогичное соответствие.
//
Функция РаспаковатьАрхив(Знач АдресДвоичныхДанных, Знач Пароль = Неопределено, Знач ИдентификаторФормы = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	ВременныйФайл = ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПолучитьФайлИзВременногоХранилища(АдресДвоичныхДанных);
	КаталогРаспаковки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(КаталогРаспаковки);
	Чтение = Новый ЧтениеZipФайла();
	Чтение.Открыть(ВременныйФайл, Пароль);
	Чтение.ИзвлечьВсе(КаталогРаспаковки, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	Чтение.Закрыть();
	ОписаниеАрхива = Новый Соответствие;
	ИтерацияРаспаковкиАрхива(КаталогРаспаковки + "\", ОписаниеАрхива, ИдентификаторФормы);
	УдалитьФайлы(ВременныйФайл);
	УдалитьФайлы(КаталогРаспаковки);
	
	Возврат ОписаниеАрхива;
	
КонецФункции

// Функция выполняет упаковку файлов в zip-архив.
//
// Параметры:
//  ОписаниеАрхива - Соответствие:
//    Ключом соответствия являются имена файлов и каталог, содержащихся в архиве,
//    Значением соответствия для файлов из архива является адрес во временном
//      хранилище, по которому помещены двоичные данные файла,
//      для каталогов - аналогичное соответствие,
//  Пароль - строка, пароль для доступа к ZIP файлу, если файл зашифрован,
//  Комментарий - строка, комментарий, описывающий zip-файл,
//  МетодСжатия - МетодСжатияZIP - метод сжатия, которым будет сжиматься zip-файл,
//  УровеньСжатия - УровеньСжатияZIP - уровень сжатия данных,
//  МетодШифрования - МетодШифрованияZIP - алгоритм шифрования, которым будет
//    зашифрован zip-файл,
//  ИдентификаторФормы - УникальныйИдентификатор, уникальный идентификатор формы,
//    см. описание метода глобального контекста ПоместитьВоВременноеХранилище
//    в синтаксис-помощнике.
//
// Возвращаемое значение:
//  Строка, адрес во временном хранилище, по которому были помещены двоичные данные
//    упакованного архива.
//
Функция УпаковатьФайлыВАрхив(Знач ОписаниеАрхива, Знач Пароль = Неопределено, Знач Комментарий = Неопределено, Знач МетодСжатия = Неопределено, Знач УровеньСжатия = Неопределено, Знач МетодШифрования = Неопределено, Знач Адрес = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	Если МетодСжатия = Неопределено Тогда
		МетодСжатия = МетодСжатияZIP.Сжатие;
	КонецЕсли;
	
	Если УровеньСжатия = Неопределено Тогда
		УровеньСжатия = УровеньСжатияZIP.Оптимальный;
	КонецЕсли;
	
	Если МетодШифрования = Неопределено Тогда
		МетодШифрования = МетодШифрованияZIP.Zip20;
	КонецЕсли;
	
	ВременныйФайл = ПолучитьИмяВременногоФайла();
	КаталогУпаковки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(КаталогУпаковки);
	ИтерацияУпаковкиАрхива(ОписаниеАрхива, КаталогУпаковки + "\");
	Запись = Новый ЗаписьZipФайла();
	Запись.Открыть(ВременныйФайл, Пароль, Комментарий, МетодСжатия, УровеньСжатия, МетодШифрования);
	Запись.Добавить(КаталогУпаковки,
		РежимСохраненияПутейZIP.СохранятьОтносительныеПути,
		РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
	Запись.Записать();
	Адрес = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ВременныйФайл), Адрес);
	УдалитьФайлы(ВременныйФайл);
	УдалитьФайлы(КаталогУпаковки);
	
	Возврат Адрес;
	
КонецФункции

// Выполняет сценарий дополнительного отчета или обработки в безопасном режиме.
//
// Параметры:
//  КлючСессии - УникальныйИдентификатор, ключ сессии расширения безопасного режима,
//  АдресСценария - строка, адрес во временном хранилище, по которому расположена таблица значений,
//    являющаяся сценарием,
//  КлючЗапуска - СправочникСсылка.ДополнительныеОтчетыИОбработки, ключ запуска, переданный
//    дополнительной обработке при ее инициализации.
//
// Возвращаемое значение: Произвольный.
//
Функция ВыполнитьСценарийВБезопасномРежиме(Знач КлючСессии, Знач АдресСценария, ПараметрыВыполнения = Неопределено, СохраняемыеПараметры = Неопределено, ОбъектыНазначения = Неопределено) Экспорт
	
	ПроверитьКорректностьВызоваПоОкружению();
	
	Сценарий = ПолучитьИзВременногоХранилища(АдресСценария);
	ИсполняемыйОбъект = ДополнительныеОтчетыИОбработки.ОбъектВнешнейОбработки(
		Справочники.ДополнительныеОтчетыИОбработки.ПолучитьСсылку(КлючСессии));
	
	ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ВыполнитьСценарийБезопасногоРежима(
		КлючСессии, Сценарий, ИсполняемыйОбъект, ПараметрыВыполнения, СохраняемыеПараметры, ОбъектыНазначения);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для внутреннего использования.
Функция ИтерацияРаспаковкиАрхива(Знач КаталогРаспаковки, ОписаниеАрхива, Знач ИдентификаторФормы)
	
	Содержимое = НайтиФайлы(КаталогРаспаковки, "*" , Ложь);
	Для Каждого ЭлементСодержимого Из Содержимое Цикл
		Если ЭлементСодержимого.ЭтоКаталог() Тогда
			
			ОписаниеАрхива.Вставить(ЭлементСодержимого.Имя,
				ИтерацияРаспаковкиАрхива(
					ЭлементСодержимого.Путь + "\", Новый Соответствие(), ИдентификаторФормы));
			
		Иначе
			
			ОписаниеАрхива.Вставить(ЭлементСодержимого.Имя,
				ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ЭлементСодержимого.ПолноеИмя),
					ИдентификаторФормы));
			
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

// Для внутреннего использования.
Процедура ИтерацияУпаковкиАрхива(Знач ОписаниеАрхива, Знач КаталогУпаковки)
	
	Для Каждого ЭлементАрхива Из ОписаниеАрхива Цикл
		
		Если ТипЗнч(ЭлементАрхива.Значение) = Тип("Соответствие") Тогда
			
			ИмяПодкаталога = КаталогУпаковки + ЭлементАрхива.Ключ;
			СоздатьКаталог(ИмяПодкаталога);
			ИтерацияУпаковкиАрхива(ЭлементАрхива.Значение, ИмяПодкаталога + "\");
			
		Иначе
			
			ПолучитьИзВременногоХранилища(ЭлементАрхива.Значение).Записать(
				КаталогУпаковки + ЭлементАрхива.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьКорректностьВызоваПоОкружению()
	
	Если Не ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ПроверитьКорректностьВызоваПоОкружению() Тогда
		
		ВызватьИсключение НСтр("ru = 'Некорректный вызов функции общего модуля ДополнительныеОтчетыИОбработкиВБезопасномРежимеВызовСервера!
                                |Экспортируемые функции данного модуля для использования в безопасном режиме должны вызываться только
                                |из сценария или из контекста клиентского приложения!';
                                |en = 'Incorrect call of common module function ДополнительныеОтчетыИОбработкиВБезопасномРежимеВызовСервера!
                                |Exported function of the module for use in safe mode can only be called from a script of from the context of the client
                                |application!'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
