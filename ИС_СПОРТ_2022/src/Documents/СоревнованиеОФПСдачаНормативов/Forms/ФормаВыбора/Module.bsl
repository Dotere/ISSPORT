#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТипСоревнования") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ТипСоревнования", Параметры.ТипСоревнования, ВидСравненияКомпоновкиДанных.Равно,,Истина);
		ТипСоревнования = Параметры.ТипСоревнования;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроведениеСоревнованийФормыКлиент.СформироватьЗаголовокФормыСписка(ЭтаФорма, "ЗаявкаНаПроведениеСоревнованияСдачаНормативаОФП", ТипСоревнования);
	
КонецПроцедуры

#КонецОбласти