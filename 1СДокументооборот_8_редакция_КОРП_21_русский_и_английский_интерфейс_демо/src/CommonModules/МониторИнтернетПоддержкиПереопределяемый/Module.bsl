
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Монитор Интернет-поддержки".
// ОбщийМодуль.МониторИнтернетПоддержкиПереопределяемый.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет разрешение использовать монитор Интернет-поддержки.
// Если необходимо запретить использование монитора Интернет-поддержки,
// тогда в параметре Отказ необходимо возвратить значение Истина;
//
// Параметры:
//	Отказ - Булево - Истина, если показ монитора Интернет-поддержки запрещен;
//		Ложь - в противном случае;
//		Значение по умолчанию - Ложь;
//
// Пример:
//	Если <Выражение> Тогда
//		Отказ = Истина;
//	КонецЕсли;
//
Процедура ИспользоватьМониторИнтернетПоддержки(Отказ) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет возможность использования функции отображения монитора
// Интернет-поддержки при начале работы с программой. Если отображение
// монитора при начале работы с программой используется, тогда:
// 1) монитор Интернет-поддержки будет открываться при начале работы программы;
// 2) в мониторе Интернет-поддержки будет также отображена настройка "Показывать
//    при начале работы", посредством которой пользователь может включить или
//    отключить отображение монитора при начале работы с программой.
//
// Параметры:
// Использование - Булево - Истина, если необходимо использовать функцию
//		отображения монитора Интернет-поддержки при начале работы с программой.
//		Ложь - в противном случае.
//		Значение по умолчанию - Ложь.
//
Процедура ИспользоватьОтображениеМонитораПриНачалеРаботы(Использование) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
