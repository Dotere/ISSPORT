#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьВидимостьДоступностьНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийРеквизитовФормы

&НаКлиенте
Процедура КоличествоПопытокПриИзменении(Элемент)
	
	ИзменитьВидимостьДоступностьНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьВидимостьДоступностьНаКлиенте()
	
	Элементы.ТипПодсчетаРезультатаПопыток.Доступность = Запись.КоличествоПопыток>1;
	
КонецПроцедуры	

#КонецОбласти





