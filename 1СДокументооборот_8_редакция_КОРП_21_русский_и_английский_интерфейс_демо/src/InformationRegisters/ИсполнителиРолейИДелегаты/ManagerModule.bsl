#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обновляет записи регистра по Пользователю.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - пользователь для которого добавляется
//                 запись в регистр.
//
Процедура ОбновитьЗаписиПоПользователю(Пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Пользователь)) Тогда
		СсылкаНаПользователя = Пользователь;
		ЭтоСлужебныйПользователь = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "Служебный");
	Иначе
		СсылкаНаПользователя = Пользователь.Ссылка;
		ЭтоСлужебныйПользователь = Пользователь.Служебный;
	КонецЕсли;
	
	Если ЭтоСлужебныйПользователь Тогда
		Возврат;
	КонецЕсли;
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.РольПользователь = СсылкаНаПользователя;
	Запись.ИсполнительДелегат = СсылкаНаПользователя;
	
	ЗаполнитьУстаревшиеИзмерения(Запись);
	
	Запись.Записать();
	
КонецПроцедуры

// Обновляет записи регистра по настройке делегирования.
// При этом учитываются роли делегирующего. Т.е. если у делегирующего
// имеются роли, то они дублируются для делегата с заполнением измерения НастройкаДелегирования.
//
// Параметры:
//  НастройкаДелегирования - СправочникОбъект.ДелегированиеПрав,
//                           СправочникСсылка.ДелегированиеПрав -  настройка делегирования.
//
Процедура ОбновитьЗаписиПоНастройкеДелегирования(НастройкаДелегирования) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(НастройкаДелегирования)) Тогда
		РеквизитыНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			НастройкаДелегирования,
			"Ссылка, ОтКого, Кому, Действует, ВариантДелегирования, ОбластиДелегирования");
			
		РеквизитыНастройки.ОбластиДелегирования = РеквизитыНастройки.ОбластиДелегирования.Выгрузить();
	Иначе
		РеквизитыНастройки = НастройкаДелегирования;
	КонецЕсли;
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.НастройкаДелегирования.Установить(РеквизитыНастройки.Ссылка);
	
	Если РеквизитыНастройки.Действует Тогда
		
		// Получим имена делегированных областей.
		ИменаДелегированныхОбластей = Новый Массив;
		Если РеквизитыНастройки.ВариантДелегирования = Перечисления.ВариантыДелегированияПрав.ВсеПрава Тогда
			ИменаДелегированныхОбластей.Добавить("");
		Иначе
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ОбластиДелегированияПрав.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
				|ИЗ
				|	Справочник.ОбластиДелегированияПрав КАК ОбластиДелегированияПрав
				|ГДЕ
				|	ОбластиДелегированияПрав.Ссылка В(&ОбластиДелегирования)
				|	И ОбластиДелегированияПрав.ИмяПредопределенныхДанных <> """"";
				
			Запрос.УстановитьПараметр("ОбластиДелегирования", 
				РеквизитыНастройки.ОбластиДелегирования.ВыгрузитьКолонку("ОбластьДелегирования"));
				
			ИменаДелегированныхОбластей = 
				Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяПредопределенныхДанных");
		КонецЕсли;
		
		// Определим делегируемые роли
		ДелегируемыеРоли = 
			РегистрыСведений.ИсполнителиЗадач.РолиИсполнителя(РеквизитыНастройки.ОтКого);
			
		Для Каждого ИмяОбластиДелегирования Из ИменаДелегированныхОбластей Цикл
			
			// Добавляем делегата.
			Запись = Набор.Добавить();
			
			Запись.НастройкаДелегирования = РеквизитыНастройки.Ссылка;
			Запись.РольПользователь = РеквизитыНастройки.ОтКого;
			Запись.ИсполнительДелегат = РеквизитыНастройки.Кому;
			Запись.ИмяОбластиДелегирования = ИмяОбластиДелегирования;
			
			ЗаполнитьУстаревшиеИзмерения(Запись);
			
			// Добавляем делегированные роли.
			Для Каждого ДелегируемаяРоль Из ДелегируемыеРоли Цикл
				
				Запись = Набор.Добавить();
				
				Запись.РольПользователь = ДелегируемаяРоль;
				Запись.ИсполнительДелегат = РеквизитыНастройки.Кому;
				Запись.НастройкаДелегирования = РеквизитыНастройки.Ссылка;
				Запись.ИмяОбластиДелегирования = ИмяОбластиДелегирования;
				
				ЗаполнитьУстаревшиеИзмерения(Запись);
				
			КонецЦикла;
			
		КонецЦикла;
		
	Иначе
		// Если настройка делегирования не действует, то удаляем все записи по настройке.
	КонецЕсли;
	
	Набор.Записать();
	
КонецПроцедуры

// Обновляет записи регистра по исполнителю роли.
// При этом учитывается делегирование прав от текущего исполнителя - если от исполнителя
// делегированы полномочия, то текущая роль обновляется и в записях регистра по этим делегированиям.
//
// Параметры:
//  Исполнитель - СправочникСсылка.Пользователи - исполнитель роли.
//  РольИсполнителя - СправочникСсылка.РолиИсполнителей - роль.
//  ОсновнойОбъектАдресации - Характеристика.ОбъектыАдресацииЗадач - объект адресации роли.
//  ДополнительныйОбъектАдресации - Характеристика.ОбъектыАдресацииЗадач - объект адресации роли.
//
Процедура ОбновитьЗаписиПоИсполнителюРоли(
		Исполнитель, РольИсполнителя) Экспорт
		
	УстановитьПривилегированныйРежим(Истина);
	
	// Определим наличие записей для текущего исполнителя роли
	// в регистр ИсполнителиЗадач.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИсполнителиЗадач.Исполнитель,
		|	ИсполнителиЗадач.РольИсполнителя
		|ИЗ
		|	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
		|ГДЕ
		|	ИсполнителиЗадач.Исполнитель = &Исполнитель
		|	И ИсполнителиЗадач.РольИсполнителя = &РольИсполнителя
		|";
		
	Запрос.УстановитьПараметр("Исполнитель", Исполнитель);
	Запрос.УстановитьПараметр("РольИсполнителя", РольИсполнителя);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.ИсполнительДелегат.Установить(Исполнитель);
	Набор.Отбор.РольПользователь.Установить(РольИсполнителя);
	Набор.Отбор.НастройкаДелегирования.Установить(Справочники.ДелегированиеПрав.ПустаяСсылка());
	
	УдалениеИсполнителя = РезультатЗапроса.Пустой();
	
	Если УдалениеИсполнителя Тогда
		// Если записей нет, то удаляем все записи соответствующие
		// текущему исполнителю роли.
	Иначе
		// Если записи есть, то формируем новую запись в регистре для
		// текущего исполнителя.
		Запись = Набор.Добавить();
		
		Запись.РольПользователь = РольИсполнителя;
		Запись.ИсполнительДелегат = Исполнитель;
		
		ЗаполнитьУстаревшиеИзмерения(Запись);
		
	КонецЕсли;
	
	Набор.Записать();
	
	// Определим настройки делегирования исполнителя роли.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДелегированиеПрав.Ссылка КАК Ссылка,
		|	ДелегированиеПрав.Кому,
		|	ЕСТЬNULL(ОбластиДелегированияПрав.ИмяПредопределенныхДанных, """") КАК ИмяОбластиДелегирования
		|ИЗ
		|	Справочник.ДелегированиеПрав КАК ДелегированиеПрав
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДелегированиеПрав.ОбластиДелегирования КАК ДелегированиеПравОбластиДелегирования
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбластиДелегированияПрав КАК ОбластиДелегированияПрав
		|			ПО ДелегированиеПравОбластиДелегирования.ОбластьДелегирования = ОбластиДелегированияПрав.Ссылка
		|		ПО (ДелегированиеПравОбластиДелегирования.Ссылка = ДелегированиеПрав.Ссылка)
		|ГДЕ
		|	ДелегированиеПрав.ОтКого = &ОтКого
		|	И ДелегированиеПрав.Действует = ИСТИНА
		|ИТОГИ ПО
		|	Ссылка";
		
	Запрос.УстановитьПараметр("ОтКого", Исполнитель);
	ВыборкаПоНастройкамДелегирования = 
		Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоНастройкамДелегирования.Следующий() Цикл
		
		Набор = СоздатьНаборЗаписей();
		Набор.Отбор.РольПользователь.Установить(РольИсполнителя);
		Набор.Отбор.НастройкаДелегирования.Установить(ВыборкаПоНастройкамДелегирования.Ссылка);
		
		Если УдалениеИсполнителя Тогда
			// Удаляем записи с ролью исполнителя по настройкам делегирования.
			
		Иначе
			// Добавляем запись по настройке делегирования для текущей роли.
			ВыборкаПоОбластямДелегирования = ВыборкаПоНастройкамДелегирования.Выбрать();
			
			ПропуститьОбластьБезИмени = Ложь;
			Если ВыборкаПоОбластямДелегирования.Количество() > 1 Тогда
				ПропуститьОбластьБезИмени = Истина;
			КонецЕсли;
			
			Пока ВыборкаПоОбластямДелегирования.Следующий() Цикл
				
				Если ПропуститьОбластьБезИмени
					И ВыборкаПоОбластямДелегирования.ИмяОбластиДелегирования = "" Тогда
					
					Продолжить;
				КонецЕсли;
					
				Запись = Набор.Добавить();
				
				Запись.РольПользователь = РольИсполнителя;
				Запись.ИсполнительДелегат = ВыборкаПоОбластямДелегирования.Кому;
				Запись.НастройкаДелегирования = ВыборкаПоНастройкамДелегирования.Ссылка;
				Запись.ИмяОбластиДелегирования = ВыборкаПоОбластямДелегирования.ИмяОбластиДелегирования;
				
				ЗаполнитьУстаревшиеИзмерения(Запись);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Набор.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает признак делегата для исполнителя роли или полномочий пользователя.
//
// Параметры:
//  РольПользователь - СправочникСсылка.Пользователи, СправочникСсылка.ПолныеРоли - 
//                     роль или пользователь, чьи полномочия выполняет исполнитель.
//  Исполнитель - СправочникСсылка.Пользователи - Исполнитель.
//  ИмяОбластиДелегирования - Строка - имя предопределенного элемента справочника ОбластиДелегированияПрав
//
// Возвращаемое значение:
//  Булево - возвращается Истина если исполнитель выполняет роль или полномочия пользователя по делегированию.
//           Иначе возвращается ложь.
//
Функция ИсполнительЯвляетсяДелегатом(
	РольПользователь, Исполнитель, ИмяОбластиДелегирования) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		// Определяем признак делегирования для текущей задачи по ее исполнителю.
		// Если в регистре ИсполнителиРолейИДелегаты есть записи без настройки делегирования
		// для текущего пользователя и исполнителя задачи, то считается, что задача не делегирована.
		// Если есть записи только с настройками делегирования, тогда задача делегирована пользователю.
		// Если записей в регистре нет, то не определяем и не выводим признак делегированной задачи.
		"ВЫБРАТЬ
		|	ЕСТЬNULL(МИНИМУМ(ИсполнителиРолейИДелегаты.НастройкаДелегирования <> ЗНАЧЕНИЕ(Справочник.ДелегированиеПрав.ПустаяСсылка)), ЛОЖЬ) КАК ЭтоДелегат
		|ИЗ
		|	РегистрСведений.ИсполнителиРолейИДелегаты КАК ИсполнителиРолейИДелегаты
		|ГДЕ
		|	ИсполнителиРолейИДелегаты.ИсполнительДелегат = &ТекущийПользователь
		|	И ИсполнителиРолейИДелегаты.РольПользователь = &Исполнитель
		|	И ИсполнителиРолейИДелегаты.ИмяОбластиДелегирования В ("""", &ИмяОбластиДелегирования)";
		
	Запрос.УстановитьПараметр("ТекущийПользователь", Исполнитель);
	Запрос.УстановитьПараметр("Исполнитель", РольПользователь);
	Запрос.УстановитьПараметр("ИмяОбластиДелегирования", ИмяОбластиДелегирования);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ЭтоДелегат;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет устаревшие измерения записи регистра.
//
Процедура ЗаполнитьУстаревшиеИзмерения(Запись)
	
	Если ТипЗнч(Запись.РольПользователь) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Запись.УдалитьРольПользователь = Запись.РольПользователь;
		Запись.УдалитьОсновнойОбъектАдресации = Неопределено;
		Запись.УдалитьДополнительныйОбъектАдресации = Неопределено;
		
	Иначе
		
		РеквизитыРоли = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.РольПользователь,
			"Владелец, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации");
		Запись.УдалитьРольПользователь = РеквизитыРоли.Владелец;
		Запись.УдалитьОсновнойОбъектАдресации = РеквизитыРоли.ОсновнойОбъектАдресации;
		Запись.УдалитьДополнительныйОбъектАдресации = РеквизитыРоли.ДополнительныйОбъектАдресации;
		
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
