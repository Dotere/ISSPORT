
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТипРезультата") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,"ТипРезультата",Параметры.ТипРезультата,ВидСравненияКомпоновкиДанных.Равно,,Истина);
	КонецЕсли;	
	
КонецПроцедуры
