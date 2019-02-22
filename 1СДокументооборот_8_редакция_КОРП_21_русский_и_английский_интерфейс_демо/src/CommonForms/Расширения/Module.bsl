&НаКлиенте
Перем ТекущийКонтекст;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НавигационнаяСсылка = "e1cib/app/ОбщаяФорма.Расширения";
	
	УстановитьРежимРаботы(ЭтотОбъект, ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных());
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа. Обратитесь к администратору.'; en = 'Not enough permissions. Contact the administrator.'");
	КонецЕсли;
	
	Если Не ПравоДоступа("Администрирование", Метаданные) Тогда
		Элементы.СписокРасширенийБезопасныйРежимФлаг.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		ВызватьИсключение НСтр("ru = 'Расширения недоступны в базовой версии программы.'; en = 'Extensions are not available in the basic version of the program.'");
	КонецЕсли;
	
	Если Не ПравоДоступа("АдминистрированиеРасширенийКонфигурации", Метаданные) Тогда
		Элементы.СписокРасширенийОбновить.ТолькоВоВсехДействиях = Ложь;
		Элементы.СписокРасширений.ТолькоПросмотр = Истина;
		Элементы.СписокРасширенийДобавить.Видимость = Ложь;
		Элементы.СписокРасширенийУдалить.Видимость = Ложь;
		Элементы.СписокРасширенийОбновитьИзФайлаНаДиске.Видимость = Ложь;
		Элементы.СписокРасширенийСохранитьКак.Видимость = Ложь;
		Элементы.СписокРасширенийКонтекстноеМенюДобавить.Видимость = Ложь;
		Элементы.СписокРасширенийКонтекстноеМенюУдалить.Видимость = Ложь;
		Элементы.СписокРасширенийКонтекстноеМенюОбновитьИзФайлаНаДиске.Видимость = Ложь;
		Элементы.СписокРасширенийКонтекстноеМенюСохранитьКак.Видимость = Ложь;
	КонецЕсли;
	
	УстановленныеРасширенияДоступны = Справочники.ВерсииРасширений.УстановленныеРасширенияДоступны();
	Элементы.СписокРасширенийПодключено.Видимость = УстановленныеРасширенияДоступны;
	
	ОбновитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыполненВыходИзОбластиДанных" Тогда
		УстановитьРежимРаботы(ЭтотОбъект, Ложь);
		ПодключитьОбработчикОжидания("ОбновитьСписокОбработчикОжидания", 0.1, Истина);
		
	ИначеЕсли ИмяСобытия = "ВыполненВходВОбластьДанных" Тогда
		УстановитьРежимРаботы(ЭтотОбъект, Истина);
		ПодключитьОбработчикОжидания("ОбновитьСписокОбработчикОжидания", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредупреждениеОписаниеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗавершитьРаботуСистемы(Ложь, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРасширений

&НаКлиенте
Процедура СписокРасширенийПриАктивизацииСтроки(Элемент)
	
	Если Элементы.СписокРасширений.ТекущиеДанные <> Неопределено Тогда
		ИдентификаторТекущейСтроки = Элементы.СписокРасширений.ТекущаяСтрока;
	Иначе
		ИдентификаторТекущейСтроки = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ЗагрузитьРасширение(Неопределено, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	УдалитьРасширения(Элемент.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущееРасширение = Элементы.СписокРасширений.ТекущиеДанные;
	Если ТекущееРасширение = Неопределено Тогда
		Возврат;
	КонецЕсли;

	СписокРасширенийПриОкончанииРедактированияНаСервере(ТекущееРасширение.ПолучитьИдентификатор());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ТекущееРасширение = Элементы.СписокРасширений.ТекущиеДанные;
	
	Если ТекущееРасширение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Адрес = СохранитьНаСервере(ТекущееРасширение.ИдентификаторРасширения);
	
	Если Адрес = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Адрес", Адрес);
	Контекст.Вставить("НачальноеИмяФайла", ТекущееРасширение.Имя
		+ "_" + ТекущееРасширение.Версия + ".cfe");
	
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(
		Новый ОписаниеОповещения("СохранитьКакПослеУстановкиРасширения", ЭтотОбъект, Контекст));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКакПослеУстановкиРасширения(РасширениеПодключено, Контекст) Экспорт
	
	Если РасширениеПодключено Тогда
		ПолучаемыеФайлы = Новый Массив;
		ПолучаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(
			Контекст.НачальноеИмяФайла, Контекст.Адрес));
		
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		Диалог.Заголовок = НСтр("ru = 'Выберите файл для сохранения расширения конфигурации'; en = 'Select file to save configuration extension'");
		Диалог.Фильтр    = НСтр("ru = 'Файлы расширений конфигурации (*.cfe)|*.cfe|Все файлы (*.*)|*.*'; en = 'Configuration extension files (*.cfe)|*.cfe|All files (*.*)|*.*'");
		Диалог.МножественныйВыбор = Ложь;
		
		НачатьПолучениеФайлов(Новый ОписаниеОповещения("СохранитьКакПослеПолученияФайлов", ЭтотОбъект, Контекст),
			ПолучаемыеФайлы, Диалог);
	Иначе
		ПолучитьФайл(Контекст.Адрес, Контекст.НачальноеИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКакПослеПолученияФайлов(ПолученныеФайлы, Контекст) Экспорт
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	ТекущееРасширение = Элементы.СписокРасширений.ТекущиеДанные;
	
	Если ТекущееРасширение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьРасширение(ТекущееРасширение.ИдентификаторРасширения);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьУстаревшиеКэшиРасширений(Команда)
	
	УдалитьУстаревшиеКэшиРасширенийНаСервере();
	
	ПоказатьПредупреждение(, НСтр("ru = 'Выполнено удаление устаревших версий параметров работы расширений.'; en = 'Obsolete versions of operating parameters for extensions were deleted.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьРежимРаботы(Форма, РазделенныйРежим = Истина)
	
	Элементы = Форма.Элементы;
	
	Если РазделенныйРежим Тогда
		Элементы.СтраницыРежимРаботы.ТекущаяСтраница = Элементы.СтраницаРазделенныйРежим;
	Иначе
		Элементы.СтраницыРежимРаботы.ТекущаяСтраница = Элементы.СтраницаНеразделенныйРежим;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокОбработчикОжидания()
	
	ОбновитьСписок();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписок(ПослеДобавления = Ложь)
	
	Если Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		СписокРасширений.Очистить();
		Возврат;
	КонецЕсли;
	
	Если ПослеДобавления Тогда
		ИндексТекущейСтроки = СписокРасширений.Количество();
	Иначе
		ИндексТекущейСтроки = 0;
		Если ИдентификаторТекущейСтроки <> Неопределено Тогда
			Строка = СписокРасширений.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
			Если Строка <> Неопределено Тогда
				ИндексТекущейСтроки = СписокРасширений.Индекс(Строка);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СписокРасширений.Очистить();
	
	УстановитьПривилегированныйРежим(Истина);
	Расширения = РасширенияКонфигурации.Получить();
	Если УстановленныеРасширенияДоступны Тогда
		ПодключенныеРасширения = ИдентификаторыРасширений(ИсточникРасширенийКонфигурации.СеансАктивные);
		ОтключенныеРасширения  = ИдентификаторыРасширений(ИсточникРасширенийКонфигурации.СеансОтключенные);
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	Для Каждого Расширение Из Расширения Цикл
		
		ЭлементРасширения = СписокРасширений.Добавить();
		ЭлементРасширения.ИдентификаторРасширения = Расширение.УникальныйИдентификатор;
		ЭлементРасширения.Имя                     = Расширение.Имя;
		ЭлементРасширения.Версия                  = Расширение.Версия;
		ЭлементРасширения.КонтрольнаяСумма        = Base64Строка(Расширение.ХешСумма);
		ЭлементРасширения.Синоним                 = Расширение.Синоним;
		ЭлементРасширения.БезопасныйРежим         = Расширение.БезопасныйРежим;
		
		Если УстановленныеРасширенияДоступны Тогда
			ЭлементРасширения.Подключено =
				?(ПодключенныеРасширения[Расширение.Имя + Расширение.ХешСумма] <> Неопределено, 0,
					?(ОтключенныеРасширения[Расширение.Имя + Расширение.ХешСумма] <> Неопределено, 2, 1));
		КонецЕсли;
		
		Если ПустаяСтрока(ЭлементРасширения.Синоним) Тогда
			ЭлементРасширения.Синоним = ЭлементРасширения.Имя;
		КонецЕсли;
		
		Если ТипЗнч(Расширение.БезопасныйРежим) = Тип("Булево") Тогда
			ЭлементРасширения.БезопасныйРежимФлаг = Расширение.БезопасныйРежим;
		Иначе
			ЭлементРасширения.БезопасныйРежимФлаг = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если ИндексТекущейСтроки >= СписокРасширений.Количество() Тогда
		ИндексТекущейСтроки = СписокРасширений.Количество() - 1;
	КонецЕсли;
	Если ИндексТекущейСтроки >= 0 Тогда
		Элементы.СписокРасширений.ТекущаяСтрока = СписокРасширений.Получить(
			ИндексТекущейСтроки).ПолучитьИдентификатор();
	КонецЕсли;
	
	Если УстановленныеРасширенияДоступны Тогда
		Элементы.ГруппаПредупреждение.Видимость = ПараметрыСеанса.УстановленныеРасширения
			<> Справочники.ВерсииРасширений.КонтрольныеСуммыРасширений(СписокРасширений);
		Элементы.ГруппаИнформация.Видимость = Ложь;
	Иначе
		Элементы.ГруппаПредупреждение.Видимость = Ложь;
		Элементы.ГруппаИнформация.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИдентификаторыРасширений(ИсточникРасширений)
	
	Расширения = РасширенияКонфигурации.Получить(, ИсточникРасширений);
	Идентификаторы = Новый Соответствие;
	
	Для Каждого Расширение Из Расширения Цикл
		Идентификаторы.Вставить(Расширение.Имя + Расширение.ХешСумма, Истина);
	КонецЦикла;
	
	Возврат Идентификаторы;
	
КонецФункции

&НаСервере
Функция СохранитьНаСервере(ИдентификаторРасширения)
	
	Расширение = НайтиРасширение(ИдентификаторРасширения);
	
	Если Расширение <> Неопределено Тогда
		Возврат ПоместитьВоВременноеХранилище(Расширение.ПолучитьДанные(), ЭтотОбъект.УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция НайтиРасширение(ИдентификаторРасширения)
	
	Отбор = Новый Структура;
	Отбор.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор(ИдентификаторРасширения));
	Расширения = РасширенияКонфигурации.Получить(Отбор);
	
	Расширение = Неопределено;
	
	Если Расширения.Количество() = 1 Тогда
		Расширение = Расширения[0];
	КонецЕсли;
	
	Возврат Расширение;
	
КонецФункции

&НаСервере
Процедура УдалитьУстаревшиеКэшиРасширенийНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Справочники.ВерсииРасширений.УдалитьУстаревшиеВерсииПараметров();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширения(ВыделенныеСтроки)

	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("ВыделенныеСтроки", ВыделенныеСтроки);
	
	Оповещение = Новый ОписаниеОповещения("УдалитьРасширениеПослеПодтверждения", ЭтотОбъект, Контекст);
	Если ВыделенныеСтроки.Количество() > 1 Тогда
		ТекстВопроса = НСтр("ru = 'Вы уверены, что хотите удалить выделенные расширения?'; en = 'Are you sure you want to delete the selected extensions?'", "ru");
	Иначе
		ТекстВопроса = НСтр("ru = 'Вы уверены, что хотите удалить расширение?'; en = 'Are you sure you want to delete the extension?'", "ru");
	КонецЕсли;

	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширениеПослеПодтверждения(Результат, Контекст) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Запросы = ЗапросНаОтменуРазрешенийИспользованияВнешнегоМодуля(Контекст.ВыделенныеСтроки);
		
		РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы,
			ЭтотОбъект, Новый ОписаниеОповещения("УдалитьРасширениеПродолжение", ЭтотОбъект, Контекст));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширениеПродолжение(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ПоказатьДлительнуюОперацию();
		ТекущийКонтекст = Контекст;
		ПодключитьОбработчикОжидания("УдалитьРасширениеЗавершение", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширениеЗавершение()
	
	Контекст = ТекущийКонтекст;
	
	ПоказатьДлительнуюОперацию();
	Попытка
		УдалитьРасширенияНаСервере(Контекст.ВыделенныеСтроки);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СкрытьДлительнуюОперацию();
		ПоказатьПредупреждение(, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Возврат;
	КонецПопытки;
	СкрытьДлительнуюОперацию();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРасширенияНаСервере(ВыделенныеСтроки)
	
	ПроверитьДоступностьРазделенныхДанных();
	
	УдаленныеРасширения = Новый Массив;
	
	НачатьТранзакцию();
	Попытка
		Для Каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
			ТекущееРасширение = СписокРасширений.НайтиПоИдентификатору(ИдентификаторСтроки);
			Расширение = НайтиРасширение(ТекущееРасширение.ИдентификаторРасширения);
			Если Расширение <> Неопределено Тогда
				ОписаниеРасширения = Новый Структура;
				ОписаниеРасширения.Вставить("Расширение", Расширение);
				ОписаниеРасширения.Вставить("ДанныеРасширения", Расширение.ПолучитьДанные());
				УдаленныеРасширения.Добавить(ОписаниеРасширения);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ОписаниеРасширения Из УдаленныеРасширения Цикл
			ОписаниеРасширения.Расширение.Удалить();
		КонецЦикла;
		Если РасширенияКонфигурации.Получить().Количество() = 0 Тогда
			Справочники.ВерсииРасширений.ПриУдаленииВсехРасширений();
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ОтменитьТранзакцию();
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось удалить по причине:
			           |
			           |%1';
			           |en = 'Could not delete because:
			           |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	ТекстОшибки = "";
	Попытка
		ОбновитьПараметрыРаботыРасширений();
		РасширенияИзменены = Истина;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		НачатьТранзакцию();
		Попытка
			Для Каждого ОписаниеРасширения Из УдаленныеРасширения Цикл
				ОписаниеРасширения.Расширение.Записать(ОписаниеРасширения.ДанныеРасширения);
			КонецЦикла;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекущаяИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке) + Символы.ПС + Символы.ПС
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'При попытке восстановить удаленные расширения произошла еще одна ошибка:
					           |%1';
					           |en = 'In attempt to recover the deleted extensions another error occurred: 
					           |%1'"), КраткоеПредставлениеОшибки(ТекущаяИнформацияОбОшибке));
		КонецПопытки;
		Если Не ЗначениеЗаполнено(ТекстОшибки) Тогда
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке) + Символы.ПС + Символы.ПС
				+ НСтр("ru = 'Удаленные расширения были восстановлены.'; en = 'Deleted extensions have been recovered.'");
		КонецЕсли;
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'После удаления, при подготовке оставшихся расширений к работе, произошла ошибка:
			           |
			           |%1';
			           |en = 'After removal, while preparing the remaining extensions for work, an error occurred:
			           |
			           |%1'"), ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ОбновитьСписок();
	
КонецПроцедуры

&НаСервере
Функция ЗапросНаОтменуРазрешенийИспользованияВнешнегоМодуля(ВыделенныеСтроки)
	
	Разрешения = Новый Массив;
	
	Для Каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
		ТекущееРасширение = СписокРасширений.НайтиПоИдентификатору(ИдентификаторСтроки);
		Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеВнешнегоМодуля(
			ТекущееРасширение.Имя, ТекущееРасширение.КонтрольнаяСумма));
	КонецЦикла;
	
	Запросы = Новый Массив;
	Запросы.Добавить(РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов(
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.ПараметрыРаботыВерсийРасширений"),
		Разрешения));
		
	Возврат Запросы;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьДлительнуюОперацию()
	
	Элементы.СтраницыОбновление.ТекущаяСтраница = Элементы.СтраницаДлительнаяОперация;
	Элементы.СписокРасширенийДобавить.Доступность = Ложь;
	Элементы.СписокРасширенийУдалить.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьДлительнуюОперацию()
	
	Элементы.СтраницыОбновление.ТекущаяСтраница = Элементы.СтраницаСписокРасширений;
	Элементы.СписокРасширенийДобавить.Доступность = Истина;
	Элементы.СписокРасширенийУдалить.Доступность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасширение(Знач ИдентификаторРасширения, МножественныйВыбор = Ложь)
	
	Контекст = Новый Структура;
	Контекст.Вставить("ИдентификаторРасширения", ИдентификаторРасширения);
	Контекст.Вставить("МножественныйВыбор", МножественныйВыбор);
	
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(
		Новый ОписаниеОповещения("ЗагрузитьРасширениеПослеУстановкиРасширения", ЭтотОбъект, Контекст));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасширениеПослеУстановкиРасширения(РасширениеПодключено, Контекст) Экспорт
	
	Если РасширениеПодключено Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Диалог.Фильтр = НСтр("ru = 'Расширение конфигурации'; en = 'Configuration extension'", "ru")+ " (*.cfe)|*.cfe";
		Диалог.МножественныйВыбор = Контекст.МножественныйВыбор;
		Диалог.ПроверятьСуществованиеФайла = Истина;
		Диалог.Заголовок = НСтр("ru = 'Выберите файл расширения конфигурации'; en = 'Select the configuration extension file'", "ru");
		НачатьПомещениеФайлов(Новый ОписаниеОповещения(
				"ЗагрузитьРасширениеПослеПомещенияФайлов", ЭтотОбъект, Контекст),
			, Диалог, , УникальныйИдентификатор);
	Иначе
		РасширенияФайла = "*.cfe";
		НачатьПомещениеФайла(Новый ОписаниеОповещения(
				"ЗагрузитьРасширениеПослеПомещенияФайла", ЭтотОбъект, Контекст),
			, РасширенияФайла, , ЭтотОбъект.УникальныйИдентификатор);
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасширениеПослеПомещенияФайла(ФайлПомещен, Адрес, ВыбранноеИмяФайла, Контекст) Экспорт
	
	Если ФайлПомещен Тогда
		ПомещенныеФайлы = Новый Массив;
		ПомещенныеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ВыбранноеИмяФайла, Адрес));
		ЗагрузитьРасширениеПослеПомещенияФайлов(ПомещенныеФайлы, Контекст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасширениеПослеПомещенияФайлов(ПомещенныеФайлы, Контекст) Экспорт
	
	Если ПомещенныеФайлы = Неопределено
	 Или ПомещенныеФайлы.Количество() = 0 Тогда
		
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("ПомещенныеФайлы", ПомещенныеФайлы);
	
	ЗапросыРазрешений = Новый Массив;
	Попытка
		ДобавитьЗапросРазрешений(ЗапросыРазрешений, ПомещенныеФайлы, Контекст.ИдентификаторРасширения);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПоказатьПредупреждение(, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Возврат;
	КонецПопытки;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения(
		"ЗагрузитьРасширениеПродолжение", ЭтотОбъект, Контекст);
	
	РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
		ЗапросыРазрешений, ЭтотОбъект, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасширениеПродолжение(Результат, Контекст) Экспорт
	
	Если Результат <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьДлительнуюОперацию();
	ТекущийКонтекст = Контекст;
	ПодключитьОбработчикОжидания("ЗагрузитьРасширениеЗавершение", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасширениеЗавершение()
	
	Контекст = ТекущийКонтекст;
	
	НеподключенныеРасширения = "";
	Попытка
		ИзменитьРасширенияНаСервере(Контекст.ПомещенныеФайлы,
			Контекст.ИдентификаторРасширения, НеподключенныеРасширения);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СкрытьДлительнуюОперацию();
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'После добавления, при подготовке расширений к работе, произошла ошибка:
			           |%1';
			           |en = 'After adding, while preparing extensions for work, an error occurred: 
			           |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке)));
		Возврат;
	КонецПопытки;
	СкрытьДлительнуюОперацию();
	
	Если Не РасширенияИзменены Тогда
		Возврат;
	КонецЕсли;
	
	Если Контекст.ИдентификаторРасширения = Неопределено Тогда
		Если Контекст.ПомещенныеФайлы.Количество() > 1 Тогда
			ТекстОповещения = НСтр("ru = 'Расширения конфигурации добавлены'; en = 'Configuration extensions added'", "ru");
		Иначе
			ТекстОповещения = НСтр("ru = 'Расширение конфигурации добавлено'; en = 'Configuration extension added'", "ru");
		КонецЕсли;
	Иначе
		ТекстОповещения = НСтр("ru = 'Расширение конфигурации обновлено'; en = 'Configuration extension updated'", "ru");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НеподключенныеРасширения) Тогда
		Если Контекст.ПомещенныеФайлы.Количество() > 1 Тогда
			Если СтрНайти(НеподключенныеРасширения, ",") > 0 Тогда
				Пояснение = НСтр("ru = 'Некоторые расширения не подключаются:'; en = 'Some extensions could not be connected:'");
			Иначе
				Пояснение = НСтр("ru = 'Одно расширение не подключается:'; en = 'One extension is not connected:'");
			КонецЕсли;
			Пояснение = Пояснение + " " + НеподключенныеРасширения;
		Иначе
			Пояснение = НСтр("ru = 'Расширение не подключается.'; en = 'The extension does not connect.'");
		КонецЕсли;
	Иначе
		Пояснение = "";
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстОповещения, , Пояснение);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасширенияНаСервере(ПомещенныеФайлы, ИдентификаторРасширения, НеподключенныеРасширения)
	
	ПроверитьДоступностьРазделенныхДанных();
	
	РасширенияИзменены = Ложь;
	Расширение = Неопределено;
	
	Если ИдентификаторРасширения <> Неопределено Тогда
		Расширение = НайтиРасширение(ИдентификаторРасширения);
		Если Расширение = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ПрежнееИмяРасширения = Расширение.Имя;
		ДанныеРасширения = Расширение.ПолучитьДанные();
	КонецЕсли;
	
	ПроверяемыеРасширения = Новый Соответствие;
	ДобавленныеРасширения = Новый Массив;
	
	НачатьТранзакцию();
	Попытка
		Если ИдентификаторРасширения <> Неопределено Тогда
			Расширение.Записать(ПолучитьИзВременногоХранилища(ПомещенныеФайлы[0].Хранение));
			Если ПрежнееИмяРасширения <> Расширение.Имя Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Нельзя загрузить расширение ""%1"" в ""%2"".'; en = 'Unable to load extension ""%1"" into ""%2"".'"),
					Расширение.Имя,
					ПрежнееИмяРасширения);
			КонецЕсли;
			ПроверяемыеРасширения.Вставить(Расширение.Имя, Расширение.Синоним);
		Иначе
			Для Каждого ПомещенныйФайл Из ПомещенныеФайлы Цикл
				Расширение = РасширенияКонфигурации.Создать();
				Расширение.Записать(ПолучитьИзВременногоХранилища(ПомещенныйФайл.Хранение));
				ДобавленныеРасширения.Вставить(0, Расширение);
				ПроверяемыеРасширения.Вставить(Расширение.Имя, Расширение.Синоним);
			КонецЦикла;
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	ТекстОшибки = "";
	Попытка
		ОбновитьПараметрыРаботыРасширений(ПроверяемыеРасширения, НеподключенныеРасширения);
		РасширенияИзменены = Истина;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Если ИдентификаторРасширения <> Неопределено Тогда
			Расширение.Записать(ДанныеРасширения);
		Иначе
			НачатьТранзакцию();
			Попытка
				Для Каждого ДобавленноеРасширение Из ДобавленныеРасширения Цикл
					Отбор = Новый Структура("Имя", ДобавленноеРасширение.Имя);
					Расширения = РасширенияКонфигурации.Получить(Отбор);
					Для Каждого Расширение Из Расширения Цикл
						Если Расширение.ХешСумма = ДобавленноеРасширение.ХешСумма Тогда
							Расширение.Удалить();
						КонецЕсли;
					КонецЦикла;
				КонецЦикла;
				ЗафиксироватьТранзакцию();
			Исключение
				ТекущаяИнформацияОбОшибке = ИнформацияОбОшибке();
				ОтменитьТранзакцию();
				Если ИдентификаторРасширения <> Неопределено Тогда
					ВызватьИсключение КраткоеПредставлениеОшибки(ИнформацияОбОшибке) + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'При попытке восстановить измененное расширение произошла еще одна ошибка:
						           |%1';
						           |en = 'In attempt to recover the modified extension another error occurred: 
						           |%1'"), КраткоеПредставлениеОшибки(ТекущаяИнформацияОбОшибке));
				Иначе
					ВызватьИсключение КраткоеПредставлениеОшибки(ИнформацияОбОшибке) + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'При попытке удалить добавленные расширения произошла еще одна ошибка:
						           |%1';
						           |en = 'In attempt to delete the added extensions another error occurred: 
						           |%1'"), КраткоеПредставлениеОшибки(ТекущаяИнформацияОбОшибке));
				КонецЕсли;
			КонецПопытки;
		КонецЕсли;
		ВызватьИсключение КраткоеПредставлениеОшибки(ИнформацияОбОшибке) + Символы.ПС + Символы.ПС
			+ НСтр("ru = 'Добавленные расширения были удалены.'; en = 'Added extensions have been deleted.'");
	КонецПопытки;
	
	ОбновитьСписок(ИдентификаторРасширения = Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура СписокРасширенийПриОкончанииРедактированияНаСервере(ИдентификаторРасширения)
	
	СтрокаСписка = СписокРасширений.НайтиПоИдентификатору(ИдентификаторРасширения);
	
	Если СтрокаСписка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Расширение = НайтиРасширение(СтрокаСписка.ИдентификаторРасширения);
	
	Если Расширение <> Неопределено Тогда
	
		Если Расширение.БезопасныйРежим <> СтрокаСписка.БезопасныйРежимФлаг Тогда
			Расширение.БезопасныйРежим = СтрокаСписка.БезопасныйРежимФлаг;
			
			Попытка
				Расширение.Записать();
			Исключение
				СтрокаСписка.БезопасныйРежимФлаг = Не СтрокаСписка.БезопасныйРежимФлаг;
				ВызватьИсключение;
			КонецПопытки;
			
			СтрокаСписка.БезопасныйРежим = СтрокаСписка.БезопасныйРежимФлаг;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьЗапросРазрешений(ЗапросыРазрешений, ПомещенныеФайлы, ИдентификаторРасширения = Неопределено)
	
	Разрешения = Новый Массив;
	
	Для Каждого ПомещенныйФайл Из ПомещенныеФайлы Цикл
		НачатьТранзакцию();
		Попытка
			Если ИдентификаторРасширения = Неопределено Тогда
				ВременноеРасширение = РасширенияКонфигурации.Создать();
			Иначе
				ВременноеРасширение = НайтиРасширение(ИдентификаторРасширения);
				Если ВременноеРасширение = Неопределено Тогда
					ВызватьИсключение
						НСтр("ru = 'Текущее расширение не найдено в базе данных,
						           |возможно оно было удалено в другом сеансе.';
						           |en = 'The current extension is not found in the database,
						           |perhaps it was deleted in another session.'");
				КонецЕсли;
			КонецЕсли;
			ВременноеРасширение.Записать(ПолучитьИзВременногоХранилища(ПомещенныйФайл.Хранение));
			Если ИдентификаторРасширения = Неопределено Тогда
				ВременноеРасширение.Удалить();
			КонецЕсли;
			Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеВнешнегоМодуля(
				ВременноеРасширение.Имя, Base64Строка(ВременноеРасширение.ХешСумма)));
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
	
	УстановленныеРасширения = РасширенияКонфигурации.Получить();
	Для Каждого Расширение Из УстановленныеРасширения Цикл
		Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеВнешнегоМодуля(
			Расширение.Имя, Base64Строка(Расширение.ХешСумма)));
	КонецЦикла;
	
	ЗапросыРазрешений.Добавить(РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения,
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.ПараметрыРаботыВерсийРасширений")));
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьПараметрыРаботыРасширений(ПроверяемыеРасширения = Неопределено, НеподключенныеРасширения = "")
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ИмяКонфигурации",         Метаданные.Имя);
	ПараметрыВыполнения.Вставить("ВерсияКонфигурации",      Метаданные.Версия);
	ПараметрыВыполнения.Вставить("УстановленныеРасширения", Справочники.ВерсииРасширений.КонтрольныеСуммыРасширений());
	ПараметрыВыполнения.Вставить("ПроверяемыеРасширения",   ПроверяемыеРасширения);
	ПараметрыВыполнения.Вставить("АдресРезультата",         ПоместитьВоВременноеХранилище(, УникальныйИдентификатор));
	ПараметрыПроцедуры = Новый Массив;
	ПараметрыПроцедуры.Добавить(ПараметрыВыполнения);
	
	Попытка
		ФоновоеЗадание = РасширенияКонфигурации.ВыполнитьФоновоеЗаданиеСРасширениямиБазыДанных(
			"СтандартныеПодсистемыСервер.ЗаполнитьВсеПараметрыРаботыРасширенийФоновоеЗадание", ПараметрыПроцедуры);
		Попытка
			ФоновоеЗадание.ОжидатьЗавершения();
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
		Отбор = Новый Структура("УникальныйИдентификатор", ФоновоеЗадание.УникальныйИдентификатор);
		ФоновоеЗадание = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор)[0];
		Если ИнформацияОбОшибке <> Неопределено Тогда
			ИнформацияОбОшибке = ФоновоеЗадание.ИнформацияОбОшибке;
		КонецЕсли;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;
	
	Если ИнформацияОбОшибке <> Неопределено Тогда
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецЕсли;
	
	Результат = ПолучитьИзВременногоХранилища(ПараметрыВыполнения.АдресРезультата);
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		ВызватьИсключение НСтр("ru = 'Фоновое задание подготовки расширений не вернуло результат.'; en = 'Background job training extensions has not returned a result.'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ВызватьИсключение Результат.ТекстОшибки;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.НеподключенныеРасширения) Тогда
		НеподключенныеРасширения = Результат.НеподключенныеРасширения;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДоступностьРазделенныхДанных()
	
	Если Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		ВызватьИсключение НСтр("ru = 'Расширения недоступны в неразделенном режиме.'; en = 'Extensions are not available in unseparated mode.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
