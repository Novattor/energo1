//////////////////////////////////////////////////////////////////////////////// 
// ПРОЦЕДУРЫ И ФУНКЦИИ 
//
// Модуль содержит процедуры и функции, предназначенные для работы с торговым оборудованием

// Подключение к сканеру штрихкодов
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Булево - истина, если подключение прошло успешно, ложь в противном случае.
Функция ПодключитьСканерШтрихкодов(ИмяСобытия) Экспорт
	
	Если ДрайверСканераШтрихкодов = Неопределено Тогда
		
		// Загрузка внешней компоненты
		Если НЕ ПодключитьВнешнююКомпоненту("ОбщийМакет.ДрайверСканераШтрихкодов", "Сканер") Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ДрайверСканераШтрихкодов = Новый ("AddIn.Сканер.BarcodeReader");
		ДрайверСканераШтрихкодов.Отсоединить();
		
	КонецЕсли;

	ИнформацияОСистеме = Новый СистемнаяИнформация;
	
	Если ИнформацияОСистеме.ТипПлатформы = ТипПлатформы.Windows_x86 ИЛИ ИнформацияОСистеме.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		
		ТипОС = "Windows";
		
	ИначеЕсли ИнформацияОСистеме.ТипПлатформы = ТипПлатформы.Linux_x86 ИЛИ ИнформацияОСистеме.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		
		ТипОС = "Linux";
		
	КонецЕсли;
	
	ПараметрыСканера = ШтрихкодированиеСервер.ЗагрузитьПараметрыПодключенияСканера(ТипОС);
	Если ПараметрыСканера = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;

		
	ДрайверСканераШтрихкодов.БитДанных  = ПараметрыСканера.БитДанных;
	ДрайверСканераШтрихкодов.Порт       = ПараметрыСканера.Порт;
	ДрайверСканераШтрихкодов.Скорость   = ПараметрыСканера.Скорость;
	ДрайверСканераШтрихкодов.ИмяСобытия = ИмяСобытия;
	
	Попытка
		ДрайверСканераШтрихкодов.Занять();
	Исключение
		Возврат Ложь;
	КонецПопытки;
		
	Возврат Истина;

КонецФункции

// Отключение от сканера штрихкодов
// 
// Параметры: 
//  Нет
// 
// Возвращаемое значение: 
//  Нет
Процедура ОтключитьСканерШтрихкодов() Экспорт

	Если ДрайверСканераШтрихкодов <> Неопределено Тогда

		ДрайверСканераШтрихкодов.Отсоединить();

	КонецЕсли

КонецПроцедуры



