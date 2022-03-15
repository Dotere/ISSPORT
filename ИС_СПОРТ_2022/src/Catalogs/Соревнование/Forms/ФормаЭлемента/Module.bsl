#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если НЕ Объект.Жеребьевка.Количество()= 0 Тогда
		ВыполнитьПережеребьевку();
		
		Для Каждого СтрокаЖеребьевка Из Объект.Жеребьевка Цикл
			строкаЖеребьевка.ПолПредставление = ?(строкаЖеребьевка.Пол = Перечисления.ПолФизическогоЛица.Женский,"Девушки",?(строкаЖеребьевка.Пол = Перечисления.ПолФизическогоЛица.Мужской,"Юноши",""));
		КонецЦикла;
		
		ЗаполнитьДеревоНаФорме();
		
	КонецЕсли;
	
	Если Параметры.Свойство("Владелец") Тогда
		Объект.Владелец = Параметры.Владелец;
	ИначеЕсли Объект.Ссылка.Пустая() Тогда
		Объект.Владелец = ПараметрыСеанса.ТекущаяОрганизация;
	КонецЕсли;	
	
	// {Рарус adilas #11068 -Возрастные группы в соревновании 2020.11.18
	Если УчетСпортсменовВызовСервера.ТекущиеПараметрыФО(Объект.Владелец).ВозрастныеГруппыОрганизация Тогда

		// + Адильбеков А.Б. 30.06.20 IN-7478 {
		Если НЕ Объект.МеждународныеВозрастныеГруппы.Количество()= 0 Тогда
			
			Для Каждого СтрокаМеждународныеВозрастныеГруппы Из Объект.МеждународныеВозрастныеГруппы Цикл
				СтрокаМеждународныеВозрастныеГруппы.Возраст = Строка(СтрокаМеждународныеВозрастныеГруппы.МеждународнаяВозрастнаяГруппа.ВозрастОт) + "-" + Строка(СтрокаМеждународныеВозрастныеГруппы.МеждународнаяВозрастнаяГруппа.ВозрастДо);
			КонецЦикла;
			
			ЗаполнитьДеревоНаФорме();
			
		КонецЕсли;
		// - Адильбеков А.Б. 30.06.20 IN-7478 }
		
	КонецЕсли;
	// }Рарус adilas #11068 -Возрастные группы в соревновании 2020.11.18
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьДоступность(Истина);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ЗаполнитьТаблицаЖеребьевкиИзДереваЗначений(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства	
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличныхЧастей

&НаКлиенте
Процедура ЖеребьевкаДеревоЗначенийПослеУдаления(Элемент)
	
	ВыполнитьПережеребьевку();
	
КонецПроцедуры

&НаКлиенте
Процедура ЖеребьевкаДеревоЗначенийПолПредставлениеПриИзменении(Элемент)
	
	ТекДанные = Элементы.ЖеребьевкаДеревоЗначений.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекДанные.Пол = ?(ТекДанные.ПолПредставление = "Юноши", ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской"),?(ТекДанные.ПолПредставление = "Девушки", ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Женский"),""));
	
КонецПроцедуры

&НаКлиенте
Процедура ЖеребьевкаДеревоЗначенийПриАктивизацииЯчейки(Элемент)
	
	ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
	
	ТекДанные = Элемент.ТекущиеДанные;
	Если НЕ ТекДанные = Неопределено Тогда
		Родитель = ТекДанные.ПолучитьРодителя();
		Если ИмяЭлемента = "ЖеребьевкаДеревоЗначенийВозрастнаяГруппа" Тогда 
			Элемент.ТекущийЭлемент.ТолькоПросмотр = НЕ Родитель = Неопределено;
			Если НЕ ЗначениеЗаполнено(ТекДанные.МеждународныеВозрастныеГруппы) Тогда
				ТекДанные.МеждународныеВозрастныеГруппы = ТекущаяВозрастнаяГруппа;
			КонецЕсли;	
		КонецЕсли;
		Если ИмяЭлемента = "ЖеребьевкаДеревоЗначенийПолПредставление" Тогда 
			Элемент.ТекущийЭлемент.ТолькоПросмотр = Родитель = Неопределено;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЖеребьевкаДеревоЗначенийОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	ВыполнитьПережеребьевку();
	
КонецПроцедуры

&НаКлиенте
Процедура ЖеребьевкаДеревоЗначенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ТекущаяВозрастнаяГруппа = "";
	ТекДанные = Элемент.ТекущиеДанные;
	Если НЕ ТекДанные = Неопределено Тогда
		Родитель = ТекДанные.ПолучитьРодителя(); 
		Если Родитель = Неопределено Тогда
			ТекущаяВозрастнаяГруппа = ТекДанные.МеждународныеВозрастныеГруппы;
		Иначе
			Отказ = Истина;	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЖеребьевкаДеревоЗначенийВозрастнаяГруппаПриИзменении(Элемент)
	
	ТекДанные = Элементы.ЖеребьевкаДеревоЗначений.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Родитель = ТекДанные.ПолучитьРодителя();
	Если Родитель = Неопределено Тогда
		ИзменитьРодителяВПодгруппеВозрастнойГруппы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЖеребьевкаДеревоЗначенийПриИзменении(Элемент)
	
	ВыполнитьПережеребьевку();
	
	Для каждого Уроверь из ЖеребьевкаДеревоЗначений.ПолучитьЭлементы() цикл
		Элементы.ЖеребьевкаДеревоЗначений.Развернуть(Уроверь.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ЗаполнитьЖеребьевку(Команда)
	
	Если Объект.МеждународныеВозрастныеГруппы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнены возрастные группы!",,"ВозрастныеГруппы","Объект.ВозрастныеГруппы");
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.Жеребьевка.Количество() = 0 Тогда
		
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьЖеребьевкуЗавершение",
		ЭтотОбъект);	
		
		ПоказатьВопрос(Оповещение,
		"Табличная часть будет очищена.
		|Продолжить?",
		РежимДиалогаВопрос.ДаНет,
		0);
		
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьЖеребьевкуПродолжить();
	
КонецПроцедуры

#КонецОбласти

#Область ДополнительныеРеквизиты

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийРеквизитовШапки

&НаКлиенте
Процедура УказатьУсловияПроведенияВРазрезеПопытокПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура УстановитьВидимостьДоступность(ПервичноеОткрытие = Ложь)
		
	
КонецПроцедуры			

&НаКлиенте
Процедура ЗаполнитьЖеребьевкуЗавершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Жеребьевка.Очистить();
		ЗаполнитьЖеребьевкуПродолжить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЖеребьевкуПродолжить()
	
	тзВозрастныеГруппы = Объект.МеждународныеВозрастныеГруппы.Выгрузить();
	тзВозрастныеГруппы.Колонки.Добавить("ДатаРожденияНачало" , Новый ОписаниеТипов("Дата"));
	тзВозрастныеГруппы.Колонки.Добавить("Пол"                , Новый ОписаниеТипов("ПеречислениеСсылка.ПолФизическогоЛица"));
	тзВозрастныеГруппы.Колонки.Добавить("ПолПредставление"   , Новый ОписаниеТипов("Строка"));
	
	Для Каждого строкаВозрастнаяГруппа_1 Из тзВозрастныеГруппы Цикл
		строкаВозрастнаяГруппа_1.ДатаРожденияНачало = строкаВозрастнаяГруппа_1.МеждународнаяВозрастнаяГруппа.ДатаНачала;
		строкаВозрастнаяГруппа_1.Пол                = Перечисления.ПолФизическогоЛица.Мужской;
		строкаВозрастнаяГруппа_1.ПолПредставление   = "Юноши";
	КонецЦикла;
	
	Для Каждого строкаВозрастнаяГруппа Из Объект.МеждународныеВозрастныеГруппы Цикл
		строкаВозрастнаяГруппа_2                    = тзВозрастныеГруппы.Добавить();
		строкаВозрастнаяГруппа_2.МеждународнаяВозрастнаяГруппа   = строкаВозрастнаяГруппа.МеждународнаяВозрастнаяГруппа;
		строкаВозрастнаяГруппа_2.ДатаРожденияНачало = строкаВозрастнаяГруппа.МеждународнаяВозрастнаяГруппа.ДатаНачала;
		строкаВозрастнаяГруппа_2.Пол                = Перечисления.ПолФизическогоЛица.Женский;
		строкаВозрастнаяГруппа_2.ПолПредставление   = "Девушки";
	КонецЦикла;
	
	тзВозрастныеГруппы.Сортировать("ДатаРожденияНачало Возр");
	
	ТекущаяВозрастнаяГруппа = Неопределено;
	Для Индекс = 0 По тзВозрастныеГруппы.Количество()-1 Цикл
		строкаЖеребьевка = Объект.Жеребьевка.Добавить();
		ЗаполнитьЗначенияСвойств(строкаЖеребьевка,тзВозрастныеГруппы[Индекс]);
		строкаЖеребьевка.НомерПозицииВГруппе = Индекс + 1;
	КонецЦикла;
	
	ЗаполнитьДеревоНаФорме();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоНаФорме()
	
	ДеревоЗначений = РеквизитФормыВЗначение("ЖеребьевкаДеревоЗначений");
	
	тзВозрастныеГруппы = Объект.Жеребьевка.Выгрузить();
	тзВозрастныеГруппы.Свернуть("МеждународнаяВозрастнаяГруппа");
	
	Для Каждого стрВозрастнаяГруппа Из тзВозрастныеГруппы Цикл
	    Строки = ДеревоЗначений.Строки.Добавить();
		Строки.МеждународнаяВозрастнаяГруппа = стрВозрастнаяГруппа.МеждународнаяВозрастнаяГруппа;
		массивСтрок = Объект.Жеребьевка.НайтиСтроки(Новый Структура("МеждународнаяВозрастнаяГруппа",стрВозрастнаяГруппа.МеждународнаяВозрастнаяГруппа));
		Для Каждого стрМассив Из массивСтрок Цикл
			строка = Строки.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(строка,стрМассив);
		КонецЦикла;	
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоЗначений, "ЖеребьевкаДеревоЗначений");
	
КонецПроцедуры	

&НаСервере
Процедура ВыполнитьПережеребьевку()
	
	НомерПозицииВГруппе = 1;
	
	ДеревоЗначений = РеквизитФормыВЗначение("ЖеребьевкаДеревоЗначений");
	
	Для Каждого СтрокаДерева Из ДеревоЗначений.Строки Цикл
		Для Каждого Строки Из СтрокаДерева.Строки Цикл
			Строки.НомерПозицииВГруппе = НомерПозицииВГруппе;
			НомерПозицииВГруппе = НомерПозицииВГруппе + 1;
		КонецЦикла;	
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоЗначений, "ЖеребьевкаДеревоЗначений");
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРодителяВПодгруппеВозрастнойГруппы()
	
	ДеревоЗначений = РеквизитФормыВЗначение("ЖеребьевкаДеревоЗначений");
	Для Каждого СтрокаДерева Из ДеревоЗначений.Строки Цикл
		Для Каждого Строки Из СтрокаДерева.Строки Цикл
			Если СтрокаДерева.МеждународнаяВозрастнаяГруппа <> Строки.МеждународнаяВозрастнаяГруппа Тогда
				Строки.МеждународнаяВозрастнаяГруппа = СтрокаДерева.МеждународнаяВозрастнаяГруппа;
			КонецЕсли;	
		КонецЦикла;	
	КонецЦикла;	
	ЗначениеВРеквизитФормы(ДеревоЗначений, "ЖеребьевкаДеревоЗначений");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицаЖеребьевкиИзДереваЗначений(Отказ)
	
	Объект.Жеребьевка.Очистить();
	
	ДеревоЗначений = РеквизитФормыВЗначение("ЖеребьевкаДеревоЗначений");
	Для Каждого СтрокаДерева Из ДеревоЗначений.Строки Цикл
		Для Каждого Строки Из СтрокаДерева.Строки Цикл
			строкаЖеребьевка = Объект.Жеребьевка.Добавить();
			ЗаполнитьЗначенияСвойств(строкаЖеребьевка,Строки);
		КонецЦикла;	
	КонецЦикла;	
	ЗначениеВРеквизитФормы(ДеревоЗначений, "ЖеребьевкаДеревоЗначений");
	
	тзКопия = Объект.Жеребьевка.Выгрузить();
	тзКопия.Свернуть("МеждународнаяВозрастнаяГруппа,Пол");
	Если тзКопия.Количество() <> Объект.Жеребьевка.Количество() Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Найдены дубли при формировании жеребьевки! Запись невозможна.",,"ЖеребьевкаДеревоЗначений","ЖеребьевкаДеревоЗначений");
	КонецЕсли;	
	
КонецПроцедуры	

// + Адильбеков А.Б. 26.06.20 IN-7478-79 {
&НаКлиенте
Процедура ПолноеНаименованиеПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	Объект.Наименование = Объект.ПолноеНаименование;
КонецПроцедуры

&НаКлиенте
Процедура ВозрастныеГруппыВозрастнаяГруппаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.МеждународныеВозрастныеГруппы.ТекущиеДанные;
	
	ТекущиеДанные.Возраст = ПолучитьПериод(ТекущиеДанные.МеждународнаяВозрастнаяГруппа);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПериод(ВозрастнаяГруппа)
	
	Возврат Строка(ВозрастнаяГруппа.ВозрастОт) + "-" + Строка(ВозрастнаяГруппа.ВозрастДо);

КонецФункции // ПолучитьПериод()
 
// - Адильбеков А.Б. 26.06.20 IN-7478-79 }

// {Рарус kotana #IN-16534 -Запретить выбор элементов 1-го уровня 2021.06.04

&НаСервереБезКонтекста
Функция ЭлементВторогоУровня(СсылкаНаЭлемент)
    
  ВозвращаемоеЗначение = Ложь;
  УровеньЭлемента = СсылкаНаЭлемент.Уровень();
  
  Если УровеньЭлемента > 0 Тогда
  
  	ВозвращаемоеЗначение = Истина;
  
  КонецЕсли; 
  
  Возврат ВозвращаемоеЗначение;
  
КонецФункции

&НаКлиенте
Процедура Этапы1ЭтапОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
    
     Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
    
    	ВторогоУровня = ЭлементВторогоУровня(ВыбранноеЗначение);
        
        Если Не ВторогоУровня Тогда
        
        	  Сообщение = Новый СообщениеПользователю;
              Сообщение.Текст = "Запрещено указывать этапы спортивной подготовки верхнего уровня: " + Символы.ПС + "Спортивно - оздоровительный, Начальная подготовка, Тренировочный (спортивная специализация), Совершенствование спортивного мастерства, Высшего спортивного мастерства";
              Сообщение.Сообщить(); 
              
              ВыбранноеЗначение = Неопределено;
              
        КонецЕсли; 
        
    КонецЕсли; 

КонецПроцедуры

// }Рарус kotana #IN-16534 -Запретить выбор элементов 1-го уровня 2021.06.04
#КонецОбласти









