
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СхемаКомпоновкиДанных = Отчеты.РезультатыВыступленийНаСоревнованияхВсероссийскогоУровня.ПолучитьМакет("РасшифровкаНовый");
	ПараметрыОтчёта = СхемаКомпоновкиДанных.Параметры;
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;

	ПараметрыОтчёта.НачалоПериода.Значение = Параметры.НачалоПериода;
	ПараметрыОтчёта.КонецПериода.Значение  = Параметры.КонецПериода;
		
	Если Параметры.Свойство("ИмяПоляДляРасшифровки") Тогда
		
		Отбор = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Параметры.ИмяПоляДляРасшифровки);
		Отбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;	
		Отбор.ПравоеЗначение = Параметры.ИмяПоляДляРасшифровки;
		Отбор.Использование  = Истина;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ИмяПоляГруппировкиДляРасшифровки") Тогда
		
		Отбор = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Организация");
		Отбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ПравоеЗначение = Параметры.ИмяПоляГруппировкиДляРасшифровки;
		Отбор.Использование  = Истина;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ВидСпортаДляРасшифровки") Тогда
		
		Если РольДоступна("Методист") Тогда
			
			Отбор = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Отбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВидСпорта");
			Отбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			Отбор.ПравоеЗначение = Параметры.ВидСпортаДляРасшифровки;
			Отбор.Использование  = Истина;
			
		Иначе
			
			Отбор = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Отбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВидСпортаПоРеестру");
			Отбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			Отбор.ПравоеЗначение = Параметры.ВидСпортаДляРасшифровки;
			Отбор.Использование  = Истина;
				
		КонецЕсли;
			
	КонецЕсли;

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;         
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	Результат.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		
КонецПроцедуры

#КонецОбласти