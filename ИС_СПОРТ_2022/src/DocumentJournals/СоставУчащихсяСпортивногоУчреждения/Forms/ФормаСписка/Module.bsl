

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Спортсмен") Тогда
		ТекущийСпортсмен = Параметры.Спортсмен;
		УстановитьОтборПоСпортсменуНаСервере();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ Копирование И ЗначениеЗаполнено(ТекущийСпортсмен) Тогда
		Отказ = Истина;
		Оповещение = Новый ОписаниеОповещения("СписокПередНачаломДобавленияЗавершение", ЭтотОбъект);
		Если Параметр = Тип("ДокументСсылка.ЗаявленияНаПриемВСпортивноеУчреждение") Тогда
			ОткрытьФорму("Документ.ЗаявленияНаПриемВСпортивноеУчреждение.Форма.ФормаДокумента", Новый Структура("Спортсмен", ТекущийСпортсмен),,,,,Оповещение);
		Иначе
			ОткрытьФорму("Документ.ИсключениеИзСпортивногоУчреждения.Форма.ФормаДокумента", Новый Структура("Спортсмен", ТекущийСпортсмен),,,,,Оповещение);
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборПоСпортсменуНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Спортсмен", ТекущийСпортсмен, ВидСравненияКомпоновкиДанных.Равно);
	
КонецПроцедуры	

&НаКлиенте
Процедура СписокПередНачаломДобавленияЗавершение(Результат, ДопПараметры) Экспорт
	
	УстановитьОтборПоСпортсменуНаСервере();
	ЭтаФорма.ОбновитьОтображениеДанных();
	
КонецПроцедуры

#КонецОбласти