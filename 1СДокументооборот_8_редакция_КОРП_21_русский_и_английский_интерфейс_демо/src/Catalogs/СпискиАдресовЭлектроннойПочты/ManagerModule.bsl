
// добавляет адрес в список адресов
Функция ДобавитьВСписок(Элемент, Адрес) Экспорт
	
	ЗаблокироватьДанныеДляРедактирования(Элемент);
	ГруппаДляДобавленияОбъект = Элемент.ПолучитьОбъект();
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Адрес", Адрес);
	НайденныеСтроки = ГруппаДляДобавленияОбъект.Адреса.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтроки.Количество() <> 0 Тогда  // уже есть такой адрес
		РазблокироватьДанныеДляРедактирования(Элемент);
		Возврат Ложь;
	КонецЕсли;	
	
	НоваяСтрока = ГруппаДляДобавленияОбъект.Адреса.Добавить();
	НоваяСтрока.Адрес = Адрес;
	
	Если Лев(Адрес, 1) <> "@" Тогда
		Представление = "";
		Адресат = ВстроеннаяПочтаСерверПовтИсп.ПолучитьПочтовогоАдресата(
			НоваяСтрока.Адрес, Представление);	
			
		СведенияОбАдресате = ВстроеннаяПочтаСервер.ПолучитьПредставлениеИКонтактАдресата(Адресат);
		НоваяСтрока.Представление = СведенияОбАдресате.Представление;
	КонецЕсли;	
	
	ГруппаДляДобавленияОбъект.Адреса.Сортировать("Адрес Возр");
	
	Попытка
		ГруппаДляДобавленияОбъект.Записать();	
	Исключение
		РазблокироватьДанныеДляРедактирования(Элемент);
		ВызватьИсключение;
	КонецПопытки;	
	
	РазблокироватьДанныеДляРедактирования(Элемент);
	Возврат Истина;
	
КонецФункции

// создает 2 списка - черный и белый список - пустыми
Процедура СоздатьСпискиПоУмолчанию(УчетнаяЗапись) Экспорт
	
	ИмяБелогоСписка = НСтр("ru='Белый список'; en = 'White list'");
	ИмяЧерногоСписка = НСтр("ru='Черный список'; en = 'Black list'");
	
	Если Не ЕстьСписок(УчетнаяЗапись, ИмяБелогоСписка) Тогда
		Элемент = Справочники.СпискиАдресовЭлектроннойПочты.СоздатьЭлемент();
		Элемент.Наименование = ИмяБелогоСписка;
		Элемент.УчетнаяЗапись = УчетнаяЗапись;
		Элемент.Записать();
	КонецЕсли;	
	
	Если Не ЕстьСписок(УчетнаяЗапись, ИмяЧерногоСписка) Тогда
		Элемент = Справочники.СпискиАдресовЭлектроннойПочты.СоздатьЭлемент();
		Элемент.Наименование = ИмяЧерногоСписка;
		Элемент.УчетнаяЗапись = УчетнаяЗапись;
		Элемент.Записать();
	КонецЕсли;	
	
КонецПроцедуры	

Функция ЕстьСписок(УчетнаяЗапись, Наименование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СпискиАдресовЭлектроннойПочты.Ссылка
		|ИЗ
		|	Справочник.СпискиАдресовЭлектроннойПочты КАК СпискиАдресовЭлектроннойПочты
		|ГДЕ
		|	СпискиАдресовЭлектроннойПочты.Наименование = &Наименование
		|	И СпискиАдресовЭлектроннойПочты.УчетнаяЗапись = &УчетнаяЗапись";
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции


