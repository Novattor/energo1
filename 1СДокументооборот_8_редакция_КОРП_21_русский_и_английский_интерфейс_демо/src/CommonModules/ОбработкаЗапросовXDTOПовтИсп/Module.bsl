////////////////////////////////////////////////////////////////////////////////
// Обработка запросов XDTO, повторно используемые значения
// Предоставляет веб-сервису DMService часто используемые данные
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс
	
// Возвращает узел интегрированной системы по идентификатору
//
// Параметры:
//   ИдентификаторУзла - Строка - идентификатор узла ИС
//
// Возвращаемое значение:
//   ПланОбменаСсылка.ИнтегрированныеСистемы - ссылка на найденный узел
//
Функция УзелИнтегрированнойСистемы(ИдентификаторУзла) Экспорт
	
	Если ИдентификаторУзла = "" Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЭтотУзел = ПланыОбмена.ИнтегрированныеСистемы.ЭтотУзел();
	ИмяЭтогоУзла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотУзел, "Наименование");
	ИмяПоУмолчанию = НСтр("ru='1С:Документооборот'; en = '1C:Document management'");
	
	Если Не ЗначениеЗаполнено(ИмяЭтогоУзла) Тогда
		ЭтотУзелОбъект = ЭтотУзел.ПолучитьОбъект();
		ЭтотУзелОбъект.Наименование = ИмяПоУмолчанию;
		ЭтотУзелОбъект.УстановитьНовыйКод();
		ЭтотУзелОбъект.Записать();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИнтегрированныеСистемы.Ссылка
		|ИЗ
		|	ПланОбмена.ИнтегрированныеСистемы КАК ИнтегрированныеСистемы
		|ГДЕ
		|	ИнтегрированныеСистемы.Идентификатор = &ИдентификаторУзла";
	Запрос.УстановитьПараметр("ИдентификаторУзла", ИдентификаторУзла);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		УзелОбъект = ПланыОбмена.ИнтегрированныеСистемы.СоздатьУзел();
		УзелОбъект.УстановитьНовыйКод();
		УзелОбъект.Наименование = ИдентификаторУзла;
		УзелОбъект.Идентификатор = ИдентификаторУзла;
		УзелОбъект.Записать();
		УзелСсылка = УзелОбъект.Ссылка;
	Иначе
		УзелСсылка = Результат.Выгрузить()[0].Ссылка;
	КонецЕсли;
	
	Возврат УзелСсылка;
	
КонецФункции

// Возвращает узлы интегрированных систем для регистрации данных
//
// Возвращаемое значение:
//   Массив - содержит элементы типа
//     * ПланОбменаСсылка.ИнтегрированныеСистемы
//
Функция ПолучитьУзлыОбменаИнтегрированныхСистем() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИнтегрированныеСистемы.Ссылка
		|ИЗ
		|	ПланОбмена.ИнтегрированныеСистемы КАК ИнтегрированныеСистемы
		|ГДЕ
		|	НЕ ИнтегрированныеСистемы.ПометкаУдаления
		|	И ИнтегрированныеСистемы.Ссылка <> &ЭтотУзел";
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.ИнтегрированныеСистемы.ЭтотУзел());
		
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Узлы = Новый Массив;
	Иначе
		Узлы = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
	Возврат Узлы;
	
КонецФункции

// Формирует таблицу соответствия типов XDTO и типов объектов информационной базы
//
// Возвращаемое значение:
//   ТаблицаЗначений - таблица с колонками:
//     * ИмяXDTO - Строка - имя типа XDTO
//     * ИмяДО - Строка - полное имя типа ДО
// 
Функция СоответствиеТипов() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("ИмяXDTO", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("ИмяДО", 	Новый ОписаниеТипов("Строка"));
	
	// Поддерживаемые справочники.
	ДобавитьСтроку(Таблица, "DMInternalDocument",	 		"Справочник.ВнутренниеДокументы");
	ДобавитьСтроку(Таблица, "DMIncomingDocument",	 		"Справочник.ВходящиеДокументы");
	ДобавитьСтроку(Таблица, "DMOutgoingDocument",	 		"Справочник.ИсходящиеДокументы");
	
	ДобавитьСтроку(Таблица, "DMInternalDocumentTemplate", 	"Справочник.ШаблоныВнутреннихДокументов");
	ДобавитьСтроку(Таблица, "DMIncomingDocumentTemplate", 	"Справочник.ШаблоныВходящихДокументов");
	ДобавитьСтроку(Таблица, "DMOutgoingDocumentTemplate",	"Справочник.ШаблоныИсходящихДокументов");
	
	ДобавитьСтроку(Таблица, "DMInternalDocumentType", 		"Справочник.ВидыВнутреннихДокументов");
	ДобавитьСтроку(Таблица, "DMIncomingDocumentType", 		"Справочник.ВидыВходящихДокументов");
	ДобавитьСтроку(Таблица, "DMOutgoingDocumentType",		"Справочник.ВидыИсходящихДокументов");
	
	ДобавитьСтроку(Таблица, "DMProject",				"Справочник.Проекты");
	ДобавитьСтроку(Таблица, "DMProjectTask",			"Справочник.ПроектныеЗадачи");
	
	ДобавитьСтроку(Таблица, "DMFile", 					"Справочник.Файлы");
	ДобавитьСтроку(Таблица, "DMFileVersion",			"Справочник.ВерсииФайлов");
	ДобавитьСтроку(Таблица, "DMFileFolder", 			"Справочник.ПапкиФайлов");
	
	ДобавитьСтроку(Таблица, "DMUser", 					"Справочник.Пользователи");
	ДобавитьСтроку(Таблица, "DMUserGroup",  			"Справочник.РабочиеГруппы");
	
	ДобавитьСтроку(Таблица, "DMActivityMatter", 		"Справочник.ВопросыДеятельности");
	ДобавитьСтроку(Таблица, "DMCurrency",				"Справочник.Валюты");
	ДобавитьСтроку(Таблица, "DMOrganization",   		"Справочник.Организации");
	ДобавитьСтроку(Таблица, "DMCorrespondent",  		"Справочник.Контрагенты");
	ДобавитьСтроку(Таблица, "DMContactPerson",  		"Справочник.КонтактныеЛица");
	ДобавитьСтроку(Таблица, "DMAccessLevel", 			"Справочник.ГрифыДоступа");
	ДобавитьСтроку(Таблица, "DMDeliveryMethod", 		"Справочник.СпособыДоставки");
	ДобавитьСтроку(Таблица, "DMSubdivision", 			"Справочник.СтруктураПредприятия");
	ДобавитьСтроку(Таблица, "DMInternalDocumentFolder", "Справочник.ПапкиВнутреннихДокументов");
	ДобавитьСтроку(Таблица, "DMRelationType", 			"Справочник.ТипыСвязей");
	ДобавитьСтроку(Таблица, "DMObjectPropertyValue", 	"Справочник.ЗначенияСвойствОбъектов");
	ДобавитьСтроку(Таблица, "DMObjectPropertyValueHierarchy", 
														"Справочник.ЗначенияСвойствОбъектовИерархия");
	ДобавитьСтроку(Таблица, "DMPrivatePerson", 			"Справочник.ФизическиеЛица");
	ДобавитьСтроку(Таблица, "DMRoutingCondition", 		"Справочник.УсловияМаршрутизации");
	ДобавитьСтроку(Таблица, "DMPersonalRecipient", 		"Справочник.ЛичныеАдресаты");
	ДобавитьСтроку(Таблица, "DMPersonalRecipientGroup", "Справочник.ГруппыЛичныхАдресатов");
	ДобавитьСтроку(Таблица, "DMBusinessProcessExecutorRole", "Справочник.РолиИсполнителей");
	ДобавитьСтроку(Таблица, "DMContactInformationKind", "Справочник.ВидыКонтактнойИнформации");
	ДобавитьСтроку(Таблица, "DMBusinessProcessTargetRole", 
														"Перечисление.РолиПредметов");
	ДобавитьСтроку(Таблица, "DMResolution",				"Справочник.Резолюции");
	ДобавитьСтроку(Таблица, "DMVisa",					"Справочник.ВизыСогласования");
	ДобавитьСтроку(Таблица, "DMApplicationNotification", "Справочник.УведомленияПрограммы");
	ДобавитьСтроку(Таблица, "DMMeasurementUnit", "Справочник.КлассификаторЕдиницИзмерения");
	ДобавитьСтроку(Таблица, "DMProduct", "Справочник.Номенклатура");
	
	// Письма электронной почты.
	ДобавитьСтроку(Таблица, "DMIncomingEMail",  		"Документ.ВходящееПисьмо");
	ДобавитьСтроку(Таблица, "DMOutgoingEMail",  		"Документ.ИсходящееПисьмо");
	
	// Ежедневные отчеты.
	ДобавитьСтроку(Таблица, "DMDailyReport",		"Документ.ЕжедневныйОтчет");
	
	// Фактические трудозатраты.
	ДобавитьСтроку(Таблица, "DMActualWork", "РегистрСведений.ФактическиеТрудозатраты");
	
	// Используемые перечисления.
	ДобавитьСтроку(Таблица, "DMEMailAnswerType", 		"Перечисление.ТипыОтвета");
	ДобавитьСтроку(Таблица, "DMIssueType", 				"Перечисление.ВидыВопросовВыполненияЗадач");
	ДобавитьСтроку(Таблица, "DMProlongationProcedure",  "Перечисление.ПорядокПродления");
	ДобавитьСтроку(Таблица, "DMDocumentStatus", 		"Перечисление.СостоянияДокументов");
    ДобавитьСтроку(Таблица, "DMLegalPrivatePerson", 	"Перечисление.ЮрФизЛицо");
	ДобавитьСтроку(Таблица, "DMApprovalType",			"Перечисление.ВариантыМаршрутизацииЗадач");
	ДобавитьСтроку(Таблица, "DMTaskExecutionOrder", 	"Перечисление.ПорядокВыполненияЗадач");
	ДобавитьСтроку(Таблица, "DMApprovalOrder",			"Перечисление.ПорядокВыполненияЗадач");
	ДобавитьСтроку(Таблица, "DMApprovalResult",			"Перечисление.РезультатыСогласования");
	ДобавитьСтроку(Таблица, "DMConfirmationResult", 	"Перечисление.РезультатыУтверждения");
	ДобавитьСтроку(Таблица, "DMRegistrationResult", 	"Перечисление.РезультатыРегистрации");
	ДобавитьСтроку(Таблица, "DMInvitationResult",   	"Перечисление.РезультатыПриглашения");
	ДобавитьСтроку(Таблица, "DMGeneralInvitationResult","Перечисление.ОбщиеРезультатыПриглашения");
	ДобавитьСтроку(Таблица, "DMBusinessProcessState",	"Перечисление.СостоянияБизнесПроцессов");	
	ДобавитьСтроку(Таблица, "DMEMailImportance", 		"Перечисление.ВажностьПисем");
	ДобавитьСтроку(Таблица, "DMBusinessProcessRoutingType",
														"Перечисление.ВариантыМаршрутизацииЗадач");
	ДобавитьСтроку(Таблица, "DMPredecessorsStageConsiderationCondition", 
														"Перечисление.УсловияРассмотренияПредшественниковЭтапа");
	ДобавитьСтроку(Таблица, "DMBusinessProcessTaskImportance", "Перечисление.ВариантыВажностиЗадачи");
	ДобавитьСтроку(Таблица, "DMBusinessProcessImportance", "Перечисление.ВариантыВажностиЗадачи");
	ДобавитьСтроку(Таблица, "DMTimeInputMethod", 		"Перечисление.СпособыУказанияВремени");
	ДобавитьСтроку(Таблица, "DMContactInformationType", "Перечисление.ТипыКонтактнойИнформации");
	ДобавитьСтроку(Таблица, "DMDueDateSpecificationOption", "Перечисление.ВариантыУстановкиСрокаИсполнения");
	ДобавитьСтроку(Таблица, "DMVATRate", "Перечисление.СтавкиНДС");
	
	// ПВХ "Дополнительные реквизиты и сведения".
	ДобавитьСтроку(Таблица, "DMAdditionalProperty", 	"ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения");
	
	// Шаблоны бизнес-процессов.
	ДобавитьСтроку(Таблица, "DMBusinessProcessOrderTemplate", 		 	"Справочник.ШаблоныПоручения");
	ДобавитьСтроку(Таблица, "DMBusinessProcessConsiderationTemplate",	"Справочник.ШаблоныРассмотрения");
	ДобавитьСтроку(Таблица, "DMBusinessProcessRegistrationTemplate", 	"Справочник.ШаблоныРегистрации");
	ДобавитьСтроку(Таблица, "DMBusinessProcessApprovalTemplate", 	 	"Справочник.ШаблоныСогласования");
	ДобавитьСтроку(Таблица, "DMBusinessProcessConfirmationTemplate", 	"Справочник.ШаблоныУтверждения");
	ДобавитьСтроку(Таблица, "DMBusinessProcessPerformanceTemplate",  	"Справочник.ШаблоныИсполнения");
	ДобавитьСтроку(Таблица, "DMBusinessProcessAcquaintanceTemplate", 	"Справочник.ШаблоныОзнакомления");
	ДобавитьСтроку(Таблица, "DMCompoundBusinessProcessTemplate", 	 	"Справочник.ШаблоныСоставныхБизнесПроцессов");
	
	// Бизнес-процессы.
	ДобавитьСтроку(Таблица, "DMBusinessProcessOrder", 			"БизнесПроцесс.Поручение");
	ДобавитьСтроку(Таблица, "DMBusinessProcessConsideration", 	"БизнесПроцесс.Рассмотрение");
	ДобавитьСтроку(Таблица, "DMBusinessProcessRegistration", 	"БизнесПроцесс.Регистрация");
	ДобавитьСтроку(Таблица, "DMBusinessProcessApproval", 		"БизнесПроцесс.Согласование");
	ДобавитьСтроку(Таблица, "DMBusinessProcessApproval_1.2.1.11", "БизнесПроцесс.Согласование");
	ДобавитьСтроку(Таблица, "DMBusinessProcessConfirmation", 	"БизнесПроцесс.Утверждение");
	ДобавитьСтроку(Таблица, "DMBusinessProcessPerformance", 	"БизнесПроцесс.Исполнение");
	ДобавитьСтроку(Таблица, "DMBusinessProcessPerformance_1.2.1.11", "БизнесПроцесс.Исполнение");
	ДобавитьСтроку(Таблица, "DMBusinessProcessAcquaintance", 	"БизнесПроцесс.Ознакомление");
	ДобавитьСтроку(Таблица, "DMBusinessProcessIssuesSolution", 	"БизнесПроцесс.РешениеВопросовВыполненияЗадач");
	ДобавитьСтроку(Таблица, "DMBusinessProcessIncomingDocumentProcessing", 	"БизнесПроцесс.ОбработкаВходящегоДокумента");
	ДобавитьСтроку(Таблица, "DMBusinessProcessInternalDocumentProcessing", 	"БизнесПроцесс.ОбработкаВнутреннегоДокумента");
	ДобавитьСтроку(Таблица, "DMBusinessProcessOutgoingDocumentProcessing", 	"БизнесПроцесс.ОбработкаИсходящегоДокумента");
	
	// Типизированные задачи.
	ДобавитьСтроку(Таблица, "DMBusinessProcessTask", "Задача.ЗадачаИсполнителя");
	ДобавитьСтроку(Таблица, "DMBusinessProcessOrderTaskCheckup", "Задача.ЗадачаИсполнителя");
	ДобавитьСтроку(Таблица, "DMBusinessProcessApprovalTaskApproval", "Задача.ЗадачаИсполнителя");
	ДобавитьСтроку(Таблица, "DMBusinessProcessApprovalTaskCheckup", "Задача.ЗадачаИсполнителя");
	ДобавитьСтроку(Таблица, "DMBusinessProcessConfirmationTaskConfirmation", "Задача.ЗадачаИсполнителя");
	ДобавитьСтроку(Таблица, "DMBusinessProcessConfirmationTaskCheckup", "Задача.ЗадачаИсполнителя");
	ДобавитьСтроку(Таблица, "DMBusinessProcessRegistrationTaskRegistration", "Задача.ЗадачаИсполнителя");
	ДобавитьСтроку(Таблица, "DMBusinessProcessRegistrationTaskCheckup", "Задача.ЗадачаИсполнителя");
	ДобавитьСтроку(Таблица, "DMBusinessProcessPerfomanceTaskCheckup", "Задача.ЗадачаИсполнителя");
	ДобавитьСтроку(Таблица, "DMBusinessProcessConsiderationTaskAcquaint", "Задача.ЗадачаИсполнителя");
	ДобавитьСтроку(Таблица, "DMBusinessProcessIssuesSolutionTaskQuestion", "Задача.ЗадачаИсполнителя");
	ДобавитьСтроку(Таблица, "DMBusinessProcessIssuesSolutionTaskAnswer", "Задача.ЗадачаИсполнителя");
	
	ОбработкаЗапросовXDTOПереопределяемый.ДополнитьСоответствиеТипов(Таблица);
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Добавляет строку в таблицу соответствия типов
// 
Процедура ДобавитьСтроку(Таблица, ИмяXDTO, ИмяДО) Экспорт
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.ИмяXDTO = ИмяXDTO;
	НоваяСтрока.ИмяДО = ИмяДО;
	
КонецПроцедуры

#КонецОбласти
