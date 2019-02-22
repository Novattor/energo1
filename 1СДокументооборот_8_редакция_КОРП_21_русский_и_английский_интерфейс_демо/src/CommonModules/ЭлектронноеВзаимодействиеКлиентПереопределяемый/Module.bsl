////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеКлиентПереопределяемый: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет сообщение о нехватке прав доступа.
//
// Параметры:
//  ТекстСообщения - Строка - текст сообщения.
//
Процедура ПодготовитьТекстСообщенияОНарушенииПравДоступа(ТекстСообщения) Экспорт
	
	// При необходимости можно переопределить или дополнить текст сообщения
	
КонецПроцедуры

// Выполняет интерактивное проведение документов перед формированием ЭД.
// Если есть непроведенные документы, предлагает выполнить проведение. Спрашивает
// пользователя о продолжении, если какие-то из документов не провелись и имеются проведенные.
//
// Параметры:
//  ДокументыМассив - Массив - Ссылки на документы, которые требуется провести перед печатью.
//                             После выполнения функции из массива исключаются непроведенные документы.
//  ОбработкаПродолжения - ОписаниеОповещения - содержит описание процедуры,
//                         которая будет вызвана после завершения проверки документов.
//  ФормаИсточник - УправляемаяФорма - форма, из которой была вызвана команда.
//
Процедура ВыполнитьПроверкуПроведенияДокументов(ДокументыМассив, ОбработкаПродолжения, ФормаИсточник = Неопределено) Экспорт
	
	
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти
