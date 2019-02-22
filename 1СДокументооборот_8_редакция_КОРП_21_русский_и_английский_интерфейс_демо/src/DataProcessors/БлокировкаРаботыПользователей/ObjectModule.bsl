#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Установить или снять блокировку информационной базы,
// исходя из значений реквизитов обработки.
//
Процедура ВыполнитьУстановку() Экспорт
	
	ВыполнитьУстановкуБлокировки(ВременноЗапретитьРаботуПользователей);
	
КонецПроцедуры

// Отменить ранее установленную блокировку сеансов.
//
Процедура ОтменитьБлокировку() Экспорт
	
	ВыполнитьУстановкуБлокировки(Ложь);
	
КонецПроцедуры

// Зачитать параметры блокировки информационной базы 
// в реквизиты обработки.
//
Процедура ПолучитьПараметрыБлокировки() Экспорт
	
	Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ТекущийРежим = ПолучитьБлокировкуСеансов();
		КодДляРазблокировки = ТекущийРежим.КодРазрешения;
	Иначе	
		ТекущийРежим = СоединенияИБ.ПолучитьБлокировкуСеансовОбластиДанных();
	КонецЕсли;
	
	ВременноЗапретитьРаботуПользователей = ТекущийРежим.Установлена;
	СообщениеДляПользователей = СоединенияИБКлиентСервер.ИзвлечьСообщениеБлокировки(ТекущийРежим.Сообщение);
	
	Если ВременноЗапретитьРаботуПользователей Тогда
		НачалоДействияБлокировки    = ТекущийРежим.Начало;
		ОкончаниеДействияБлокировки = ТекущийРежим.Конец;
	Иначе	
		// Если блокировка не установлена, можно предположить, что
		// пользователь открыл форму для установки блокировки.
		// Поэтому устанавливаем дату блокировки равной текущей дате.
		НачалоДействияБлокировки     = НачалоМинуты(ТекущаяДатаСеанса() + 5 * 60);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьУстановкуБлокировки(Значение)
	
	УстановленаБлокировкаСоединений = СоединенияИБ.УстановленаБлокировкаСоединений();
	Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		Блокировка = Новый БлокировкаСеансов;
		Блокировка.КодРазрешения    = КодДляРазблокировки;
	Иначе
		Блокировка = СоединенияИБ.НовыеПараметрыБлокировкиСоединений();
	КонецЕсли;
	
	Блокировка.Начало           = НачалоДействияБлокировки;
	Блокировка.Конец            = ОкончаниеДействияБлокировки;
	Блокировка.Сообщение        = СоединенияИБ.СформироватьСообщениеБлокировки(СообщениеДляПользователей, 
		КодДляРазблокировки); 
	Блокировка.Установлена      = Значение;
	
	Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		УстановитьБлокировкуСеансов(Блокировка);
	Иначе
		СоединенияИБ.УстановитьБлокировкуСеансовОбластиДанных(Блокировка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
