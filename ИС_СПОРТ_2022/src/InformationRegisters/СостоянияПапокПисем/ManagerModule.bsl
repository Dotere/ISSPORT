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
//  Папка  - Справочник.ПапкиЭлектронныхПисем, Неопределено - папка, для которой удаляется запись.
//          Если указано значение Неопределено, то регистр будет очищен полностью.
//
Процедура УдалитьЗаписьИзРегистра(Папка = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Если Папка <> Неопределено Тогда
		НаборЗаписей.Отбор.Папка.Установить(Папка);
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Выполняет запись в регистр сведений для указанной папки.
//
// Параметры:
//  Папка  - Справочник.ПапкиЭлектронныхПисем - папка, для которой выполняется запись.
//  Количество  - Число - количество не рассмотренных взаимодействий для этой папки.
//
Процедура ВыполнитьЗаписьВРегистр(Папка, Количество) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.Папка = Папка;
	Запись.КоличествоНеРассмотрено = Количество;
	Запись.Записать(Истина);

КонецПроцедуры

// Блокирует РС СостоянияПапокПисем.
// 
// Параметры:
//  Блокировка       - БлокировкаДанных - устанавливаемая блокировка.
//  ИсточникДанных   - ТаблицаЗначений - источник данных для блокировки.
//  ИмяПолеИсточника - Строка - имя поля источника, которое будет использовано для установки блокировки по папке.
//
Процедура ЗаблокироватьСостоянияПапокПисем(Блокировка, ИсточникДанных, ИмяПолеИсточника) Экспорт
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СостоянияПапокПисем"); 
	ЭлементБлокировки.ИсточникДанных = ИсточникДанных;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Папка", ИмяПолеИсточника);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли