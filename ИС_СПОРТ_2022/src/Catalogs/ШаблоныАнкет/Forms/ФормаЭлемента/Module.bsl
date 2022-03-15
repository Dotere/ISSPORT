///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ,СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Анкетирование.УстановитьКорневойЭлементДереваАнкеты(ДеревоАнкеты);
	Анкетирование.ЗаполнитьДеревоШаблонаАнкеты(ЭтотОбъект,"ДеревоАнкеты",Объект.Ссылка);
	АнкетированиеКлиентСервер.СформироватьНумерациюДерева(ДеревоАнкеты);
	УстановитьУсловноеОформлениеФормы();
	ОпределитьЕстьЛиДанномуШаблонуАнкеты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Элементы.ФормаДереваАнкеты.Развернуть(ДеревоАнкеты.ПолучитьЭлементы()[0].ПолучитьИдентификатор(),Ложь);
	
	Если Объект.РедактированиеШаблонаЗавершено ИЛИ ПоДанномуШаблонуЕстьАнкеты Тогда
		УстановитьНедоступностьРедактирования();
	Иначе
		ОпределитьДоступностьДереваШаблона();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Анкетирование.УдалитьВопросыШаблонаАнкеты(Объект.Ссылка);
	ДеревоШаблонаАнкеты  = РеквизитФормыВЗначение("ДеревоАнкеты");
	
	ЗаписатьДеревоШаблонаАнкеты(ДеревоШаблонаАнкеты.Строки[0],1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "ОкончаниеРедактированияПараметровТабличногоВопроса" Тогда
		
		ОбработатьРезультатРаботыМастераТабличныхВопросов(ТекущиеДанные,Параметр,Элементы.ФормаДереваАнкеты.ТекущаяСтрока);
		Модифицированность = Истина;
		
	ИначеЕсли ИмяСобытия = "ОкончаниеРедактированияПараметровКомплексногоВопроса" Тогда
		
		ОбработатьРезультатРаботыМастераКомплексныхВопросов(ТекущиеДанные,Параметр,Элементы.ФормаДереваАнкеты.ТекущаяСтрока);
		Модифицированность = Истина;
		
	ИначеЕсли ИмяСобытия = "ОкончаниеРедактированияПараметровСтрокиШаблонаАнкеты" Тогда
		
		ЗаполнитьЗначенияСвойств(ТекущиеДанные,Параметр);
		ТекущиеДанные.ЕстьЗаметки = Не ПустаяСтрока(ТекущиеДанные.Заметки);
		Модифицированность = Истина;
		
		Если ТекущиеДанные.ТипСтроки <> "Вопрос" Тогда
			ТекущиеДанные.Обязательный = Неопределено;
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ОтменаВводаНовойСтрокиШаблонаАнкеты" Тогда
		Если ТекущиеДанные.ЭтоНоваяСтрока Тогда
			ТекущаяСтрока = ДеревоАнкеты.НайтиПоИдентификатору(ТекущиеДанные.ПолучитьИдентификатор());
			Если ТекущаяСтрока <> Неопределено Тогда
				ТекущаяСтрока.ПолучитьРодителя().ПолучитьЭлементы().Удалить(ТекущаяСтрока);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ДеревоШаблонаАнкеты  = РеквизитФормыВЗначение("ДеревоАнкеты");
	
	Если ДеревоШаблонаАнкеты.Строки[0].Строки.Найти("","Формулировка",Истина) <> Неопределено Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не все формулировки или имена разделов заполнены.'"),,"ДеревоАнкеты");
		Отказ = Истина;
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ЭлементарныйВопрос",ПланыВидовХарактеристик.ВопросыДляАнкетирования.ПустаяСсылка());
	СтруктураОтбора.Вставить("ТипСтроки","Вопрос");
	
	НайденныеСтроки = ДеревоШаблонаАнкеты.Строки[0].Строки.НайтиСтроки(СтруктураОтбора,Истина);
	Если НайденныеСтроки.Количество() <> 0 Тогда
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если НайденнаяСтрока.ТипВопроса <> Перечисления.ТипыВопросовШаблонаАнкеты.Табличный
					И НайденнаяСтрока.ТипВопроса <> Перечисления.ТипыВопросовШаблонаАнкеты.Комплексный Тогда
				
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не все вопросы заполнены.'"),,"ДеревоАнкеты");
				Отказ = Истина;
				Прервать;
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОпределитьДоступностьДереваШаблона();
	Если Объект.РедактированиеШаблонаЗавершено Тогда
		ЭтотОбъект.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыФормаДереваАнкеты

&НаКлиенте
Процедура ФормаДереваАнкетыПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ТипСтроки = "Корень" Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если (Строка = Неопределено) ИЛИ (ПараметрыПеретаскивания.Значение = Неопределено) Тогда
		Возврат;
	КонецЕсли;
		
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("Число") Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	СтрокаНазначение     = ДеревоАнкеты.НайтиПоИдентификатору(Строка);
	СтрокаПеретаскивание = ДеревоАнкеты.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	
	Если (СтрокаПеретаскивание.ТипСтроки = "Раздел") И (СтрокаНазначение.ТипСтроки = "Вопрос") Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	ИначеЕсли (СтрокаПеретаскивание.ТипСтроки = "Вопрос") И (СтрокаНазначение.ТипСтроки = "Корень")	Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	ИначеЕсли (СтрокаПеретаскивание.ТипСтроки = "Раздел") И (СтрокаНазначение.ТипСтроки = "Раздел") Тогда
		Если СтрокаПеретаскивание.ВопросШаблона = СтрокаНазначение.ВопросШаблона Тогда
		      ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
			Возврат;
		КонецЕсли;
		Родитель = СтрокаНазначение.ПолучитьРодителя();
		Пока Родитель.ТипСтроки <> "Корень" Цикл
				Если Родитель = СтрокаПеретаскивание Тогда
					ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
					Возврат;
				Иначе
					Родитель = Родитель.ПолучитьРодителя();
				КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если Элементы.ФормаДереваАнкеты.ТолькоПросмотр Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	КонецЕсли; 
	
	СтрокаПеретаскивание = ДеревоАнкеты.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	Если ТипЗнч(СтрокаПеретаскивание) = Тип("Неопределено") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	Иначе
		Если СтрокаПеретаскивание.ТипСтроки = "Корень" Тогда
			СтандартнаяОбработка = Ложь;
			ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтрокаНазначение     = ДеревоАнкеты.НайтиПоИдентификатору(Строка);
	СтрокаПеретаскивание = ДеревоАнкеты.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	
	Если (СтрокаПеретаскивание.ТипСтроки = "Вопрос") И (СтрокаНазначение.ТипСтроки = "Вопрос") Тогда
		
		// Вопрос без условия перетаскиваем на вопрос с условием.
		Если СтрокаПеретаскивание.ТипВопроса <> ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием")
			И СтрокаНазначение.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием") Тогда
			
			СтандартнаяОбработка = Ложь;
			ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Ложь);
			
			Модифицированность = Истина;
			
		ИначеЕсли СтрокаПеретаскивание.ПолучитьРодителя() <> СтрокаНазначение.ПолучитьРодителя() Тогда
			
			СтандартнаяОбработка = Ложь;
			ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Истина);
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	ИначеЕсли (СтрокаПеретаскивание.ТипСтроки = "Вопрос") И (СтрокаНазначение.ТипСтроки = "Раздел") Тогда
		
		Если СтрокаПеретаскивание.ПолучитьРодителя() <> СтрокаНазначение Тогда
			
			СтандартнаяОбработка = Ложь;
			ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Ложь);
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	ИначеЕсли (СтрокаПеретаскивание.ТипСтроки = "Раздел") И (СтрокаНазначение.ТипСтроки = "Раздел") Тогда
		
		Если СтрокаПеретаскивание.ПолучитьРодителя() <> СтрокаНазначение Тогда
			
			СтандартнаяОбработка = Ложь;
			ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Ложь);
			
			Модифицированность = Истина; 
			
		ИначеЕсли СтрокаПеретаскивание.ПолучитьРодителя() <> СтрокаНазначение.ПолучитьРодителя() Тогда
			
			СтандартнаяОбработка = Ложь;
			ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Истина);
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	ИначеЕсли (СтрокаПеретаскивание.ТипСтроки = "Раздел") И (СтрокаНазначение.ТипСтроки = "Вопрос") Тогда
		
		Если (СтрокаПеретаскивание.ПолучитьРодителя() <> СтрокаНазначение.ПолучитьРодителя()) И (СтрокаНазначение.ПолучитьРодителя() <> СтрокаПеретаскивание)Тогда
			
			СтандартнаяОбработка = Ложь;
			ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Истина);
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ((СтрокаПеретаскивание.ТипСтроки = "Раздел") ИЛИ (СтрокаПеретаскивание.ТипСтроки = "Вопрос")) И (СтрокаНазначение.ТипСтроки = "Корень") Тогда
		
		СтандартнаяОбработка = Ложь;
		ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,Ложь);
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыПриИзменении(Элемент)
	
	Модифицированность = Истина;
	АнкетированиеКлиентСервер.СформироватьНумерациюДерева(ДеревоАнкеты);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ТипСтроки = "Корень" Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли ТекущиеДанные.ТипСтроки = "Раздел" 
		ИЛИ (ТекущиеДанные.ТипСтроки = "Вопрос" 
		                               И ТекущиеДанные.ТипВопроса <> ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный")
		                               И ТекущиеДанные.ТипВопроса <> ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Комплексный")) Тогда
		
		ОткрытьФормуПростыхВопросов(ТекущиеДанные);
		
	ИначеЕсли ТекущиеДанные.ТипСтроки = "Вопрос" И ТекущиеДанные.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Комплексный") Тогда
		
		ОткрытьФормуМастераКомплексныхВопросов(ТекущиеДанные);
		
	ИначеЕсли ТекущиеДанные.ТипСтроки = "Вопрос" И ТекущиеДанные.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") Тогда
		
		ОткрытьФормуМастераТабличныхВопросов(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	СписокВыбора = Новый  СписокЗначений;
	СписокВыбора.Добавить(НСтр("ru = 'Раздел'"));
	СписокВыбора.Добавить(НСтр("ru = 'Простой вопрос'"));
	СписокВыбора.Добавить(НСтр("ru = 'Комплексный вопрос'"));
	СписокВыбора.Добавить(НСтр("ru = 'Условный вопрос'"));
	СписокВыбора.Добавить(НСтр("ru = 'Табличный вопрос'"));
	
	ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВыборТипаДобавляемогоЭлементаПриЗавершении", ЭтотОбъект);
	СписокВыбора.ПоказатьВыборЭлемента(ОбработчикОповещенияОЗакрытии, НСтр("ru = 'Выберите тип добавляемого элемента.'"),СписокВыбора[0]);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	АнкетированиеКлиентСервер.СформироватьНумерациюДерева(ДеревоАнкеты);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаДереваАнкетыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ФормаДереваАнкеты.ТолькоПросмотр Тогда
		Возврат;	
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ТипСтроки = "Корень" Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.ТипСтроки = "Раздел" 
		ИЛИ (ТекущиеДанные.ТипСтроки = "Вопрос" И ТекущиеДанные.ТипВопроса <> ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный")
												И ТекущиеДанные.ТипВопроса <> ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Комплексный") ) Тогда
		
		ОткрытьФормуПростыхВопросов(ТекущиеДанные);
		
	ИначеЕсли ТекущиеДанные.ТипСтроки = "Вопрос" И ТекущиеДанные.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Комплексный") Тогда
		
		ОткрытьФормуМастераКомплексныхВопросов(ТекущиеДанные);
		
	ИначеЕсли ТекущиеДанные.ТипСтроки = "Вопрос" И ТекущиеДанные.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") Тогда
		
		ОткрытьФормуМастераТабличныхВопросов(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоАнкетыЗаметкиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ЕстьЗаметки = Не ПустаяСтрока(ТекущиеДанные.ЕстьЗаметки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоАнкетыЗаметкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("РедактированиеЗаметкиПриЗакрытии", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(ОповещениеОЗакрытии, Элемент.ТекстРедактирования, НСтр("ru = 'Заметки'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Устанавливает флаг окончания редактирования шаблона анкеты
// и записывает анкету.
&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Объект.РедактированиеШаблонаЗавершено = Истина;
	Записать();
	
	Если Модифицированность Тогда
		Объект.РедактированиеШаблонаЗавершено = Ложь;
	Иначе
		УстановитьНедоступностьРедактирования();
	КонецЕсли;
	
КонецПроцедуры

// Добавляет раздел в дерево шаблона анкеты.
&НаКлиенте
Процедура ДобавитьРаздел(Команда)
	
	Если Не ЗаписьЕслиНовыйВыполненаУспешно() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Родитель = ПолучитьРодителяДеревоАнкеты(ТекущиеДанные,Истина);
	ДобавитьСтрокуДеревоАнкеты(Родитель,"Раздел");
	
КонецПроцедуры

// Добавляет простой вопрос в дерево шаблона анкеты.
&НаКлиенте
Процедура ДобавитьПростойВопрос(Команда)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьВопрос(ТекущиеДанные,ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Простой"));
	
КонецПроцедуры 

// Добавляет комплексный вопрос в шаблон анкеты.
&НаКлиенте
Процедура ДобавитьКомплексныйВопрос(Команда)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьВопрос(ТекущиеДанные,ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Комплексный"));
	
КонецПроцедуры

// Добавляет вопрос с условием в шаблон анкеты.
&НаКлиенте
Процедура ДобавитьВопросСУсловием(Команда)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьВопрос(ТекущиеДанные,ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием"));
	
КонецПроцедуры

// Добавляет табличный вопрос в шаблон анкеты.
&НаКлиенте
Процедура ДобавитьТабличныйВопрос(Команда)
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьВопрос(ТекущиеДанные,ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный"));
	
КонецПроцедуры 

&НаКлиенте
Процедура ОткрытьФормуЗаполненияАнкеты(Команда)
	
	Если Не ЗаписьЕслиНовыйВыполненаУспешно() Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросОНеобходимостиЗаписиПослеЗавершения", ЭтотОбъект);
		ПоказатьВопрос(ОбработчикОповещенияОЗакрытии,
		               НСтр("ru = 'Шаблон анкеты был модифицирован. 
		                   |Для корректного отображения изменений шаблон необходимо записать.
		                   |Записать?'"),
		               РежимДиалогаВопрос.ДаНет,
		               ,
		               КодВозвратаДиалога.Да,
		               НСтр("ru = 'Записать?'"));
	Иначе
		ОткрытьФормуМастераАнкетыПоРазделам();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоАнкетыОбязательный.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоАнкеты.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru = 'Вопрос'");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СеребристоСерый);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.СеребристоСерый);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоАнкетыОбязательный.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоАнкеты.ТипВопроса");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыВопросовШаблонаАнкеты.Табличный;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СеребристоСерый);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.СеребристоСерый);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоАнкетыФормулировка.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоАнкеты.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru = 'Корень'");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоАнкеты.Формулировка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

КонецПроцедуры

// Добавляет новую строку в дерево формы.
// Родитель   - СтрокаДереваАнкеты - элемент дерева значений формы, от которого отращивается новая ветка.
// ТипСтроки  - Строка - Тип строки дерева.
// Возвращаемое значение:
//   Строка     - новая строка дерева.
//
&НаКлиенте
Функция ДобавитьСтрокуДеревоАнкеты(Родитель,ТипСтроки,ТипВопроса = Неопределено)
	
	ЭлементыДерева = Родитель.ПолучитьЭлементы();
	НоваяСтрока    = ЭлементыДерева.Добавить();
	
	НоваяСтрока.ТипСтроки      = ТипСтроки;
	НоваяСтрока.Обязательный   = Ложь;
	НоваяСтрока.КлючСтроки     = Новый УникальныйИдентификатор;
	НоваяСтрока.ЭтоНоваяСтрока = Истина;
	
	Если ТипСтроки = "Вопрос" Тогда
		
		НоваяСтрока.ТипВопроса         = ТипВопроса;
		НоваяСтрока.КодКартинки        = АнкетированиеКлиентСервер.ПолучитьКодКартинкиШаблонаАнкеты(ЛОЖЬ,ТипВопроса);
		НоваяСтрока.ЭлементарныйВопрос = ?(ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный")
		                                   Или ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Комплексный"),
		                                   "",
		                                   ПредопределенноеЗначение("ПланВидовХарактеристик.ВопросыДляАнкетирования.ПустаяСсылка"));
		НоваяСтрока.Обязательный       = ?(ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный")
		                                   Или ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Комплексный"),"",Ложь);
		
	Иначе
		
		НоваяСтрока.ТипВопроса         = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ПустаяСсылка");
		НоваяСтрока.КодКартинки        = АнкетированиеКлиентСервер.ПолучитьКодКартинкиШаблонаАнкеты(ИСТИНА);
		НоваяСтрока.ЭлементарныйВопрос = "";
		НоваяСтрока.Обязательный       = "";
		
	КонецЕсли;
	
	НоваяСтрока.СпособОтображенияПодсказки = ПредопределенноеЗначение("Перечисление.СпособыОтображенияПодсказок.КонтекстнаяПодсказка");
	
	АнкетированиеКлиентСервер.СформироватьНумерациюДерева(ДеревоАнкеты);
	Элементы.ФормаДереваАнкеты.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	
	Модифицированность = Истина;
	Элементы.ФормаДереваАнкеты.ИзменитьСтроку();
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
Процедура ЗаписатьДеревоШаблонаАнкеты(СтрокаДереваРодитель,УровеньРекурсии,СправочникРодитель = Неопределено)
	
	Счетчик = 0;
	
	// запишем новые
	Для каждого СтрокаДерева Из СтрокаДереваРодитель.Строки Цикл
		
		Счетчик = Счетчик + 1;
		СпрСсылка = ДобавитьЭлементСправочникаВопросШаблонаАнкеты(СтрокаДерева,?(УровеньРекурсии = 1,Счетчик,Неопределено),СправочникРодитель);
		
		Если СтрокаДерева.Строки.Количество() > 0 Тогда
			Если СтрокаДерева.ТипСтроки = "Раздел" Тогда
				ЗаписатьДеревоШаблонаАнкеты(СтрокаДерева,УровеньРекурсии+1,СпрСсылка);
			Иначе
				Для каждого СтрокаПодчиненныйВопрос Из СтрокаДерева.Строки Цикл
					ДобавитьЭлементСправочникаВопросШаблонаАнкеты(СтрокаПодчиненныйВопрос,Неопределено,СправочникРодитель,СпрСсылка);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьЭлементСправочникаВопросШаблонаАнкеты(СтрокаДерева,Код = Неопределено,СправочникРодитель = Неопределено,ВопросРодитель = Неопределено)
	
	Если СтрокаДерева.ТипСтроки = "Раздел" Тогда
		
		СпрОбъект = Справочники.ВопросыШаблонаАнкеты.СоздатьГруппу();
		
	Иначе
		
		СпрОбъект = Справочники.ВопросыШаблонаАнкеты.СоздатьЭлемент();
		СпрОбъект.ТипВопроса                        = СтрокаДерева.ТипВопроса;
		СпрОбъект.ЭлементарныйВопрос                = СтрокаДерева.ЭлементарныйВопрос;
		СпрОбъект.ТипТабличногоВопроса              = СтрокаДерева.ТипТабличногоВопроса;
		СпрОбъект.Обязательный                      = СтрокаДерева.Обязательный;
		СпрОбъект.Подсказка                         = СтрокаДерева.Подсказка;
		СпрОбъект.СпособОтображенияПодсказки        = СтрокаДерева.СпособОтображенияПодсказки;
		СпрОбъект.РодительВопрос                    = ?(ВопросРодитель = Неопределено, Справочники.ВопросыШаблонаАнкеты.ПустаяСсылка(),ВопросРодитель);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(СтрокаДерева.СоставТабличногоВопроса,СпрОбъект.СоставТабличногоВопроса);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(СтрокаДерева.ПредопределенныеОтветы,СпрОбъект.ПредопределенныеОтветы);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(СтрокаДерева.СоставКомплексногоВопроса,СпрОбъект.СоставКомплексногоВопроса);
		
	КонецЕсли;
	
	Если Код <> Неопределено Тогда
		СпрОбъект.Код = Код;
	КонецЕсли;
	СпрОбъект.Наименование = СтрокаДерева.Формулировка;
	СпрОбъект.Заметки      = СтрокаДерева.Заметки;
	СпрОбъект.Формулировка = СтрокаДерева.Формулировка;
	СпрОбъект.Родитель     = ?(СправочникРодитель = Неопределено,Справочники.ВопросыШаблонаАнкеты.ПустаяСсылка(),СправочникРодитель);
	СпрОбъект.Владелец    = Объект.Ссылка;
	
	СпрОбъект.Записать();
	
	Возврат СпрОбъект.Ссылка;
	
КонецФункции

// Обрабатывает результат работы мастера табличных вопросов.
//
// Параметры:
//  ТекущиеДанные -ДанныеФормыЭлементДерева - текущая данные дерева шаблона.
//  Параметр  - Структура - результаты работы формы мастера табличного вопроса.
//
&НаКлиенте
Процедура ОбработатьРезультатРаботыМастераТабличныхВопросов(ТекущиеДанные,Параметр,ТекущаяСтрока)
	
	ТекущиеДанные.СоставТабличногоВопроса.Очистить();
	ТекущиеДанные.ПредопределенныеОтветы.Очистить();
	
	ТекущиеДанные.ТипТабличногоВопроса       = Параметр.ТипТабличногоВопроса;
	ТекущиеДанные.Наименование               = Параметр.Формулировка;
	ТекущиеДанные.Формулировка               = Параметр.Формулировка;
	ТекущиеДанные.ЭлементарныйВопрос         = Параметр.Формулировка;
	ТекущиеДанные.Обязательный               = "";
	ТекущиеДанные.Подсказка                  = Параметр.Подсказка;
	ТекущиеДанные.СпособОтображенияПодсказки = Параметр.СпособОтображенияПодсказки;
	ТекущиеДанные.ЭтоНоваяСтрока             = Ложь;
	
	НомерСтроки = 1;
	Для каждого Вопрос Из Параметр.Вопросы Цикл
	
		НоваяСтрока = ТекущиеДанные.СоставТабличногоВопроса.Добавить();
		НоваяСтрока.ЭлементарныйВопрос = Вопрос;
		НоваяСтрока.НомерСтроки        = НомерСтроки;
		
		НомерСтроки = НомерСтроки + 1;
	
	КонецЦикла;
	
	Для каждого Ответ Из Параметр.Ответы Цикл
		ЗаполнитьЗначенияСвойств(ТекущиеДанные.ПредопределенныеОтветы.Добавить(),Ответ);
	КонецЦикла;
	
	УстановитьУсловноеОформлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатРаботыМастераКомплексныхВопросов(ТекущиеДанные,Параметр,ТекущаяСтрока)
	
	ТекущиеДанные.СоставКомплексногоВопроса.Очистить();
	
	ТекущиеДанные.Наименование               = Параметр.Формулировка;
	ТекущиеДанные.Формулировка               = Параметр.Формулировка;
	ТекущиеДанные.ЭлементарныйВопрос         = Параметр.Формулировка;
	ТекущиеДанные.Обязательный               = "";
	ТекущиеДанные.Подсказка                  = Параметр.Подсказка;
	ТекущиеДанные.СпособОтображенияПодсказки = Параметр.СпособОтображенияПодсказки;
	ТекущиеДанные.ЭтоНоваяСтрока             = Ложь;
	
	НомерСтроки = 1;
	Для каждого Вопрос Из Параметр.Вопросы Цикл
	
		НоваяСтрока = ТекущиеДанные.СоставКомплексногоВопроса.Добавить();
		НоваяСтрока.ЭлементарныйВопрос = Вопрос;
		НоваяСтрока.НомерСтроки        = НомерСтроки;
		
		НомерСтроки = НомерСтроки + 1;
	
	КонецЦикла;
	
	УстановитьУсловноеОформлениеФормы();
	
КонецПроцедуры

// Устанавливает условное оформление формы.
&НаСервере
Процедура УстановитьУсловноеОформлениеФормы();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоАнкеты.ТипСтроки");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОтбораДанных.ПравоеЗначение = "Вопрос";
	
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Использование = Истина;
	ПолеОформления.Поле          = Новый ПолеКомпоновкиДанных("ДеревоАнкетыОбязательный");
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона",WebЦвета.СеребристоСерый);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьЕстьЛиДанномуШаблонуАнкеты()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Анкета.Ссылка
	|ИЗ
	|	Документ.Анкета КАК Анкета
	|ГДЕ
	|	(НЕ Анкета.ПометкаУдаления)
	|	И Анкета.Опрос В
	|			(ВЫБРАТЬ
	|				НазначениеОпросов.Ссылка
	|			ИЗ
	|				Документ.НазначениеОпросов КАК НазначениеОпросов
	|			ГДЕ
	|				НазначениеОпросов.ШаблонАнкеты = &ШаблонАнкеты)";
	
	Запрос.УстановитьПараметр("ШаблонАнкеты",Объект.Ссылка);
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		
		ПоДанномуШаблонуЕстьАнкеты = Истина;
		
	Иначе
		
		ПоДанномуШаблонуЕстьАнкеты = Ложь;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьРодителяДеревоАнкеты(ТекущийРодитель,МожетБытьКорнем,ТипВопроса = Неопределено)
	
	Если МожетБытьКорнем Тогда
		
		Пока (ТекущийРодитель.ТипСтроки <> "Корень") И (ТекущийРодитель.ТипСтроки <> "Раздел") Цикл
			ТекущийРодитель = ТекущийРодитель.ПолучитьРодителя();
			Если ТекущийРодитель = Неопределено Тогда
				Возврат ДеревоАнкеты.ПолучитьЭлементы()[0];
			КонецЕсли;
		КонецЦикла;
		
	Иначе 
		
		Пока (ТекущийРодитель.ТипСтроки <> "Раздел")
			И ((ТекущийРодитель.ТипСтроки = "Вопрос") И (НЕ ТекущийРодитель.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием"))
			ИЛИ (ТекущийРодитель.ТипСтроки = "Вопрос" И  ТекущийРодитель.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием") И ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием"))) Цикл
			
			ТекущийРодитель = ТекущийРодитель.ПолучитьРодителя();
			
		КонецЦикла
		
	КонецЕсли;
	
	Возврат ТекущийРодитель;
	
КонецФункции

// Добавляет вопрос в шаблон анкеты.
//
// Параметры:
//  ТекущиеДанные - ДанныеФормыЭлементДерева - данные текущей строки дерева.
//  ТипВопроса    - Перечисления.ТипыВопросовШаблонаАнкет - тип добавляемого вопроса.
//
&НаКлиенте
Процедура ДобавитьВопрос(ТекущиеДанные,ТипВопроса)

	Родитель = ПолучитьРодителяДеревоАнкеты(ТекущиеДанные,Ложь,ТипВопроса);
	Если Родитель.ТипСтроки = "Корень" Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Вопросы нельзя добавлять в корень анкеты.'"),15,НСтр("ru = 'Ошибка добавления'"));
		Возврат;
	КонецЕсли;
	ДобавитьСтрокуДеревоАнкеты(Родитель,"Вопрос",ТипВопроса);

КонецПроцедуры

&НаКлиенте
Процедура ОпределитьДоступностьДереваШаблона()
	
	НедоступностьРедактирования   = Объект.РедактированиеШаблонаЗавершено ИЛИ ПоДанномуШаблонуЕстьАнкеты;
	
	Элементы.ДеревоАнкеты.ТолькоПросмотр                                      = НедоступностьРедактирования;
	Элементы.ФормаДереваАнкеты.ТолькоПросмотр                                 = НедоступностьРедактирования;
	Элементы.ЗакончитьРедактирование.Доступность                              = НЕ НедоступностьРедактирования;
	Элементы.ФормаДереваАнкеты.КоманднаяПанель.Доступность                    = НЕ НедоступностьРедактирования;
	Элементы.ФормаДереваАнкеты.КонтекстноеМеню.Доступность                    = НЕ НедоступностьРедактирования;
	Элементы.КонтекстноеМенюФормаДереваАнкетыДобавить.Доступность             = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьРаздел.Доступность            = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюПереместитьВверх.Доступность          = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюПереместитьВниз.Доступность           = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьВопрос.Доступность            = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьВопросСУсловием.Доступность   = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьТабличныйВопрос.Доступность   = НЕ НедоступностьРедактирования;
	Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьКомплексныйВопрос.Доступность = НЕ НедоступностьРедактирования;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНедоступностьРедактирования()
	
	Если Объект.РедактированиеШаблонаЗавершено ИЛИ ПоДанномуШаблонуЕстьАнкеты Тогда
		
		ЭтотОбъект.ТолькоПросмотр                                                 = Истина;
		Элементы.ДеревоАнкеты.ТолькоПросмотр                                      = Истина;
		Элементы.ФормаДереваАнкеты.ТолькоПросмотр                                 = Истина;
		Элементы.ФормаДереваАнкеты.КоманднаяПанель.Доступность                    = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьРаздел.Доступность            = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюПереместитьВверх.Доступность          = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюПереместитьВниз.Доступность           = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьВопрос.Доступность            = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьВопросСУсловием.Доступность   = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьТабличныйВопрос.Доступность   = Ложь;
		Элементы.ДеревоАнкетыКонтекстноеМенюДобавитьКомплексныйВопрос.Доступность = Ложь;
		Элементы.ЗакончитьРедактирование.Доступность                              = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПростыхВопросов(ТекущиеДанные)
	
	ПростойВопрос = Новый Структура;
	ПростойВопрос.Вставить("ТипСтрокиДерева", ТекущиеДанные.ТипСтроки);
	ПростойВопрос.Вставить("ЭлементарныйВопрос", ТекущиеДанные.ЭлементарныйВопрос);
	ПростойВопрос.Вставить("Обязательный", ТекущиеДанные.Обязательный);
	ПростойВопрос.Вставить("ТипВопроса", ТекущиеДанные.ТипВопроса);
	ПростойВопрос.Вставить("Формулировка", ТекущиеДанные.Формулировка);
	ПростойВопрос.Вставить("ЗакрыватьПриВыборе", Истина);
	ПростойВопрос.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ПростойВопрос.Вставить("ТолькоПросмотр", Ложь);
	ПростойВопрос.Вставить("Заметки", ТекущиеДанные.Заметки);
	ПростойВопрос.Вставить("ЭтоНоваяСтрока", ТекущиеДанные.ЭтоНоваяСтрока);
	ПростойВопрос.Вставить("Подсказка", ТекущиеДанные.Подсказка);
	ПростойВопрос.Вставить("СпособОтображенияПодсказки", ТекущиеДанные.СпособОтображенияПодсказки);
	
	ОткрытьФорму("Справочник.ШаблоныАнкет.Форма.ФормаПростыхВопросов", ПростойВопрос, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуМастераКомплексныхВопросов(ТекущиеДанные)
	
	КомплексныйВопрос = Новый Структура;
	КомплексныйВопрос.Вставить("СоставКомплексногоВопроса", ТекущиеДанные.СоставКомплексногоВопроса);
	КомплексныйВопрос.Вставить("Формулировка" ,ТекущиеДанные.Формулировка);
	КомплексныйВопрос.Вставить("Подсказка", ТекущиеДанные.Подсказка);
	КомплексныйВопрос.Вставить("СпособОтображенияПодсказки", ТекущиеДанные.СпособОтображенияПодсказки);
	КомплексныйВопрос.Вставить("ЭтоНоваяСтрока",             ТекущиеДанные.ЭтоНоваяСтрока);
	
	ОткрытьФорму("Справочник.ШаблоныАнкет.Форма.ФормаМастераКомплексныхВопросов", КомплексныйВопрос, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуМастераТабличныхВопросов(ТекущиеДанные)
	
	ТабличныйВопрос = Новый Структура;
	ТабличныйВопрос.Вставить("ТипТабличногоВопроса",       ТекущиеДанные.ТипТабличногоВопроса);
	ТабличныйВопрос.Вставить("СоставТабличногоВопроса",    ТекущиеДанные.СоставТабличногоВопроса);
	ТабличныйВопрос.Вставить("ПредопределенныеОтветы",     ТекущиеДанные.ПредопределенныеОтветы);
	ТабличныйВопрос.Вставить("Формулировка",               ТекущиеДанные.Формулировка);
	ТабличныйВопрос.Вставить("Подсказка",                  ТекущиеДанные.Подсказка);
	ТабличныйВопрос.Вставить("СпособОтображенияПодсказки", ТекущиеДанные.СпособОтображенияПодсказки);
	ТабличныйВопрос.Вставить("ЭтоНоваяСтрока",             ТекущиеДанные.ЭтоНоваяСтрока);
	
	ОткрытьФорму("Справочник.ШаблоныАнкет.Форма.ФормаМастераТабличныхВопросов", ТабличныйВопрос, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеретащитьЭлементДерева(СтрокаНазначение,СтрокаПеретаскивание,ИспользоватьРодителяСтрокиНазначения = ЛОЖЬ,УдалятьПослеДобавления = Истина);
	
	Если ИспользоватьРодителяСтрокиНазначения Тогда
		НоваяСтрока = СтрокаНазначение.ПолучитьРодителя().ПолучитьЭлементы().Добавить();
	Иначе
		НоваяСтрока = СтрокаНазначение.ПолучитьЭлементы().Добавить();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаПеретаскивание,,"СоставТабличногоВопроса,ПредопределенныеОтветы, СоставКомплексногоВопроса");
	Если СтрокаПеретаскивание.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(СтрокаПеретаскивание.СоставТабличногоВопроса,НоваяСтрока.СоставТабличногоВопроса);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(СтрокаПеретаскивание.ПредопределенныеОтветы,НоваяСтрока.ПредопределенныеОтветы);
	КонецЕсли;
	
	Если СтрокаПеретаскивание.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Комплексный") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(СтрокаПеретаскивание.СоставКомплексногоВопроса,НоваяСтрока.СоставКомплексногоВопроса);
	КонецЕсли;
	
	Для каждого Элемент Из СтрокаПеретаскивание.ПолучитьЭлементы() Цикл
		ПеретащитьЭлементДерева(НоваяСтрока,Элемент,Ложь,Ложь);
	КонецЦикла;
	
	Если УдалятьПослеДобавления Тогда
		СтрокаПеретаскивание.ПолучитьРодителя().ПолучитьЭлементы().Удалить(СтрокаПеретаскивание);
	КонецЕсли;
	
	Если ИспользоватьРодителяСтрокиНазначения Тогда
		Элементы.ФормаДереваАнкеты.Развернуть(СтрокаНазначение.ПолучитьРодителя().ПолучитьИдентификатор(),Ложь);
	Иначе	
		Элементы.ФормаДереваАнкеты.Развернуть(СтрокаНазначение.ПолучитьИдентификатор(),Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборТипаДобавляемогоЭлементаПриЗавершении(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если НЕ ВыбранныйЭлемент = Неопределено Тогда
		
		Если ВыбранныйЭлемент.Значение = НСтр("ru = 'Раздел'") Тогда
			
			ДобавитьРаздел(Команды.ДобавитьРаздел);
			
		ИначеЕсли ВыбранныйЭлемент.Значение = НСтр("ru = 'Простой вопрос'") Тогда
			
			ДобавитьПростойВопрос(Команды.ДобавитьПростойВопрос)
			
		ИначеЕсли ВыбранныйЭлемент.Значение = НСтр("ru = 'Комплексный вопрос'") Тогда
			
			ДобавитьКомплексныйВопрос(Команды.ДобавитьПростойВопрос)
			
		ИначеЕсли ВыбранныйЭлемент.Значение = НСтр("ru = 'Условный вопрос'") Тогда
			
			ДобавитьВопросСУсловием(Команды.ДобавитьВопросСУсловием)
			
		ИначеЕсли ВыбранныйЭлемент.Значение = НСтр("ru = 'Табличный вопрос'") Тогда
			
			ДобавитьТабличныйВопрос(Команды.ДобавитьТабличныйВопрос);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросОНеобходимостиЗаписиПослеЗавершения(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
			Записать();
	КонецЕсли;
	
	ОткрытьФормуМастераАнкетыПоРазделам();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуМастераАнкетыПоРазделам()

	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("ШаблонАнкеты",Объект.Ссылка);
	ОткрытьФорму("ОбщаяФорма.МастерАнкетыПоРазделам",СтруктураПараметры,ЭтотОбъект);

КонецПроцедуры 

&НаКлиенте
Процедура РедактированиеЗаметкиПриЗакрытии(ТекстВозврата, ДополнительныеПараметры) Экспорт
	
	ТекущиеДанные = Элементы.ФормаДереваАнкеты.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Если ТекущиеДанные.Заметки <> ТекстВозврата Тогда
			ТекущиеДанные.Заметки = ТекстВозврата;
			ТекущиеДанные.ЕстьЗаметки = Не ПустаяСтрока(ТекущиеДанные.Заметки);
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаписьНаСервереВыполненаУспешно()

	Если Не ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	Иначе
		Записать();
		Возврат Истина;
	КонецЕсли;

КонецФункции

&НаКлиенте
Функция ЗаписьЕслиНовыйВыполненаУспешно()

	Если Объект.Ссылка.Пустая() Тогда
		
		ОчиститьСообщения();
		Возврат ЗаписьНаСервереВыполненаУспешно();
		
	Иначе
		
		Возврат Истина;
		
	КонецЕсли;

КонецФункции

#КонецОбласти
