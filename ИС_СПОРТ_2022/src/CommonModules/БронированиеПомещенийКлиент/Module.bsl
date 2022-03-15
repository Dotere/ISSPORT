////////////////////////////////////////////////////////////////////////////////
// Бронирование помещений
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Добавляет значение в массив, если данного значения нет в массиве.
//
Процедура ДобавитьЗначениеВМассив(Значение, Массив) Экспорт
	
	Если ТипЗнч(Значение) = Тип("Структура")
		И Значение.Свойство("Бронь")
		И Значение.Свойство("ДатаИсключения") Тогда
		
		Для Каждого ЭлементМассива Из Массив Цикл
			
			Если ЭлементМассива.Бронь = Значение.Бронь
				И ЭлементМассива.ДатаИсключения = Значение.ДатаИсключения Тогда
				Возврат;
			КонецЕсли;
			
		КонецЦикла;
		
		Массив.Добавить(Значение);
		
	Иначе
		
		Если Массив.Найти(Значение) = Неопределено Тогда
			Массив.Добавить(Значение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Показывает схему территории.
//
// Параметры:
//  Территория - СправочникСсылка.ТерриторииИПомещения - Территория, схему которой необходимо показать.
//
Процедура ПоказатьСхемуТерритории(Территория) Экспорт
	
	ПоказатьЗначение(, Территория);
	
КонецПроцедуры

// Устанавливает пометку удаления брони и оповещает другие формы.
//
// Параметры:
//  Бронь - ДокументСсылка.Бронь - Бронь.
//  ПометкаУдаления - Булево - Новая пометка удаления.
//
Процедура УстановитьПометкуУдаления(Бронь, ПометкаУдаления) Экспорт
	
	Если ТипЗнч(Бронь) <> Тип("ДокументСсылка.БроньСпортивногоОбъекта") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Бронь", Бронь);
	ПараметрыОбработчика.Вставить("ПометкаУдаления", ПометкаУдаления);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьПометкуУдаленияЗавершение",
		ЭтотОбъект, ПараметрыОбработчика);
	
	Если ПометкаУдаления Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пометить ""%1"" на удаление?'"),
			Бронь);
	Иначе
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Снять с ""%1"" пометку на удаление?'"),
			Бронь);
	КонецЕсли;
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,
		, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

// Открывает форму настройки повторения события.
//
// Параметры:
//  Бронь - ДанныеФормыСтруктура - Данные брони.
//  ОписаниеОповещения - ОписаниеОповещения - Описание оповещения обработки после настройки повторения.
//
Процедура ОткрытьФормуНастройкиПовторения(Бронь, ОписаниеОповещения) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Бронь", Бронь);
	
	ОткрытьФорму("Документ.БроньСпортивногоОбъекта.Форма.ФормаНастройкиПовторения", ПараметрыФормы,
		, , , , ОписаниеОповещения);
	
КонецПроцедуры

// Открывает форму настройки.
//
Процедура ОткрытьФормуНастройкиПросмотраБроней() Экспорт
	
	ОткрытьФорму("Документ.БроньСпортивногоОбъекта.Форма.НастройкаПросмотраБроней");
	
КонецПроцедуры

// Обрабатывает редактирование элементов планировщика.
//
// Параметры:
//  Планировщик	 - ПолеФормы	 - Элемент планировщика.
//
Процедура ОбработкаОкончанияРедактирования(Планировщик, ВариантРасписания) Экспорт
		
	ИзмененныеБрони = Новый Массив;
	Для Каждого ВыделенныйЭлемент Из Планировщик.ВыделенныеЭлементы Цикл
		
		Бронь = ВыделенныйЭлемент.Значение;
		Бронь.ДатаНачала 		= ВыделенныйЭлемент.Начало;
		Бронь.ДатаОкончания 	= ВыделенныйЭлемент.Конец;
		
		Если ВариантРасписания = ПредопределенноеЗначение("Перечисление.ВариантРасписания.ПоМестам") Тогда 
			// {Рарус adilas #16045 -Сворачиваемые группировки в расписании 2021.05.07
			Разделитель = "(-)";
			Значения = БронированиеПомещенийВызовСервера.Разложить(ВыделенныйЭлемент.ЗначенияИзмерений["Тренер, инструктор по спорту"], Разделитель);
			
			Бронь.Тренер = Значения.Тренер;
			Бронь.МестоЗанятия = Значения.МестоЗанятия;
			
			//Бронь.Тренер 		= ВыделенныйЭлемент.ЗначенияИзмерений["Тренер, инструктор по спорту"];
			//Бронь.МестоЗанятия 	= ВыделенныйЭлемент.ЗначенияИзмерений["Место занятий"];
			// }Рарус adilas #16045 -Сворачиваемые группировки в расписании 2021.05.07
		КонецЕсли;
		
		ИзмененныеБрони.Добавить(Бронь);
		
	КонецЦикла;
	
	РезультатыБроней = БронированиеПомещенийВызовСервера.ИзменитьБрони(ИзмененныеБрони);
	
	КоличествоБроней = РезультатыБроней.Количество();
	Если КоличествоБроней = 1 Тогда
		ТекстОповещения = НСтр("ru = 'Изменена бронь'");
		Бронь = РезультатыБроней[0].Бронь;
		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Бронь);
		Пояснение = Строка(Бронь);
	Иначе
		ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Изменены брони (%1)'"),
			КоличествоБроней);
		НавигационнаяСсылка = Неопределено;
		Пояснение = Неопределено;
	КонецЕсли;
	ПоказатьОповещениеПользователя(
		ТекстОповещения,
		НавигационнаяСсылка,
		Пояснение,
		БиблиотекаКартинок.Информация32);
	
	Оповестить("Запись_Бронь");
	
КонецПроцедуры

// Обрабатывает создание элемента планировщика.
//
// Параметры:
//  Планировщик			 - ПолеФормы - Планировщик.
//  Начало				 - Дата		 - Дата начала нового элемента.
//  Конец				 - Дата		 - Дата окончания нового элемента.
//  Значения			 - Массив	 - Значения измерений нового элемента.
//  Текст				 - Строка	 - Текст нового элемента.
//  СтандартнаяОбработка - Булево	 - Стандартная обработка.
//
Процедура ОбработкаПередСозданием(Планировщик, Начало, Конец, Значения, Текст, СтандартнаяОбработка, Организация, СпортивныйОбъект) Экспорт
	
	СтандартнаяОбработка = Ложь;
	// {Рарус adilas #16045 -Сворачиваемые группировки в расписании 2021.05.07
	Тренер = Значения.Получить("Тренер, инструктор по спорту");   
	МестоЗанятия  = Значения.Получить("Место занятий");
	
	Разделитель = "(-)";
	Значения = БронированиеПомещенийВызовСервера.Разложить(Тренер, Разделитель);
	
	Тренер = Значения.Тренер;
	МестоЗанятия = Значения.МестоЗанятия;
	
	// }Рарус adilas #16045 -Сворачиваемые группировки в расписании 2021.05.07
	
	СоздатьБронь(
		Тренер,
		МестоЗанятия,
		Начало,
		Конец,
		Ложь,
		Организация,
		СпортивныйОбъект);
	
КонецПроцедуры

// Обрабатывает выбора элемента планировщика.
//
// Параметры:
//  Планировщик			 - ПолеФормы - Планировщик.
//  СтандартнаяОбработка - Булево	 - Стандартная обработка.
//
Процедура ОбработкаВыбораЭлемента(Планировщик, СтандартнаяОбработка, ЭтоМетодист) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если Планировщик.ВыделенныеЭлементы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ВыделенныйЭлемент = Планировщик.ВыделенныеЭлементы[0];
	ЗначениеЭлемента = ВыделенныйЭлемент.Значение;
	Если ЗначениеЭлемента.ВидЭлемента =
		ПредопределенноеЗначение("Перечисление.ЭлементыРабочегоКалендаря.Событие") Тогда
		ПоказатьЗначение(, ЗначениеЭлемента.Ссылка);
	ИначеЕсли ЗначениеЭлемента.ВидЭлемента =
		ПредопределенноеЗначение("Перечисление.ЭлементыРабочегоКалендаря.СобытиеПовторяющееся") Тогда
		ОбработкаВыбораПовторяющейсяБрони(ЗначениеЭлемента.Ссылка, ВыделенныйЭлемент.Начало, ЭтоМетодист);
	КонецЕсли;
		
КонецПроцедуры

// Обрабатывает окончание редактирования элемента планировщика.
//
// Параметры:
//  Планировщик			 - ПолеФормы - Планировщик.
//  НовыйЭлемент		 - Булево	 - Признак создания нового элемента.
//  ОтменаРедактирования - Булево	 - Отмена редактирования.
//
Процедура ОбработкаОкончанияРедактированияЭлемента(Планировщик, НовыйЭлемент, ОтменаРедактирования, ВариантРасписания) Экспорт
	
	ОтменаРедактирования = Истина;
	Если НовыйЭлемент Тогда
		Если Планировщик.ВыделенныеЭлементы.Количество() <> 1 Тогда
			ОтменаРедактирования = Истина;
			Возврат;
		КонецЕсли;
		ОбработкаСозданиеЭлемента(Планировщик, ВариантРасписания);
	Иначе
		ОбработкаОкончанияРедактирования(Планировщик, ВариантРасписания);
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает начало редактирования элемента планировщика.
//
// Параметры:
//  Планировщик			 - ПолеФормы - Планировщик.
//  НовыйЭлемент		 - Булево	 - Признак создания нового элемента.
//  СтандартнаяОбработка - Булево	 - Стандартная обработка.
//
Процедура ОбработкаПередНачаломРедактированиемЭлемента(Планировщик, НовыйЭлемент, СтандартнаяОбработка, ВариантРасписания, ЭтоМетодист) Экспорт
	
	Если НовыйЭлемент Тогда
		СтандартнаяОбработка = Ложь;
		ОбработкаНачалаСозданияЭлемента(Планировщик, ВариантРасписания);
		Возврат;
	КонецЕсли;
	
	ОбработкаВыбораЭлемента(Планировщик, СтандартнаяОбработка, ЭтоМетодист);
	
КонецПроцедуры

// Обрабатывает начало создания элемента планировщика.
//
// Параметры:
//  Планировщик	 - ПолеФормы	 - Планировщик.
//
Процедура ОбработкаНачалаСозданияЭлемента(Планировщик, ВариантРасписания) Экспорт
	
	ВыделенныйЭлемент = Планировщик.ВыделенныеЭлементы[0];
	
	Если ВариантРасписания = ПредопределенноеЗначение("Перечисление.ВариантРасписания.ПоМестам") Тогда 
			
		Тренер 			= ВыделенныйЭлемент.ЗначенияИзмерений.Получить("Тренер, инструктор по спорту");
		МестоЗанятия 	= ВыделенныйЭлемент.ЗначенияИзмерений.Получить("Место занятий");
			
	ИначеЕсли ВариантРасписания = ПредопределенноеЗначение("Перечисление.ВариантРасписания.Общее") Тогда 
			
		Тренер 			= ВыделенныйЭлемент.Значения.Получить("Тренер, инструктор по спорту"); 
		МестоЗанятия  	= ВыделенныйЭлемент.Значения.Получить("Место занятий");
			
	КонецЕсли;

	СоздатьБронь(
		Тренер,
		МестоЗанятия,
		ВыделенныйЭлемент.Начало,
		ВыделенныйЭлемент.Конец,
		Ложь,
		ВыделенныйЭлемент.Значения.Получить("Организация"),
		ВыделенныйЭлемент.Значения.Получить("СпортивныйОбъект"));
	
КонецПроцедуры

// Обрабатывает удаление элемента планировщика.
//
// Параметры:
//  Планировщик	 - ПолеФормы	 - Планировщик.
//  Отказ		 - Булево		 - Отказ.
//
Процедура ОбработкаПередУдалениемЭлемента(Планировщик, Отказ) Экспорт
	
	Отказ = Истина;
	
	ПометкаУдаления = Ложь;
	События = ПолучитьСобытияВВыделеннойОбласти(Планировщик, ПометкаУдаления, Ложь);
	ПовторяющиесяБрони = ПолучитьПовторяющиесяБрониВВыделеннойОбласти(Планировщик);
	Если События.Количество() = 0 И ПовторяющиесяБрони.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПометкиУдаления(События, ПовторяющиесяБрони, Не ПометкаУдаления);
	
КонецПроцедуры

// Создает и записывает бронь в базу данных.
//
// Параметры:
//  Помещение		 - СправочникСсылка.ТерриторииИПомещения - Помещение для брони.
//  ДатаНачала		 - Дата									 - Дата начала.
//  ДатаОкончания	 - Дата									 - Дата окончания.
//  Комментарий		 - Строка								 - Текстовый комментарий.
//
Процедура СоздатьИЗаписатьБронь(Тренер, МестоЗанятия, ДатаНачала, ДатаОкончания, ВесьДень, Организация, СпортивныйОбъект) Экспорт
	
	Бронь = Новый Структура("Организация, СпортивныйОбъект, МестоЗанятия, Тренер, ДатаНачала, ДатаОкончания, ВесьДень");
	//Бронь.Ключ, Ключ;
	Бронь.Тренер = Тренер;
	Бронь.МестоЗанятия = МестоЗанятия;
	Бронь.ВесьДень = ВесьДень;
	Бронь.ДатаНачала = ?(ВесьДень, Бронь.ДатаНачала, ДатаНачала);
	Бронь.ДатаОкончания = ?(ВесьДень, Бронь.ДатаОкончания, ДатаОкончания);
	Бронь.Организация = Организация;
	Бронь.СпортивныйОбъект = СпортивныйОбъект;
	
	РезультатБрони = БронированиеПомещенийВызовСервера.СоздатьБронь(Бронь);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Забронировано место занятия'"),
		ПолучитьНавигационнуюСсылку(РезультатБрони.Бронь),
		Строка(РезультатБрони.Бронь),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("Создание_Бронь");
	Оповестить("Запись_Бронь");
	
КонецПроцедуры

// Открывает форму выбора времени брони.
//
// Параметры:
//  Бронь					 - ДанныеФормы - Данные брони.
//  БроньИсключение			 - ДокументСсылка.Бронь	 - Бронь, которая не будет учитываться при проверке.
//  ДатаИсключения			 - Дата	 - Дата брони, которая не будет учитываться при проверке.
//  ОписаниеОповещения		 - ОписаниеОповещения	 - Описание оповещения, выполняемое после выбора.
//  ВесьДень				 - Булево - Признак того что следует выбирать время за весь день.
//  ОтображатьПредупреждение - Булево - Признак того что следует отображать предупреждение.
//
Процедура ВыбратьВремяБрони(Бронь, БроньИсключение = Неопределено,
	ДатаИсключения = Неопределено, ОписаниеОповещения = Неопределено,
	ВесьДень = Истина, ОтображатьПредупреждение = Ложь) Экспорт
	
	ПараметрыФормы =
		Новый Структура("Бронь, БроньИсключение, ДатаИсключения, ВесьДень, ОтображатьПредупреждение");
	ПараметрыФормы.Бронь = Бронь;
	ПараметрыФормы.БроньИсключение = БроньИсключение;
	ПараметрыФормы.ДатаИсключения = ДатаИсключения;
	ПараметрыФормы.ВесьДень = ВесьДень;
	ПараметрыФормы.ОтображатьПредупреждение = ОтображатьПредупреждение;
	
	//ОткрытьФорму("Документ.БроньСпортивногоОбъекта.Форма.ВыборРекомендованногоВремени", ПараметрыФормы,
		//, , , , ОписаниеОповещения);
	
КонецПроцедуры

// Открывает форму создания новой брони.
//
// Параметры:
//  Помещение			 - СправочникСсылка.ТерриторииИПомещения - Помещение для брони.
//  ДатаНачала			 - Дата									 - Дата начала.
//  ДатаОкончания		 - Дата									 - Дата окончания.
//  ВесьДень			 - Булево								 - Признак того что бронь на весь день.
//  Комментарий			 - Строка								 - Текстовый комментарий.
//  КоличествоЧеловек	 - Число								 - Количество человек.
//
Процедура СоздатьБронь(Тренер, МестоЗанятия, ДатаНачала, ДатаОкончания, ВесьДень = Ложь, Организация, СпортивныйОбъект) Экспорт
	
	СтруктураОснование = Новый Структура("Организация, СпортивныйОбъект, МестоЗанятия, Тренер, ДатаНачала, ДатаОкончания, ВесьДень");
	СтруктураОснование.Тренер = Тренер;
	СтруктураОснование.МестоЗанятия = МестоЗанятия;
	СтруктураОснование.ДатаНачала = ?(ВесьДень, ДатаНачала, ДатаНачала);
	СтруктураОснование.ДатаОкончания = ?(ВесьДень, ДатаОкончания, ДатаОкончания);
	СтруктураОснование.ВесьДень = ВесьДень;
	СтруктураОснование.Организация = Организация;
	СтруктураОснование.СпортивныйОбъект = СпортивныйОбъект;
	
	ПараметрыФормы = Новый Структура("Основание", СтруктураОснование);
	
	ОткрытьФорму("Документ.БроньСпортивногоОбъекта.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// Открывает форму выбора времени, а потом создания брони.
//
// Параметры:
//  Помещение		 - СправочникСсылка.ТерриторииИПомещения - Помещение для брони.
//  ДатаНачала		 - Дата									 - Дата начала.
//  ДатаОкончания	 - Дата									 - Дата окончания.
//
Процедура ВыбратьВремяИСоздатьБронь(МестоЗанятия, ДатаНачала, ДатаОкончания) Экспорт
	
	Бронь = Новый Структура;
	Бронь.Вставить("Ссылка", ПредопределенноеЗначение("Документ.БроньСпортивногоОбъекта.ПустаяСсылка"));
	Бронь.Вставить("МестоЗанятия", МестоЗанятия);
	Бронь.Вставить("ДатаНачала", ДатаНачала);
	Бронь.Вставить("ДатаОкончания", ДатаОкончания);
	Бронь.Вставить("ТипЗаписи", ПредопределенноеЗначение("Перечисление.ТипЗаписиКалендаря.Событие"));
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("МестоЗанятия", МестоЗанятия);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьВремяИСоздатьБроньЗавершение",
		ЭтотОбъект, ПараметрыОбработчика);
	
	ВыбратьВремяБрони(Бронь, , , ОписаниеОповещения, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обрабатывает создание элементов планировщика.
//
// Параметры:
//  Планировщик	 - ПолеФормы - Планировщик.
//
Процедура ОбработкаСозданиеЭлемента(Планировщик, ВариантРасписания)
	
	ВыделенныйЭлемент = Планировщик.ВыделенныеЭлементы[0];

	Если ВариантРасписания = ПредопределенноеЗначение("Перечисление.ВариантРасписания.ПоМестам") Тогда 
			
			Тренер 			= ВыделенныйЭлемент.ЗначенияИзмерений.Получить("Тренер, инструктор по спорту");
			МестоЗанятия 	= ВыделенныйЭлемент.ЗначенияИзмерений.Получить("Место занятий");
			
		ИначеЕсли ВариантРасписания = ПредопределенноеЗначение("Перечисление.ВариантРасписания.Общее") Тогда 
			
			Тренер 			= ВыделенныйЭлемент.Значение.Тренер;
			МестоЗанятия  	= ВыделенныйЭлемент.Значение.МестоЗанятия;
			
		КонецЕсли;
		
	
	Если МестоЗанятия = Неопределено Тогда
		ОбработкаНачалаСозданияЭлемента(Планировщик, ВариантРасписания);
		Возврат;
	КонецЕсли;
	
	НоваяДатаНачала = ВыделенныйЭлемент.Начало;
	НоваяДатаОкончания = ВыделенныйЭлемент.Конец;
	Если ВыделенныйЭлемент.Значение.ВесьДень Тогда
		НоваяДатаНачала = НачалоДня(НоваяДатаНачала);
		НоваяДатаОкончания = НоваяДатаНачала + (ВыделенныйЭлемент.Значение.ДатаОкончания - ВыделенныйЭлемент.Значение.ДатаНачала);
	КонецЕсли;
	
	СоздатьИЗаписатьБронь(
		Тренер,
		МестоЗанятия,
		НоваяДатаНачала,
		НоваяДатаОкончания,
		ВыделенныйЭлемент.Значение.ВесьДень,
		ВыделенныйЭлемент.Значение.Организация,
		ВыделенныйЭлемент.Значение.СпортивныйОбъект
		);	
		
КонецПроцедуры

// Завершение выбора времени при создании брони.
//
Процедура ВыбратьВремяИСоздатьБроньЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("МестоЗанятия", ДополнительныеПараметры.МестоЗанятия);
	ЗначенияЗаполнения.Вставить("ДатаНачала", Результат.ДатаНачала);
	ЗначенияЗаполнения.Вставить("ДатаОкончания", Результат.ДатаОкончания);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.БроньСпортивногоОбъекта.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// Завершение установки пометки удаления после вопроса.
//
Процедура УстановитьПометкуУдаленияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УстановленаПометкаУдаления = БронированиеПомещенийВызовСервера.УстановитьПометкуУдаления(
		ДополнительныеПараметры.Бронь,
		ДополнительныеПараметры.ПометкаУдаления);
	
	Если УстановленаПометкаУдаления Тогда
		
		Если ДополнительныеПараметры.ПометкаУдаления Тогда
			ТекстОповещения = НСтр("ru = 'Пометка удаления установлена'");
		Иначе
			ТекстОповещения = НСтр("ru = 'Пометка удаления снята'");
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			ТекстОповещения,
			ПолучитьНавигационнуюСсылку(ДополнительныеПараметры.Бронь),
			Строка(ДополнительныеПараметры.Бронь),
			БиблиотекаКартинок.Информация32);
		Оповестить("Запись_Бронь", ДополнительныеПараметры.Бронь);
		ОповеститьОбИзменении(ДополнительныеПараметры.Бронь);
		
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает выбор исключения повторения.
//
Процедура ОбработкаВыбораПовторяющейсяБрони(Бронь, ДатаИсключения, ЭтоМетодист)
	
	Если ЭтоМетодист Тогда  
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Бронь", Бронь);
		ПараметрыОбработчика.Вставить("ДатаИсключения", ДатаИсключения);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораПовторяющегосяСобытияЗавершение",
			ЭтотОбъект, ПараметрыОбработчика);
		
		ТекстВопроса = НСтр("ru = 'Это повторяющаяся бронь.'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("ИзменитьОдно", НСтр("ru = 'Изменить одно событие'"));
		Кнопки.Добавить("ИзменитьВсе", НСтр("ru = 'Изменить все'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки, , "ИзменитьОдно");		
	Иначе	
	    ПоказатьЗначение(, Бронь);
	КонецЕсли;
		
КонецПроцедуры

// Обрабатывает выбор исключения повторения.
//
Процедура ОбработкаВыбораПовторяющегосяСобытияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "ИзменитьОдно" Тогда	 
		СоздатьИсключениеПовторения(ДополнительныеПараметры.Бронь, ДополнительныеПараметры.ДатаИсключения);
	ИначеЕсли Результат = "ИзменитьВсе" Тогда 
		ПоказатьЗначение(, ДополнительныеПараметры.Бронь);
	КонецЕсли;
	
КонецПроцедуры

// Создает элемент повторяющейся брони на конкретную дату.
//
Процедура СоздатьИсключениеПовторения(Бронь, ДатаИсключения)
	
	СтруктураОснование = Новый Структура("ПовторяющаясяБронь, ДатаИсключения");
	СтруктураОснование.ПовторяющаясяБронь = Бронь;
	СтруктураОснование.ДатаИсключения = ДатаИсключения;
	
	ПараметрыФормы = Новый Структура("Основание, ПовторяющаясяБронь, ДатаИсключения");
	ПараметрыФормы.Основание = СтруктураОснование;
	ПараметрыФормы.ПовторяющаясяБронь = Бронь;
	ПараметрыФормы.ДатаИсключения = ДатаИсключения;
	
	ОткрытьФорму("Документ.БроньСпортивногоОбъекта.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// Возвращает массив записей календаря, содержащихся в выделенной области.
//
Функция ПолучитьСобытияВВыделеннойОбласти(Планировщик, ПометкаУдаления = Ложь, ВключаяПовторяющиеся = Истина) Экспорт
	
	События = Новый Массив;
	
	Для Каждого ВыделенныйЭлемент Из Планировщик.ВыделенныеЭлементы Цикл
		
		ЗначениеЭлемента = ВыделенныйЭлемент.Значение;
		
		Если Не ВключаяПовторяющиеся
			И ЗначениеЭлемента.ВидЭлемента =
				ПредопределенноеЗначение("Перечисление.ЭлементыРабочегоКалендаря.СобытиеПовторяющееся") Тогда
			Продолжить;
		КонецЕсли;
		
		ДобавитьЗначениеВМассив(ЗначениеЭлемента.Ссылка, События);
		ПометкаУдаления = ПометкаУдаления Или ЗначениеЭлемента.ПометкаУдаления;
		
	КонецЦикла;
	
	Возврат События;
	
КонецФункции

// Возвращает массив повторяющихся событий, содержащихся в выделенной области.
//
Функция ПолучитьПовторяющиесяБрониВВыделеннойОбласти(Планировщик) Экспорт
	
	ПовторяющиесяБрони = Новый Массив;
	
	Для Каждого ВыделенныйЭлемент Из Планировщик.ВыделенныеЭлементы Цикл
		
		ЗначениеЭлемента = ВыделенныйЭлемент.Значение;
		
		Если ЗначениеЭлемента.ВидЭлемента <>
			ПредопределенноеЗначение("Перечисление.ЭлементыРабочегоКалендаря.СобытиеПовторяющееся") Тогда
			Продолжить;
		КонецЕсли;
		
		ПовторяющаясяБронь = Новый Структура("Бронь, ДатаИсключения");
		ПовторяющаясяБронь.Бронь = ЗначениеЭлемента.Ссылка;
		ПовторяющаясяБронь.ДатаИсключения = ВыделенныйЭлемент.Начало;
		
		ДобавитьЗначениеВМассив(ПовторяющаясяБронь, ПовторяющиесяБрони);
		
	КонецЦикла;
	
	Возврат ПовторяющиесяБрони;
	
КонецФункции

// Устанавливает пометки удаления броней и оповещает другие формы.
//
Процедура УстановитьПометкиУдаления(Брони, ПовторяющиесяБрони, ПометкаУдаления, ОбработанныеВопросы = Неопределено) Экспорт
	
	Если ТипЗнч(Брони) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбработанныеВопросы = Неопределено Тогда
		ОбработанныеВопросы = Новый Структура;
	КонецЕсли;
	
	Если Не ОбработанныеВопросы.Свойство("ИзмененаПометкаУдаления") Тогда
		
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Брони", Брони);
		ПараметрыОбработчика.Вставить("ПовторяющиесяБрони", ПовторяющиесяБрони);
		ПараметрыОбработчика.Вставить("ПометкаУдаления", ПометкаУдаления);
		ПараметрыОбработчика.Вставить("ОбработанныеВопросы", ОбработанныеВопросы);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"УстановитьПометкиУдаленияПослеВопросаОбИзмененииПометкиУдаления",
			ЭтотОбъект,
			ПараметрыОбработчика);
		
		Если ПометкаУдаления Тогда
			ТекстВопроса = НСтр("ru = 'Пометить выделенные элементы на удаление?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Снять с выделенных элементов пометку на удаление?'");
		КонецЕсли;
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,
			, КодВозвратаДиалога.Нет);
		Возврат;
		
	КонецЕсли;
	
	УстановленаПометкаУдаления = БронированиеПомещенийВызовСервера.УстановитьПометкиУдаления(Брони, ПовторяющиесяБрони, ПометкаУдаления);
	
	Если УстановленаПометкаУдаления Тогда
		
		КоличествоБроней = Брони.Количество();
		КоличествоПовторяющихсяБроней = ПовторяющиесяБрони.Количество();
		КоличествоОбъектов = КоличествоБроней + КоличествоПовторяющихсяБроней;
		Если КоличествоОбъектов = 1 Тогда
			Если ПометкаУдаления Тогда
				ТекстОповещения = НСтр("ru = 'Пометка удаления установлена'");
			Иначе
				ТекстОповещения = НСтр("ru = 'Пометка удаления снята'");
			КонецЕсли;
			Если КоличествоБроней = 1 Тогда
				Бронь = Брони[0];
			ИначеЕсли КоличествоПовторяющихсяБроней = 1 Тогда
				Бронь = ПовторяющиесяБрони[0].Бронь;
			КонецЕсли;
			НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Бронь);
			Пояснение = Строка(Бронь);
		Иначе
			Если ПометкаУдаления Тогда
				ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Пометки удаления установлены (%1)'"),
					КоличествоОбъектов);
			Иначе
				ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Пометки удаления сняты (%1)'"),
					КоличествоОбъектов);
			КонецЕсли;
			НавигационнаяСсылка = Неопределено;
			Пояснение = Неопределено;
		КонецЕсли;
		ПоказатьОповещениеПользователя(
			ТекстОповещения,
			НавигационнаяСсылка,
			Пояснение,
			БиблиотекаКартинок.Информация32);
		
		Оповестить("Запись_Бронь");
		
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает пометки удаления записей и оповещает другие формы.
//
Процедура УстановитьПометкиУдаленияПослеВопросаОбИзмененииПометкиУдаления(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.ОбработанныеВопросы.Вставить("ИзмененаПометкаУдаления", Истина);
	УстановитьПометкиУдаления(
		ДополнительныеПараметры.Брони,
		ДополнительныеПараметры.ПовторяющиесяБрони,
		ДополнительныеПараметры.ПометкаУдаления,
		ДополнительныеПараметры.ОбработанныеВопросы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбщегоНазначенияДокументооборотКлиент

// Показывает вопрос "Да" / "Нет", принимая Esc и закрытие формы крестиком как ответ "Нет".
//
// Параметры:
//   ОписаниеОповещенияОЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия с
//     передачей параметра КодВозвратаДиалога.Да или КодВозвратаДиалога.Нет.
//   ТекстВопроса - Строка - текст задаваемого вопроса.
//   ТекстКнопкиДа - Строка - необязательный, текст кнопки "Да".
//   ТекстКнопкиНет - Строка - необязательный, текст кнопки "Нет".
//   КнопкаПоУмолчанию - РежимДиалогаВопрос - необязательный, кнопка по умолчанию.
//
Процедура ПоказатьВопросДаНет(ОписаниеОповещенияОЗавершении, ТекстВопроса,
	ТекстКнопкиДа = Неопределено, ТекстКнопкиНет = Неопределено, КнопкаПоУмолчанию = Неопределено) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьВопросДаНетЗавершение", ЭтотОбъект, ОписаниеОповещенияОЗавершении);
		
	Кнопки = Новый СписокЗначений;
	Если ТекстКнопкиДа = Неопределено Тогда
		Кнопки.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Да'"));
	Иначе
		Кнопки.Добавить(КодВозвратаДиалога.ОК, ТекстКнопкиДа);
	КонецЕсли;
	Если ТекстКнопкиНет = Неопределено Тогда
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Нет'"));
	Иначе
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, ТекстКнопкиНет);
	КонецЕсли;
	
	Если КнопкаПоУмолчанию = Неопределено Тогда
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	ИначеЕсли КнопкаПоУмолчанию = КодВозвратаДиалога.Да Тогда
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,, КодВозвратаДиалога.ОК);
	ИначеЕсли КнопкаПоУмолчанию = КодВозвратаДиалога.Нет Тогда
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,, КодВозвратаДиалога.Отмена);
	Иначе
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение кнопки по умолчанию: %1'"),
			КнопкаПоУмолчанию);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после закрытия окна с вопросом "Да" / "Нет" и вызывает ранее переданный обработчик
// оповещения с передачей ответа пользователя.
//
// Параметры:
//   Результат - КодВозвратаДиалога - ответ пользователя,
//     КодВозвратаДиалога.ОК или КодВозвратаДиалога.Отмена.
//   ОписаниеОповещения - ОписаниеОповещения - описание вызываемого оповещения.
//
Процедура ПоказатьВопросДаНетЗавершение(Результат, ОписаниеОповещения) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти