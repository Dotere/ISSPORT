///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбновитьКонтрольнуюСуммуМакетов(Параметры) Экспорт
	
	ВерсияМакета = Метаданные.Версия;
	
	Если Параметры.Свойство("МакетыТребующиеОбновленияКонтрольнойСуммы") Тогда
		ОбрабатываемыеМакеты = Параметры.МакетыТребующиеОбновленияКонтрольнойСуммы;
	Иначе
		ОбрабатываемыеМакеты = МакетыПечатныхФормРасширений();
	КонецЕсли;
	
	МакетыТребующиеОбновленияКонтрольнойСуммы = Новый Соответствие;
	СписокОшибок = Новый Массив;
	
	Для Каждого ОписаниеМакета Из ОбрабатываемыеМакеты Цикл
		Владелец = ОписаниеМакета.Значение;
		ИмяВладельца = ?(Владелец = Метаданные.ОбщиеМакеты, "ОбщийМакет", Владелец.ПолноеИмя());
		ИдентификаторОбъектаМетаданныхВладельца = 
			?(Владелец = Метаданные.ОбщиеМакеты, Справочники.ИдентификаторыОбъектовРасширений.ПустаяСсылка(), ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Владелец));
		Макет = ОписаниеМакета.Ключ;
		ИмяМакета = Макет.Имя;
		
		Если Владелец = Метаданные.ОбщиеМакеты Тогда
			ДанныеМакета = ПолучитьОбщийМакет(Макет);
		Иначе
			УстановитьОтключениеБезопасногоРежима(Истина);
			УстановитьПривилегированныйРежим(Истина);
			
			ДанныеМакета = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Владелец.ПолноеИмя()).ПолучитьМакет(Макет);
			
			УстановитьПривилегированныйРежим(Ложь);
			УстановитьОтключениеБезопасногоРежима(Ложь);
		КонецЕсли;
		
		КонтрольнаяСумма = ОбщегоНазначения.КонтрольнаяСуммаСтрокой(ДанныеМакета);
		
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить(Метаданные.РегистрыСведений.ПоставляемыеМакетыПечати.ПолноеИмя());
		ЭлементБлокировкиДанных.УстановитьЗначение("ИмяМакета", ИмяМакета);
		ЭлементБлокировкиДанных.УстановитьЗначение("Объект", ИдентификаторОбъектаМетаданныхВладельца);
		
		НачатьТранзакцию();
		Попытка
			БлокировкаДанных.Заблокировать();
			
			МенеджерЗаписи = РегистрыСведений.ПоставляемыеМакетыПечати.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ИмяМакета = Макет.Имя;
			МенеджерЗаписи.Объект = ИдентификаторОбъектаМетаданныхВладельца;
			МенеджерЗаписи.Прочитать();
		
			Если Не МенеджерЗаписи.Выбран() Тогда
				МенеджерЗаписи.ИмяМакета = Макет.Имя;
				МенеджерЗаписи.Объект = ИдентификаторОбъектаМетаданныхВладельца;
			КонецЕсли;
			
			Если МенеджерЗаписи.ВерсияМакета = ВерсияМакета Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			МенеджерЗаписи.ВерсияМакета = ВерсияМакета;
			МенеджерЗаписи.ПредыдущаяКонтрольнаяСумма = МенеджерЗаписи.КонтрольнаяСумма;
			МенеджерЗаписи.КонтрольнаяСумма = КонтрольнаяСумма;
			МенеджерЗаписи.Записать();
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			
			ТекстОшибки = НСтр("ru = 'Не удалось записать сведения о макете'") + Символы.ПС
				+ Макет.ПолноеИмя() + Символы.ПС
				+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Контроль изменения поставляемых макетов'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, Макет, , ТекстОшибки);
			
			СписокОшибок.Добавить(ИмяВладельца + "." + ИмяМакета + ": " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			МакетыТребующиеОбновленияКонтрольнойСуммы.Вставить(ОписаниеМакета.Ключ, ОписаниеМакета.Значение);
		КонецПопытки;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(МакетыТребующиеОбновленияКонтрольнойСуммы) Тогда
		СписокОшибок.Вставить(0, НСтр("ru = 'Не удалось записать сведения о макетах печатных форм расширений:'"));
		Параметры.Вставить("МакетыТребующиеОбновленияКонтрольнойСуммы", МакетыТребующиеОбновленияКонтрольнойСуммы);
		ТекстОшибки = СтрСоединить(СписокОшибок, Символы.ПС);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция МакетыПечатныхФормРасширений()
	
	Результат = Новый Соответствие;
	
	Для Каждого Макет Из УправлениеПечатью.МакетыПечатныхФорм() Цикл
		Если Макет.Ключ.РасширениеКонфигурации() = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Результат.Вставить(Макет.Ключ, Макет.Значение);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли