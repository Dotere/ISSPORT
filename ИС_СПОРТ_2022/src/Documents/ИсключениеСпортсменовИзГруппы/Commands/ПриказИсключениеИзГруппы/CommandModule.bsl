// + Адильбеков А.Б. 18.05.20 IN-6493 {

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	#Если Не ВебКлиент Тогда
		Печать("Документ.ИсключениеСпортсменовИзГруппы", "ПФ_DOC_ИсключениеИзКоманды",  ПараметрКоманды, "Отчисление из группы Word");
	#Иначе
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати
		(
		"Документ.ИсключениеСпортсменовИзГруппы",
		"ПФ_MXL_ИсключениеИзКоманды",
		ПараметрКоманды,
		Неопределено,
		Неопределено
		);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(ИмяМенеджераПечати, ИмяМакета, ДанныеПечати, НаименованиеМакета)
	
	Если ДанныеПечати.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;   
		
	МакетИДанныеОбъекта = УправлениеПечатьюВызовСервера.МакетыИДанныеОбъектовДляПечати(ИмяМенеджераПечати, ИмяМакета, ДанныеПечати);
	
	Вывести(ДанныеПечати, МакетИДанныеОбъекта, ИмяМакета, МакетИДанныеОбъекта.ЛокальныйКаталогФайловПечати, НаименованиеМакета);
	
КонецПроцедуры

&НаКлиенте
Процедура Вывести(ДанныеПечати, МакетИДанныеОбъекта, ИмяМакета, ЛокальныйКаталогФайловПечати, НаименованиеМакета)
	
	ТипМакета				= МакетИДанныеОбъекта.Макеты.ТипыМакетов[ИмяМакета];
	ДвоичныеДанныеМакетов	= МакетИДанныеОбъекта.Макеты.ДвоичныеДанныеМакетов;
	Области					= МакетИДанныеОбъекта.Макеты.ОписаниеОбластей;
		
	Макет = УправлениеПечатьюКлиент.ИнициализироватьМакетОфисногоДокумента(ДвоичныеДанныеМакетов[ИмяМакета], ТипМакета, ИмяМакета);
	Если Макет = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗакрытьОкноПечатнойФормы = Ложь;
	
	Для Каждого ОбъектДанных Из ДанныеПечати Цикл
		
		ДанныеОбъектаМассив     = МакетИДанныеОбъекта.Данные[ОбъектДанных][ИмяМакета];
		
		Для Каждого ДанныеОбъекта Из  ДанныеОбъектаМассив Цикл
			
			Попытка
				
				ПечатнаяФорма = УправлениеПечатьюКлиент.ИнициализироватьПечатнуюФорму(ТипМакета, Макет.НастройкиСтраницыМакета);
				Если ПечатнаяФорма = Неопределено Тогда
					УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
					Возврат;                                                             
				КонецЕсли;
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ОбластьШапка"]);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта.ОбластьШапка, Ложь);
								
				Для Каждого СтрокаСпортсмены Из ДанныеОбъекта.ОбластьШапкаТаблицы Цикл
					Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ОбластьШапкаТаблицы"]);
					УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, СтрокаСпортсмены, Ложь);
					Для каждого Строка Из СтрокаСпортсмены.МассивСтрокСпортсмены Цикл
						Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ОбластьСтрокаТаблицыСпортсмены"]);
						УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, Строка, Ложь);
					КонецЦикла; 			
				КонецЦикла; 
								
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ОбластьПодвал"]);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта.ОбластьПодвал, Ложь);	
				
				УправлениеПечатьюКлиент.ПоказатьДокумент(ПечатнаяФорма);
				
			Исключение
				ОбщегоНазначенияКлиент.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗакрытьОкноПечатнойФормы = Истина;
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЦикла;
	
	УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма, ЗакрытьОкноПечатнойФормы);
	УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
	
КонецПроцедуры

// - Адильбеков А.Б. 18.05.20 IN-6493 }