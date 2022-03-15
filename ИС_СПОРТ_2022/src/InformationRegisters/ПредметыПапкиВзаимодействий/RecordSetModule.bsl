///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Взаимодействия.РассчитыватьРассмотрено(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("СтруктураЗаписи", СтруктураЗаписи());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Взаимодействия.РассчитыватьРассмотрено(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	СтараяЗапись     = ДополнительныеСвойства.СтруктураЗаписи;
	НоваяЗапись      = СтруктураЗаписи();
	ДанныеДляРасчета = Новый Структура("НоваяЗапись, СтараяЗапись", НоваяЗапись, СтараяЗапись);
	
	Если НоваяЗапись.Рассмотрено <> СтараяЗапись.Рассмотрено Тогда
		
		Взаимодействия.РассчитатьРассмотреноПоПапкам(Взаимодействия.ТаблицаДанныхДляРасчетаРассмотрено(ДанныеДляРасчета, "Папка"));
		Взаимодействия.РассчитатьРассмотреноПоПредметам(Взаимодействия.ТаблицаДанныхДляРасчетаРассмотрено(ДанныеДляРасчета, "Предмет"));
		
		Возврат;

	КонецЕсли;
	
	Если НоваяЗапись.Папка <> СтараяЗапись.Папка Тогда
		
		Взаимодействия.РассчитатьРассмотреноПоПапкам(Взаимодействия.ТаблицаДанныхДляРасчетаРассмотрено(ДанныеДляРасчета, "Папка"));
		
		Возврат;
		
	КонецЕсли;
	
	Если НоваяЗапись.Предмет <> СтараяЗапись.Предмет Тогда
		
		Взаимодействия.РассчитатьРассмотреноПоПредметам(Взаимодействия.ТаблицаДанныхДляРасчетаРассмотрено(ДанныеДляРасчета, "Предмет"));
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураЗаписи()

	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Предмет", Неопределено);
	СтруктураВозврата.Вставить("Папка", Справочники.ПапкиЭлектронныхПисем.ПустаяСсылка());
	СтруктураВозврата.Вставить("Рассмотрено", Неопределено);
	
	Если Отбор.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПредметыПапкиВзаимодействий.Предмет,
	|	ПредметыПапкиВзаимодействий.ПапкаЭлектронногоПисьма КАК Папка,
	|	ПредметыПапкиВзаимодействий.Рассмотрено
	|ИЗ
	|	РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|ГДЕ
	|	ПредметыПапкиВзаимодействий.Взаимодействие = &Взаимодействие";
	
	Запрос.УстановитьПараметр("Взаимодействие", Отбор.Взаимодействие.Значение);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(СтруктураВозврата, Выборка);
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли