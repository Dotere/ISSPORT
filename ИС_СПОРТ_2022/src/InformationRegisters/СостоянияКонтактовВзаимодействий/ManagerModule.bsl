///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Удаляет либо одну, либо все записи из регистра.
//
// Параметры:
//  Контакт  - СправочникСсылка, Неопределено - контакт, для которого удаляется запись.
//             Если указано значение Неопределено, то регистр будет очищен полностью.
//
Процедура УдалитьЗаписьИзРегистра(Контакт = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Если Контакт <> Неопределено Тогда
		НаборЗаписей.Отбор.Контакт.Установить(Контакт);
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Выполняет запись в регистр сведений для указанного предмета.
//
// Параметры:
//  Контакт  - СправочникСсылка - контакт, для которого выполняется запись.
//  КоличествоНеРассмотрено       - Число - количество не рассмотренных взаимодействий для контакта.
//  ДатаПоследнегоВзаимодействия  - ДатаВремя - дата последнего взаимодействия по контакту.
//
Процедура ВыполнитьЗаписьВРегистр(Контакт, КоличествоНеРассмотрено = Неопределено,
	ДатаПоследнегоВзаимодействия = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если КоличествоНеРассмотрено = Неопределено И ДатаПоследнегоВзаимодействия = Неопределено Тогда
		
		Возврат;
		
	ИначеЕсли КоличествоНеРассмотрено = Неопределено ИЛИ ДатаПоследнегоВзаимодействия = Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СостоянияКонтактовВзаимодействий.Контакт,
		|	СостоянияКонтактовВзаимодействий.КоличествоНеРассмотрено,
		|	СостоянияКонтактовВзаимодействий.ДатаПоследнегоВзаимодействия
		|ИЗ
		|	РегистрСведений.СостоянияКонтактовВзаимодействий КАК СостоянияКонтактовВзаимодействий
		|ГДЕ
		|	СостоянияКонтактовВзаимодействий.Контакт = &Контакт";
		
		Запрос.УстановитьПараметр("Контакт", Контакт);
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			Если КоличествоНеРассмотрено = Неопределено Тогда
				КоличествоНеРассмотрено = Выборка.КоличествоНеРассмотрено;
			КонецЕсли;
			
			Если ДатаПоследнегоВзаимодействия = Неопределено Тогда
				ДатаПоследнегоВзаимодействия = ДатаПоследнегоВзаимодействия.Предмет;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;

	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Контакт.Установить(Контакт);
	
	Запись = НаборЗаписей.Добавить();
	Запись.Контакт                      = Контакт;
	Запись.КоличествоНеРассмотрено      = КоличествоНеРассмотрено;
	Запись.ДатаПоследнегоВзаимодействия = ДатаПоследнегоВзаимодействия;
	НаборЗаписей.Записать();

КонецПроцедуры

// Блокирует РС СостоянияКонтактовВзаимодействий.
// 
// Параметры:
//  Блокировка       - БлокировкаДанных - устанавливаемая блокировка.
//  ИсточникДанных   - ТаблицаЗначений - источник данных для блокировки.
//  ИмяПолеИсточника - Строка - имя поля источника, которое будет использовано для установки блокировки по контакту.
//
Процедура ЗаблокироватьСостоянияКонтактовВзаимодействий(Блокировка, ИсточникДанных, ИмяПолеИсточника) Экспорт
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СостоянияКонтактовВзаимодействий"); 
	ЭлементБлокировки.ИсточникДанных = ИсточникДанных;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Контакт", ИмяПолеИсточника);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли