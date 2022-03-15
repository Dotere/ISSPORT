
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Объект.ФизическоеЛицо.Пустая() И Не ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		
		ФизическоеЛицоСсылка = Объект.ФизическоеЛицо;
		ФизЛицоОбъект = РеквизитФормыВЗначение("ФизическоеЛицоОбъект");
		ФизЛицоОбъект = Объект.ФизическоеЛицо.ПолучитьОбъект();
		ЗначениеВРеквизитФормы(ФизЛицоОбъект, "ФизическоеЛицоОбъект");
		
	ИначеЕсли Объект.Ссылка.Пустая() ИЛИ Объект.ФизическоеЛицо.Пустая() Тогда
		
		ФизЛицоОбъект = РеквизитФормыВЗначение("ФизическоеЛицоОбъект");
		ФизическоеЛицоСсылка = Справочники.ФизическиеЛица.ПолучитьСсылку(Новый УникальныйИдентификатор);
		ФизЛицоОбъект.УстановитьСсылкуНового(ФизическоеЛицоСсылка);
		
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			ЗаполнитьЗначенияСвойств(ФизЛицоОбъект,Параметры.ЗначениеКопирования.ФизическоеЛицо,,"Родитель, Владелец, Код");
			ЗаполнитьЗначенияСвойств(Объект.Ссылка,Параметры.ЗначениеКопирования); 
		КонецЕсли;
		
		ЗначениеВРеквизитФормы(ФизЛицоОбъект, "ФизическоеЛицоОбъект");	
		
	КонецЕсли;
		
	ОбновитьФотографиюНаСервере();
		
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ДополнительныеПараметры = УправлениеКонтактнойИнформацией.ПараметрыКонтактнойИнформации();
	ДополнительныеПараметры.ИмяЭлементаДляРазмещения = "ГруппаКонтактнаяИнформация";
	ДополнительныеПараметры.ПоложениеЗаголовкаКИ = ПоложениеЗаголовкаЭлементаФормы.Лево;
	
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, ФизическоеЛицоОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ФизическоеЛицоОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СтруктураФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(ФизическоеЛицоОбъект.Наименование);
	Если не ЗначениеЗаполнено(СтруктураФИО.Фамилия) ИЛИ не ЗначениеЗаполнено(СтруктураФИО.Имя) Тогда
		Сообщить("Необходимо заполнить Фамилию, Имя физического лица!");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СНИЛС_ДляУсловия = СтрЗаменить(СтрЗаменить(ФизическоеЛицоОбъект.СНИЛС,"-","")," ","");
	Если ЗначениеЗаполнено(СНИЛС_ДляУсловия) Тогда
		ТекстСообщения = "";
		КорректныйСНИСЛ = РегламентированныеДанныеКлиентСервер.СтраховойНомерПФРСоответствуетТребованиям(ФизическоеЛицоОбъект.СНИЛС, ТекстСообщения);
		Если НЕ КорректныйСНИСЛ Тогда
			Сообщить(ТекстСообщения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;	
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат
	КонецЕсли;	
	
	ЗаписатьФизическоеЛицоНаСервере(Отказ);
	
	Если Отказ Тогда
		Возврат
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповещениеОЗаписиОбъекта = Новый ОписаниеОповещения("ПослеЗаписиФизическогоЛицаЗавершение", ЭтотОбъект);
	ВыполнитьОбработкуОповещения(ОповещениеОЗаписиОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеСпортивногоУчрежденияЗавершение" Тогда 
		ОбновитьФотографиюНаСервере();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеФизическогоЛицаВФорме" Тогда
		ИзменитьФизическоеЛицоНаСервере();	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, ФизическоеЛицоОбъект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийШапки

&НаКлиенте
Процедура АдресФотографииПриИзменении(Элемент)
	
	Если Не Объект.ФайлФотографии.Пустая() Тогда
		ТекущаяВерсияКартинки = ПолучитьТекущуюВерсиюКартинки(Объект.ФайлФотографии);
		АдресФотографии = РаботаСФайламиСлужебныйВызовСервера.ПолучитьНавигационнуюСсылкуДляОткрытия(ТекущаяВерсияКартинки);
	Иначе 	
		АдресФотографии = "";
	Конецесли;
    Модифицированность=Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресФотографииНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
	Если Объект.Ссылка.Пустая() ИЛИ Модифицированность Тогда 
		
		Оповещение = Новый ОписаниеОповещения("АдресФотографииНажатиеЗавершение", ЭтотОбъект, Новый Структура("Элемент",Элемент));
		
		ПоказатьВопрос(Оповещение,
		"Тренер не записан. Записать?",
        РежимДиалогаВопрос.ДаНет,
        0,
        КодВозвратаДиалога.Да);
		Возврат;
		
	КонецЕсли;
	
	АдресФотографииОткрыть(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ФизическоеЛицо) Тогда                                                  
		Возврат
	КонецЕсли;	
	
	ФизическоеЛицоПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоОбъектНаименованиеПриИзменении(Элемент)
	ФизическоеЛицоОбъектНаименованиеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоОткрытие(Элемент, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.ФизическоеЛицо) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(,Объект.ФизическоеЛицо);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеЗаписиФизическогоЛицаЗавершение(Результат, ДопПараметры)Экспорт
	ЭтаФорма.ОбновитьОтображениеДанных(Элементы.ФизическоеЛицо);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "КОНТАКТНАЯ ИНФОРМАЦИЯ"

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
	
КонецПроцедуры

&НаСервере
Функция Подключаемый_ОбновитьКонтактнуюИнформацию(Результат) Экспорт
	
	РезультатОбновления = УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
	
	ОбновитьФотографиюНаСервере();
	
	Возврат РезультатОбновления;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.АвтоПодборАдреса(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

//{Рарус Lobash IN-9499 16.09.20 
&НаКлиенте
Процедура ПоискПоФизическимЛицамЗавершение(Результат, ДопПараметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		Объект.ФизическоеЛицо = Результат;
		ФизическоеЛицоПриИзменении(ЭтаФорма.Элементы.ФизическоеЛицо);
	КонецЕсли;
	
КонецПроцедуры
//}Рарус Lobash IN-9499 16.09.20 

#Область ПроцедурыИФункцииПоРаботеСФотографией	

&НаСервере
Процедура ОбновитьФотографиюНаСервере()
	Если Не Объект.Фото.Пустая() Тогда
		АдресФотографии = РаботаСФайламиСлужебныйВызовСервера.ПолучитьНавигационнуюСсылкуДляОткрытия(Объект.Фото.ТекущаяВерсия);
	Иначе
		АдресФотографии = "";
	КонецЕсли;	
	Элементы.АдресФотографии.РазмерКартинки = РазмерКартинки.АвтоРазмер;
КонецПроцедуры	

&НаКлиенте
Процедура АдресФотографииОткрыть(Элемент)
	ОткрытьФормуВыбораФайла(Объект.Фото,Элемент);
КонецПроцедуры	

&НаКлиенте
Процедура ОткрытьФормуВыбораФайла(ТекущийФайл,ЭлементВладелец)
	
	ПараметрыФайла = Новый Структура;
	//ПараметрыФайла.Вставить("ВладелецФайла", Объект.Ссылка);
	ПараметрыФайла.Вставить("ЗаголовокФормы", НСтр("ru = 'Присоединенные файлы'"));
	ПараметрыФайла.Вставить("РежимВыбора", истина);
	ПараметрыФайла.Вставить("ТекущаяСтрока", ТекущийФайл);
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьФормуВыбораФайлаЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.Файлы.Форма.ФормаВыбора",	ПараметрыФайла, ЭлементВладелец,,,,Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресФотографииНажатиеЗавершение(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Записать();
		Если НЕ Объект.Ссылка.Пустая() И НЕ Модифицированность Тогда
			АдресФотографииОткрыть(Параметры.Элемент);
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораФайлаЗавершение(Результат, Параметры) Экспорт
	Если НЕ Результат = Неопределено Тогда
		Объект.Фото = Результат;
		ФайлФотографииПриИзменении();
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ФайлФотографииПриИзменении()	
	Если Не Объект.Фото.Пустая() Тогда
		ТекущаяВерсияКартинки = ПолучитьТекущуюВерсиюКартинки(Объект.Фото);
		АдресФотографии = РаботаСФайламиСлужебныйВызовСервера.ПолучитьНавигационнуюСсылкуДляОткрытия(ТекущаяВерсияКартинки);
	Иначе 	
		АдресФотографии = "";
	Конецесли;
    Модифицированность = Истина;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекущуюВерсиюКартинки(ФайлКартинки)

	Возврат ФайлКартинки.ТекущаяВерсия; 	

КонецФункции

&НаКлиенте
Процедура УдалитьФотографиюЗавершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьФотографиюПродолжить();
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура УдалитьФотографиюПродолжить()
	
   Объект.Фото = Справочники.Файлы.ПустаяСсылка();
   ОбновитьФотографиюНаСервере();
   
КонецПроцедуры	

#КонецОбласти

&НаСервере
Процедура ЗаписатьФизическоеЛицоНаСервере(Отказ)
	
	Попытка
		
		ФизЛицоОбъект = РеквизитФормыВЗначение("ФизическоеЛицоОбъект");
		ФизЛицоОбъект.ПроверитьЗаполнение();
		ФизЛицоОбъект.Фото = Объект.Фото;
		
		// СтандартныеПодсистемы.КонтактнаяИнформация
		УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ФизЛицоОбъект);
		// Конец СтандартныеПодсистемы.КонтактнаяИнформация
		
		ФизЛицоОбъект.Записать();
		
		// СтандартныеПодсистемы.КонтактнаяИнформация
		УправлениеКонтактнойИнформацией.ПослеЗаписиНаСервере(ЭтотОбъект, ФизЛицоОбъект);
		// Конец СтандартныеПодсистемы.КонтактнаяИнформация
		
		ЗначениеВРеквизитФормы(ФизЛицоОбъект, "ФизическоеЛицоОбъект");
		ФизическоеЛицоСсылка  = ФизическоеЛицоОбъект.Ссылка;
		Объект.ФизическоеЛицо = ФизическоеЛицоОбъект.Ссылка;
				
	Исключение
		
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		
	КонецПопытки;
	
КонецПроцедуры	

&НаСервере
Процедура ФизическоеЛицоПриИзмененииНаСервере()
	
	ФизическоеЛицоСсылка = Объект.ФизическоеЛицо;
	ФизЛицоОбъект = РеквизитФормыВЗначение("ФизическоеЛицоОбъект");
	ФизЛицоОбъект = Объект.ФизическоеЛицо.ПолучитьОбъект();
	ЗначениеВРеквизитФормы(ФизЛицоОбъект, "ФизическоеЛицоОбъект");
	Если ЗначениеЗаполнено(ФизическоеЛицоСсылка) Тогда 	
		СформироватьНаименованиеФизическогоЛица();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНаименованиеФизическогоЛица()
   Объект.Наименование = ФизическоеЛицоОбъект.Наименование;
КонецПроцедуры

&НаСервере
Процедура ФизическоеЛицоОбъектНаименованиеПриИзмененииНаСервере()
	СтруктураФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(ФизическоеЛицоОбъект.Наименование);
	ЗаполнитьЗначенияСвойств(ФизическоеЛицоОбъект,СтруктураФИО);
	СформироватьНаименованиеФизическогоЛица();
КонецПроцедуры

&НаСервере
Процедура ИзменитьФизическоеЛицоНаСервере()
	
	ФизЛицоОбъект = Объект.ФизическоеЛицо.ПолучитьОбъект();
	ЗначениеВРеквизитФормы(ФизЛицоОбъект, "ФизическоеЛицоОбъект");
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандНаФорме

&НаКлиенте
Процедура ПоискПоЗначению(Команда)
	
	ПоискПоФизическимЛицамКлиент.ПоискПоФизическимЛицам(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти







