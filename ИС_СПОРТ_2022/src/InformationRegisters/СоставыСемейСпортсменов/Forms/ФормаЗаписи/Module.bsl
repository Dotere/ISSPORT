
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Спортсмен") Тогда
		Запись.Спортсмен = Параметры.Спортсмен;
		Элементы.Спортсмен.ТолькоПросмотр = Истина;
	КонецЕсли;
	Для Каждого Команда Из ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы Цикл
		Если НЕ Команда.Имя = "ФормаЗаписатьИЗакрыть"  Тогда
			Команда.Видимость = Ложь;
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере()
	НаборЗаписей = РегистрыСведений.СоставыСемейСпортсменов.СоздатьНаборЗаписей();
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Период = ТекущаяДата();
	НоваяЗапись.Спортсмен = Запись.Спортсмен;
	НоваяЗапись.Родитель = Запись.Родитель;
	НоваяЗапись.СтепеньРодства = Запись.СтепеньРодства;
	НаборЗаписей.Записать(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ЗаписатьИЗакрытьНаСервере();
	ЭтаФорма.Модифицированность = Ложь;
	ЭтаФорма.Закрыть(Запись.Родитель);
КонецПроцедуры




