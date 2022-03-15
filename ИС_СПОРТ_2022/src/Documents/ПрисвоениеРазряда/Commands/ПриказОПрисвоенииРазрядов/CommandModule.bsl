
#Область ПрограммныйИнтерфейс

// {Рарус adilas #16630 -Печатная форма Приказа на присвоение разряда 2021.06.08
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	#Если Не ВебКлиент Тогда
		Печать("Документ.ПрисвоениеРазряда", "ПФ_DOC_ПриказОПрисвоенииРазрядов",  ПараметрКоманды, "Приказ о присвоении разрядов Word");
	#Иначе
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати
		(
		"Документ.ПрисвоениеРазряда",
		"ПФ_MXL_ПриказОПрисвоенииРазрядов",
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
	
	Состояние(НСтр("ru='Выполняется формирование печатных форм'"));

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
				
				Попытка
					Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ОбластьШапка"]);
					УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта.ОбластьШапка, Ложь);
				Исключение
					ОбщегоНазначенияКлиент.СообщитьПользователю("Не удалось подключить область 'ОбластьШапка' по причине: " + ОписаниеОшибки());
				КонецПопытки;
				
				Для каждого СтрокаОбластиСоревнований Из ДанныеОбъекта.МассивСоревнований Цикл	
					Если ТипЗнч(СтрокаОбластиСоревнований) = Тип("Структура") Тогда		
						Попытка	
							Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ОбластьСоревнование"]);
							УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, СтрокаОбластиСоревнований.ОбластьСоревнование, Ложь);	
						Исключение
							ОбщегоНазначенияКлиент.СообщитьПользователю("Не удалось подключить область 'ОбластьСоревнование' по причине: " + ОписаниеОшибки());
						КонецПопытки;	
					Иначе			
						Для каждого СтрокаШапкаТаблицы Из СтрокаОбластиСоревнований Цикл	
							Если ТипЗнч(СтрокаШапкаТаблицы) = Тип("Структура") Тогда
								Попытка	
									Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ОбластьШапкаТаблицы"]);
									УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, СтрокаШапкаТаблицы.ОбластьШапкаТаблицы, Ложь);		
								Исключение
									ОбщегоНазначенияКлиент.СообщитьПользователю("Не удалось подключить область 'ОбластьШапкаТаблицы' по причине: " + ОписаниеОшибки());
								КонецПопытки;
							Иначе
								Для каждого СтрокаТаблицыСпортсмены Из СтрокаШапкаТаблицы Цикл
									Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ОбластьСтрокаТаблицыСпортсмены"]);
									УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, СтрокаТаблицыСпортсмены, Ложь);
								КонецЦикла;
							КонецЕсли;	
						КонецЦикла;	
					КонецЕсли;
				КонецЦикла;
				
				Попытка
					Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ОбластьПодвал"]);
					УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта.ОбластьПодвал, Ложь);	
				Исключение
					ОбщегоНазначенияКлиент.СообщитьПользователю("Не удалось подключить область 'ОбластьПодвал' по причине: " + ОписаниеОшибки());
				КонецПопытки;	
					
				УправлениеПечатьюКлиент.ПоказатьДокумент(ПечатнаяФорма);	
			Исключение
				ОбщегоНазначенияКлиент.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗакрытьОкноПечатнойФормы = Истина;
			КонецПопытки;	
		КонецЦикла;	
	КонецЦикла;
	
	УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма, ЗакрытьОкноПечатнойФормы);
	УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
	
	Состояние(НСтр("ru='Формирование печатных форм завершено'"));
		
КонецПроцедуры
// }Рарус adilas #16630 -Печатная форма Приказа на присвоение разряда 2021.06.08

#КонецОбласти