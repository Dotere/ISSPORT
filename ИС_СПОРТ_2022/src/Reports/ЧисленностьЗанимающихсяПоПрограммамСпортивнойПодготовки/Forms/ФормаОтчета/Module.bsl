&НаСервере
Процедура ПередЗагрузкойПользовательскихНастроекНаСервере(Настройки, ИспользуютсяСтандартныеНастройки)
	Настройки.Элементы[0].Значение = КонецГода(ТекущаяДатаСеанса());
КонецПроцедуры


&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	СтандартнаяОбработка = Ложь;
	РезультатСтруктура = РаботаемСРасшифровкойНаСервере(Расшифровка);
	РезультатСтруктура.Вставить("Период", ПолучениеПараметровОтчета());
	ОткрытьФорму("Отчет.ЧисленностьЗанимающихсяПоПрограммамСпортивнойПодготовки.Форма.ФормаРасшифровки", РезультатСтруктура, ЭтаФорма)
КонецПроцедуры

&НаСервере
Функция РаботаемСРасшифровкойНаСервере(Расшифровка)
	
	РезультатСтруктура = Новый Структура;
	Данные = ПолучитьИзВременногоХранилища(ДанныеРасшифровки); 
	Поля = Данные.Элементы.Получить(Расшифровка).ПолучитьПоля();
	Проход = 0;
	Пока Проход < Поля.Количество() Цикл
		Если Поля[Проход].Поле = "ВидСпорта" Тогда
			 РезультатСтруктура.Вставить("ВидСпорта", Поля[Проход].Значение);
		Иначе 
			 РезультатСтруктура.Вставить(Поля[Проход].Поле,1);
		КонецЕсли;				 
		Проход = Проход + 1;
	КонецЦикла;
	Возврат РезультатСтруктура;                        
КонецФункции

&НаСервере
Функция ПолучениеПараметровОтчета()
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	
	Возврат ОтчетОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение;
		
КонецФункции
